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
  DiscoveredDevice? _device;
  bool isProvisioningCompleted = false;
  E? callbacks;
  StreamSubscription<ConnectionStateUpdate>? _connectedDeviceStatusStream;

  int mtuSize = maxPacketSize;

  DiscoveredDevice? get device => _device;

  final FlutterReactiveBle _bleInstance;

  FlutterReactiveBle get bleInstance => _bleInstance;

  BleManager(this._bleInstance);

  void _log(String msg) => debugPrint('[NordicNrfMesh] $msg');

  Future<void> dispose() async {
    await callbacks?.dispose();
    await _connectedDeviceStatusStream?.cancel();
  }

  /// Will connect to the provided [DiscoveredDevice] using its [id] as identifier.
  /// This method will subscribe to connection status updates to :
  ///   - negotiate and init the GATT link with BLE device
  ///   - maintain the [_device] variable up to date (null: disconnected)
  ///   - return the [Future] when connection is successful (ie. BLE lib gave us [DeviceConnectionState.connected] event AND we negotiated the GATT)
  ///   - return a [TimeoutException] if connection is not established after [connectionTimeout]
  ///   - add event in [callbacks] sinks
  ///   - return any error on the stream or any given reason for [DeviceConnectionState.disconnected] events (usually a [GenericFailure])
  Future<void> connect(final DiscoveredDevice device, {Duration connectionTimeout = kConnectionTimeout}) async {
    if (callbacks == null) {
      throw const BleManagerException(
          BleManagerFailureCode.callbacks, 'You have to set callbacks using callbacks(E callbacks) before connecting');
    }
    await _connectedDeviceStatusStream?.cancel(); // cancel any existing sub
    _device = null;
    final watch = Stopwatch()..start();
    final _callbacks = callbacks as E;
    final waitForConnect = Completer<void>();
    final connectTimeout = Timer(connectionTimeout, () {
      if (!waitForConnect.isCompleted) {
        _log('connect failed ${watch.elapsedMilliseconds}ms');
        waitForConnect.completeError(TimeoutException('connection timed out', connectionTimeout));
      }
      _connectedDeviceStatusStream!.cancel();
    });
    _connectedDeviceStatusStream = _bleInstance
        .connectToDevice(
          id: device.id,
          // added here so the library sets autoconnect flag to false, but timeout duration seems ignored
          connectionTimeout: connectionTimeout,
        )
        .listen(
            (connectionStateUpdate) async {
              switch (connectionStateUpdate.connectionState) {
                case DeviceConnectionState.connecting:
                  if (!_callbacks.onDeviceConnectingController.isClosed &&
                      _callbacks.onDeviceConnectingController.hasListener) {
                    _callbacks.onDeviceConnectingController.add(device);
                  }
                  _device = device;
                  break;
                case DeviceConnectionState.connected:
                  if (!_callbacks.onDeviceConnectedController.isClosed &&
                      _callbacks.onDeviceConnectedController.hasListener) {
                    _callbacks.onDeviceConnectedController.add(device);
                  }
                  _negotiateAndInitGatt().then((_) => waitForConnect.complete()).catchError(
                    (e, s) {
                      if (!_callbacks.onErrorController.isClosed && _callbacks.onErrorController.hasListener) {
                        _callbacks.onErrorController.add(BleManagerCallbacksError(_device, 'GATT error', e));
                      }
                      if (!waitForConnect.isCompleted) {
                        // will notify for error as the connection could not be properly established
                        _log('connect failed after ${watch.elapsedMilliseconds}ms');
                        waitForConnect.completeError(e);
                      }
                    },
                    test: (e) => e is BleManagerException,
                  );
                  break;
                case DeviceConnectionState.disconnecting:
                  if (!_callbacks.onDeviceDisconnectingController.isClosed &&
                      _callbacks.onDeviceDisconnectingController.hasListener) {
                    _callbacks.onDeviceDisconnectingController.add(device);
                  }
                  break;
                case DeviceConnectionState.disconnected:
                  if (_device != null) {
                    // error may have been caught upon connection initialization or during connection
                    GenericFailure? maybeError = connectionStateUpdate.failure;
                    // determine if callbacks are set
                    final _hasDeviceDisconnectedCallback = !_callbacks.onDeviceDisconnectedController.isClosed &&
                        _callbacks.onDeviceDisconnectedController.hasListener;
                    final _hasErrorCallback =
                        !_callbacks.onErrorController.isClosed && _callbacks.onErrorController.hasListener;
                    if (_hasDeviceDisconnectedCallback) {
                      if (_hasErrorCallback) {
                        // if every callbacks, will prioritize error callback if the event contains any non null error Object
                        if (maybeError != null) {
                          _callbacks.onErrorController
                              .add(BleManagerCallbacksError(device, maybeError.message, maybeError));
                        } else {
                          _callbacks.onDeviceDisconnectedController.add(device);
                        }
                      } else {
                        // if only listening to disconnect events
                        _callbacks.onDeviceDisconnectedController.add(device);
                      }
                    }
                    if (!waitForConnect.isCompleted) {
                      if (maybeError != null) {
                        // will notify for error as the connection could not be properly established
                        waitForConnect.completeError(maybeError);
                      } else {
                        waitForConnect.complete();
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
              if (!waitForConnect.isCompleted) {
                // will notify for error as the connection could not be properly established
                _log('connect failed after ${watch.elapsedMilliseconds}ms');
                waitForConnect.completeError(error);
              }
            });
    await waitForConnect.future;
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
      _log('calling disconnect without connected device');
    }
    final _callbacks = callbacks;
    if (!(_callbacks?.onDeviceDisconnectingController.isClosed == true) &&
        _callbacks!.onDeviceDisconnectingController.hasListener) {
      _callbacks.onDeviceDisconnectingController.add(_device);
    }
    await _connectedDeviceStatusStream?.cancel();
    _device = null;
    if (!(_callbacks?.onDeviceDisconnectedController.isClosed == true) &&
        _callbacks!.onDeviceDisconnectedController.hasListener) {
      _callbacks.onDeviceDisconnectedController.add(_device);
    }
  }
}
