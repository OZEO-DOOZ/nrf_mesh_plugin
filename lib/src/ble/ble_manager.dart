import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:meta/meta.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager_callbacks.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';

const mtuSizeMax = 517;
const maxPacketSize = 20;
final meshProxyUuid = Uuid.parse('00001828-0000-1000-8000-00805F9B34FB');
final meshProxyDataIn = Uuid.parse('00002ADD-0000-1000-8000-00805F9B34FB');
final meshProxyDataOut = Uuid.parse('00002ADE-0000-1000-8000-00805F9B34FB');
final meshProvisioningUuid = Uuid.parse('00001827-0000-1000-8000-00805F9B34FB');
final meshProvisioningDataIn = Uuid.parse('00002ADB-0000-1000-8000-00805F9B34FB');
final meshProvisioningDataOut = Uuid.parse('00002ADC-0000-1000-8000-00805F9B34FB');
final clientCharacteristicConfigDescriptorUuid = Uuid.parse('00002902-0000-1000-8000-00805f9b34fb');
final enableNotificationValue = [0x01, 0x00];
const Duration kConnectionTimeout = Duration(seconds: 30);

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
  StreamSubscription<ConnectionStateUpdate>? _connectedDeviceStatusStream;

  /// A [StreamSubscription] used to listen to every connection status updates coming from BLE library
  late final StreamSubscription<ConnectionStateUpdate> _deviceStatusStream;

  /// A [Completer] used to handle the async behavior of [connect] method
  late Completer<void> _connectCompleter;

  @protected
  Completer<void> get connectCompleter => _connectCompleter;

  /// The entry point for BLE library
  final FlutterReactiveBle _bleInstance;
  FlutterReactiveBle get bleInstance => _bleInstance;

  BleManager(this._bleInstance) {
    _deviceStatusStream = _bleInstance.connectedDeviceStream.listen((connectionStateUpdate) {
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
              if (_hasDeviceDisconnectedCallback) {
                if (_hasErrorCallback) {
                  // if all callbacks are available, prioritize error callback if any error is given in the event
                  if (maybeError != null) {
                    _callbacks.onErrorController.add(BleManagerCallbacksError(_device, maybeError.message, maybeError));
                  } else {
                    _callbacks.onDeviceDisconnectedController.add(connectionStateUpdate);
                  }
                } else {
                  _callbacks.onDeviceDisconnectedController.add(connectionStateUpdate);
                }
              } else {
                _log('received $connectionStateUpdate');
              }
              _device = null;
            } else {
              _log('received unexpected connection state update : $connectionStateUpdate');
            }
            break;
        }
      }
    });
  }

  void _log(String msg) => debugPrint('[NordicNrfMesh] $msg');

  bool get _hasDeviceDisconnectedCallback =>
      !(callbacks?.onDeviceDisconnectedController.isClosed == true) &&
      callbacks!.onDeviceDisconnectedController.hasListener;
  bool get _hasErrorCallback =>
      !(callbacks?.onErrorController.isClosed == true) && callbacks!.onErrorController.hasListener;

  Future<void> dispose() async {
    await callbacks?.dispose();
    await _connectedDeviceStatusStream?.cancel();
    await _deviceStatusStream.cancel();
  }

  /// Will connect to the provided [DiscoveredDevice] using its [id] as identifier.
  /// This method will subscribe to connection status updates to :
  ///   - negotiate and init the GATT link with BLE device
  ///   - maintain the [_device] variable up to date (null: disconnected)
  ///   - return the [Future] when connection is successful (ie. BLE lib gave us [DeviceConnectionState.connected] event AND we negotiated the GATT)
  ///   - return a [TimeoutException] if connection is not established after [connectionTimeout]
  ///   - add event in [callbacks] sinks
  ///   - return any error on the stream or any given reason for [DeviceConnectionState.disconnected] events (usually a [GenericFailure])
  Future<void> connect(final DiscoveredDevice discoveredDevice,
      {Duration connectionTimeout = kConnectionTimeout}) async {
    if (callbacks == null) {
      throw const BleManagerException(
          BleManagerFailureCode.callbacks, 'You have to set callbacks using callbacks(E callbacks) before connecting');
    }
    _device = discoveredDevice; // set before calling cancel
    // cancel any existing sub, if connected to any device,
    // events will be handled by [_deviceStatusStream] or by
    // [_connectedDeviceStatusStream] first if same device as [discoveredDevice]
    await _connectedDeviceStatusStream?.cancel();
    final watch = Stopwatch()..start();
    final _callbacks = callbacks as E;
    _connectCompleter = Completer<void>();
    bool _isConnectionInitiated = false; // helps to handle calls to this method with device same as currently connected
    final connectTimeout = Timer(connectionTimeout, () {
      if (!_connectCompleter.isCompleted) {
        _log('connect failed ${watch.elapsedMilliseconds}ms');
        _connectCompleter.completeError(TimeoutException('connection timed out', connectionTimeout));
      }
      _connectedDeviceStatusStream!.cancel();
    });
    _connectedDeviceStatusStream = _bleInstance
        .connectToDevice(
          id: discoveredDevice.id,
          // added here so the library sets autoconnect flag to false, but timeout duration seems ignored
          connectionTimeout: connectionTimeout,
        )
        .listen(
            (connectionStateUpdate) async {
              switch (connectionStateUpdate.connectionState) {
                case DeviceConnectionState.connecting:
                  _isConnectionInitiated = true;
                  break;
                case DeviceConnectionState.connected:
                  _negotiateAndInitGatt().then((_) => _connectCompleter.complete()).catchError(
                    (e, s) {
                      if (!_callbacks.onErrorController.isClosed && _callbacks.onErrorController.hasListener) {
                        _callbacks.onErrorController.add(BleManagerCallbacksError(_device, 'GATT error', e));
                      }
                      if (!_connectCompleter.isCompleted) {
                        // will notify for error as the connection could not be properly established
                        _log('connect failed after ${watch.elapsedMilliseconds}ms');
                        _connectCompleter.completeError(e);
                      }
                    },
                    test: (e) => e is BleManagerException,
                  );
                  break;
                case DeviceConnectionState.disconnecting:
                  // handled by _deviceStatusStream
                  break;
                case DeviceConnectionState.disconnected:
                  if (!_isConnectionInitiated) {
                    // error may have been caught upon connection initialization or during connection
                    GenericFailure? maybeError = connectionStateUpdate.failure;
                    if (!_connectCompleter.isCompleted) {
                      if (maybeError != null) {
                        // will notify for error as the connection could not be properly established
                        _connectCompleter.completeError(maybeError);
                      } else {
                        _connectCompleter.complete();
                      }
                    }
                    _device = null;
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
                _connectCompleter.completeError(error);
              }
            });
    await _connectCompleter.future;
    connectTimeout.cancel();
    _log('connect took ${watch.elapsedMilliseconds}ms');
  }

  Future<void> _negotiateAndInitGatt() async {
    final _callbacks = callbacks as E;
    DiscoveredService? service;
    try {
      service = await isRequiredServiceSupported();
    } catch (e) {
      _log('caught error during discover service : $e');
    }

    if (service != null) {
      // valid mesh node
      try {
        await _callbacks.sendMtuToMeshManagerApi(isProvisioningCompleted ? 22 : mtuSize);
        if (!_callbacks.onServicesDiscoveredController.isClosed &&
            _callbacks.onServicesDiscoveredController.hasListener) {
          _callbacks.onServicesDiscoveredController
              .add(BleManagerCallbacksDiscoveredServices(_device!, service, false));
        }
        await initGatt();
        final negotiatedMtu = await _bleInstance.requestMtu(deviceId: _device!.id, mtu: 517);
        if (Platform.isAndroid) {
          mtuSize = negotiatedMtu - 3;
        } else if (Platform.isIOS) {
          mtuSize = negotiatedMtu;
        }
        await _callbacks.sendMtuToMeshManagerApi(mtuSize);
        if (!_callbacks.onDeviceReadyController.isClosed && _callbacks.onDeviceReadyController.hasListener) {
          _callbacks.onDeviceReadyController.add(_device!);
        }
      } catch (e) {
        _log('caught error during negociation : $e');
        throw BleManagerException(BleManagerFailureCode.negociation, '$e');
      }
    } else {
      throw const BleManagerException(BleManagerFailureCode.serviceNotFound, 'Required service not found');
    }
  }

  @visibleForOverriding
  Future<DiscoveredService?> isRequiredServiceSupported();

  @visibleForOverriding
  Future<void> initGatt();

  Future<void> disconnect() async {
    if (_device == null) {
      _log('calling disconnect without connected device..');
    }
    await _connectedDeviceStatusStream?.cancel();
  }
}
