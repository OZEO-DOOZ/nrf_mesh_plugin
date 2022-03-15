import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:meta/meta.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

const mtuSizeMax = 517;
const maxPacketSize = 20;
final doozCustomServiceUuid =
    Platform.isAndroid ? Uuid.parse('00001400-0000-1000-8000-00805F9B34FB') : Uuid.parse('1400');
final doozCustomCharacteristicUuid =
    Platform.isAndroid ? Uuid.parse('00001401-0000-1000-8000-00805F9B34FB') : Uuid.parse('1401');
final meshProxyUuid = Platform.isAndroid ? Uuid.parse('00001828-0000-1000-8000-00805F9B34FB') : Uuid.parse('1828');
final meshProxyDataIn = Platform.isAndroid ? Uuid.parse('00002ADD-0000-1000-8000-00805F9B34FB') : Uuid.parse('2ADD');
final meshProxyDataOut = Platform.isAndroid ? Uuid.parse('00002ADE-0000-1000-8000-00805F9B34FB') : Uuid.parse('2ADE');
final meshProvisioningUuid =
    Platform.isAndroid ? Uuid.parse('00001827-0000-1000-8000-00805F9B34FB') : Uuid.parse('1827');
final meshProvisioningDataIn =
    Platform.isAndroid ? Uuid.parse('00002ADB-0000-1000-8000-00805F9B34FB') : Uuid.parse('2ADB');
final meshProvisioningDataOut =
    Platform.isAndroid ? Uuid.parse('00002ADC-0000-1000-8000-00805F9B34FB') : Uuid.parse('2ADC');
final clientCharacteristicConfigDescriptorUuid =
    Platform.isAndroid ? Uuid.parse('00002902-0000-1000-8000-00805f9b34fb') : Uuid.parse('2902');
const Duration _kConnectionTimeout = Duration(seconds: 30);

abstract class BleManager<E extends BleManagerCallbacks> {
  /// The current BLE device being managed if any
  DiscoveredDevice? _device;
  DiscoveredDevice? get device => _device;

  /// A [bool] used to adapt the connection process
  bool isProvisioningCompleted = false;

  /// The current MTU size (defaults to [maxPacketSize])
  int mtuSize = maxPacketSize;

  /// The callbacks used to handle events (should not be null at the time of calling connect method)
  E? callbacks;

  /// A [StreamSubscription] used to trigger events that describe the current [_device]'s connection status
  StreamSubscription<ConnectionStateUpdate>? _connectedDeviceStatusListener;

  /// A [StreamSubscription] used to listen to every connection status updates coming from BLE library
  late final StreamSubscription<ConnectionStateUpdate> _globalStatusListener;

  /// A [Completer] used to handle the async behavior of [connect] method
  late Completer<void> _connectCompleter;

  @protected
  Completer<void> get connectCompleter => _connectCompleter;

  /// The entry point for BLE library
  final FlutterReactiveBle _bleInstance;
  FlutterReactiveBle get bleInstance => _bleInstance;

  BleManager(this._bleInstance) {
    _globalStatusListener = _bleInstance.connectedDeviceStream.listen(_onGlobalStateUpdate);
  }

  Future<void> dispose() async {
    await callbacks?.dispose();
    await _connectedDeviceStatusListener?.cancel();
    await _globalStatusListener.cancel();
  }

  @visibleForOverriding
  Future<DiscoveredService?> isRequiredServiceSupported(bool shouldCheckDoozCustomService);

  /// A method that should implement the GATT initialization.
  ///
  /// In our case, it means requesting the highest possible MTU size and subcribing to notifications
  @visibleForOverriding
  Future<void> initGatt();

  Future<void> disconnect() async {
    if (_device == null) {
      _log('calling disconnect without connected device..');
    }
    await _connectedDeviceStatusListener?.cancel();
  }

  bool get _hasDeviceDisconnectedCallback =>
      !(callbacks?.onDeviceDisconnectedController.isClosed == true) &&
      callbacks!.onDeviceDisconnectedController.hasListener;
  bool get _hasErrorCallback =>
      !(callbacks?.onErrorController.isClosed == true) && callbacks!.onErrorController.hasListener;

  void _log(String msg) => debugPrint('[NordicNrfMesh] $msg');

  /// Will connect to the provided [DiscoveredDevice] using its id as identifier.
  /// This method will subscribe to connection status updates to :
  ///   - negotiate and init the GATT link with BLE device
  ///   - maintain the [_device] variable up to date (null: disconnected)
  ///   - return the [Future] when connection is successful (ie. BLE lib gave us [DeviceConnectionState.connected] event AND we negotiated the GATT)
  ///   - return a [TimeoutException] if connection is not established after [connectionTimeout]
  ///   - add event in [callbacks] sinks
  ///   - return any error on the stream or any given reason for [DeviceConnectionState.disconnected] events (usually a [GenericFailure])
  ///
  /// The [whitelist] has been introduced along with [doozCustomCharacteristicUuid] and is intended to be used like so :
  ///   - the whitelist is populated with MAC addresses and [shouldCheckDoozCustomService] is true
  ///   - it will connect to the BLE device and check the MAC address that should be stored in the DooZ custom charac
  /// If the read MAC is not in the [whitelist], then this method will trigger an error event and complete with an error.
  ///
  /// (because this is a DooZ application specific flow, we made these parameters optional)
  Future<void> connect(
    final DiscoveredDevice discoveredDevice, {
    Duration connectionTimeout = _kConnectionTimeout,
    List<String>? whitelist,
    bool shouldCheckDoozCustomService = false,
  }) async {
    if (callbacks == null) {
      throw const BleManagerException(
        BleManagerFailureCode.callbacks,
        'You have to set callbacks using callbacks(E callbacks) before connecting',
      );
    }
    final _whitelist = whitelist ?? [discoveredDevice.id];
    // cancel any existing sub, if connected to any device,
    // events will be handled by [_deviceStatusStream] or by
    // [_connectedDeviceStatusStream] first if same device as [discoveredDevice]
    await _connectedDeviceStatusListener?.cancel();
    final watch = Stopwatch()..start();
    final _callbacks = callbacks as E;
    _connectCompleter = Completer<void>();
    final connectTimeout = Timer(connectionTimeout, () {
      if (!_connectCompleter.isCompleted) {
        _log('connect failed after ${watch.elapsedMilliseconds}ms');
        _connectCompleter.completeError(TimeoutException('connection timed out', connectionTimeout));
      }
      _connectedDeviceStatusListener!.cancel();
    });
    _connectedDeviceStatusListener = _bleInstance
        .connectToDevice(
          id: discoveredDevice.id,
          // added here so the library sets autoconnect flag to false, but timeout duration seems ignored
          connectionTimeout: connectionTimeout,
        )
        .listen(
            (ConnectionStateUpdate connectionStateUpdate) {
              switch (connectionStateUpdate.connectionState) {
                case DeviceConnectionState.connecting:
                  _device = discoveredDevice;
                  break;
                case DeviceConnectionState.connected:
                  _negotiateAndInitGatt(shouldCheckDoozCustomService).then((_) async {
                    if (!_connectCompleter.isCompleted) {
                      String? deviceId = _device!.id;
                      if (shouldCheckDoozCustomService && !_whitelist.contains(deviceId)) {
                        // because white list is intended to be populated with mac addresses,
                        // the deviceId may not be in the list if user is on iOS as it's using generated UUIDs
                        // so use dooz custom BLE charac to read mac address
                        deviceId = await getMacId();
                      }
                      if (!_whitelist.contains(deviceId)) {
                        throw BleManagerException(
                          BleManagerFailureCode.proxyWhitelist,
                          '$deviceId not in $_whitelist',
                        );
                      } else {
                        _connectCompleter.complete();
                        if (!_callbacks.onDeviceReadyController.isClosed &&
                            _callbacks.onDeviceReadyController.hasListener) {
                          _callbacks.onDeviceReadyController.add(_device!);
                        }
                      }
                    }
                  }).catchError(
                    (e, s) {
                      if (!_callbacks.onErrorController.isClosed && _callbacks.onErrorController.hasListener) {
                        _callbacks.onErrorController.add(BleManagerCallbacksError(_device, 'GATT error', e));
                      }
                      if (!_connectCompleter.isCompleted) {
                        // will notify for error as the connection could not be properly established
                        _log('connect failed after ${watch.elapsedMilliseconds}ms');
                        connectTimeout.cancel();
                        _connectCompleter.completeError(e);
                      }
                    },
                  );
                  break;
                case DeviceConnectionState.disconnecting:
                  // handled by _globalStatusListener
                  break;
                case DeviceConnectionState.disconnected:
                  if (_device != null) {
                    // error may have been caught upon connection initialization or during connection
                    GenericFailure? maybeError = connectionStateUpdate.failure;
                    if (!_connectCompleter.isCompleted) {
                      // will notify for error as the connection could not be properly established
                      _log('connect failed after ${watch.elapsedMilliseconds}ms');
                      if (maybeError != null) {
                        _log('error : $maybeError');
                        connectTimeout.cancel();
                        _connectCompleter.completeError(maybeError);
                      } else {
                        const err = BleManagerException(
                          BleManagerFailureCode.unexpectedDisconnection,
                          'disconnect event before device is ready',
                        );
                        _log('error : $err');
                        connectTimeout.cancel();
                        _connectCompleter.completeError(err);
                      }
                    }
                  } else {
                    _log('seems that you were already connected to that node..'
                        'ignoring connection state: $connectionStateUpdate');
                  }
                  break;
              }
            },
            cancelOnError: true,
            onError: (Object error) {
              if (!_callbacks.onErrorController.isClosed && _callbacks.onErrorController.hasListener) {
                _callbacks.onErrorController
                    .add(BleManagerCallbacksError(_device, 'ERROR CAUGHT IN CONNECTION STREAM', error));
              }
              if (!_connectCompleter.isCompleted) {
                // will notify for error as the connection could not be properly established
                _log('connect failed after ${watch.elapsedMilliseconds}ms');
                connectTimeout.cancel();
                _connectCompleter.completeError(error);
              }
            });
    await _connectCompleter.future;
    connectTimeout.cancel();
    _log('connect took ${watch.elapsedMilliseconds}ms');
  }

  String _toMacAddress(final List<int> bytes) =>
      bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();

  /// This method will read the [doozCustomCharacteristicUuid] if a device is connected and return the MAC address stored
  Future<String?> getMacId() async {
    String? macId;
    try {
      final macIdChar = await bleInstance.readCharacteristic(QualifiedCharacteristic(
        characteristicId: doozCustomCharacteristicUuid,
        serviceId: doozCustomServiceUuid,
        deviceId: _device!.id,
      ));
      final macIdList = macIdChar.reversed.toList();
      macId = _toMacAddress(macIdList);
      _log('got mac adr from custom service ! $macId');
    } catch (e) {
      _log('caught error during reading dooz custom charac $e');
    }
    return macId;
  }

  Future<void> _negotiateAndInitGatt(bool shouldCheckDoozCustomService) async {
    final _callbacks = callbacks as E;
    DiscoveredService? service;
    try {
      service = await isRequiredServiceSupported(shouldCheckDoozCustomService);
    } on BleManagerException catch (e) {
      _log('the device does not have the DooZ custom BLE service $e');
      rethrow; // handled in catchError block
    } catch (e) {
      _log('caught error during discover service : $e');
    }
    if (service != null) {
      // valid mesh node
      if (!_callbacks.onServicesDiscoveredController.isClosed &&
          _callbacks.onServicesDiscoveredController.hasListener) {
        _callbacks.onServicesDiscoveredController.add(BleManagerCallbacksDiscoveredServices(_device!, service));
      }
      try {
        await initGatt();
      } catch (e) {
        _log('caught error during GATT initialization : $e');
        throw BleManagerException(BleManagerFailureCode.initGatt, '$e');
      }
    } else {
      // invalid BLE device
      throw const BleManagerException(BleManagerFailureCode.serviceNotFound, 'Required service not found');
    }
  }

  /// This handler will propagate events to any existing callback (if the update is expected).
  ///
  /// On confirmed disconnection event, it will reset the [_device] to `null` reflecting the current state of [BleManager] that manage one device at a time.
  void _onGlobalStateUpdate(ConnectionStateUpdate connectionStateUpdate) {
    final _callbacks = callbacks;
    if (_callbacks == null) {
      _log('no callbacks set...received $connectionStateUpdate');
    } else {
      switch (connectionStateUpdate.connectionState) {
        case DeviceConnectionState.connecting:
          if (_device != null) {
            if (!_callbacks.onDeviceConnectingController.isClosed &&
                _callbacks.onDeviceConnectingController.hasListener) {
              _callbacks.onDeviceConnectingController.add(connectionStateUpdate);
            } else {
              _log('received $connectionStateUpdate');
            }
          } else {
            _log('received unexpected connection state update : $connectionStateUpdate');
          }
          break;
        case DeviceConnectionState.connected:
          if (_device != null && connectionStateUpdate.deviceId == _device!.id) {
            if (!_callbacks.onDeviceConnectedController.isClosed &&
                _callbacks.onDeviceConnectedController.hasListener) {
              _callbacks.onDeviceConnectedController.add(connectionStateUpdate);
            } else {
              _log('received $connectionStateUpdate');
            }
          } else {
            _log('received unexpected connection state update : $connectionStateUpdate');
          }
          break;
        case DeviceConnectionState.disconnecting:
          if (_device != null) {
            if (!(_callbacks.onDeviceDisconnectingController.isClosed == true) &&
                _callbacks.onDeviceDisconnectingController.hasListener) {
              _callbacks.onDeviceDisconnectingController.add(connectionStateUpdate);
            } else {
              _log('received $connectionStateUpdate');
            }
          } else {
            _log('received unexpected connection state update : $connectionStateUpdate');
          }
          break;
        case DeviceConnectionState.disconnected:
          if (_device != null) {
            // error may have been caught upon connection initialization or during connection
            GenericFailure? maybeError = connectionStateUpdate.failure;
            // determine if callbacks are set
            if (_hasDeviceDisconnectedCallback || _hasErrorCallback) {
              if (_hasErrorCallback) {
                // if all callbacks are available, prioritize error callback if any error is given in the event
                if (maybeError != null) {
                  _callbacks.onErrorController.add(BleManagerCallbacksError(_device, maybeError.message, maybeError));
                } else {
                  if (_hasDeviceDisconnectedCallback) {
                    _callbacks.onDeviceDisconnectedController.add(connectionStateUpdate);
                  } else {
                    _log('device has been disconnected ! $connectionStateUpdate');
                  }
                }
              } else {
                _callbacks.onDeviceDisconnectedController.add(connectionStateUpdate);
              }
            } else {
              _log('received $connectionStateUpdate');
            }
            if (maybeError == null) {
              // BLE library will notify several disconnected events,
              // but when disconnection process is done, the event should have no error,
              // so here we wait for the error to be null before assigning null to _device
              if (_device!.id == connectionStateUpdate.deviceId) {
                _device = null;
              }
            }
          } else {
            _log('received unexpected connection state update : $connectionStateUpdate');
          }
          break;
      }
    }
  }
}
