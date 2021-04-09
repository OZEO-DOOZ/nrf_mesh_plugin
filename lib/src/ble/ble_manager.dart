import 'dart:async';
import 'dart:io';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:meta/meta.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager_callbacks.dart';

const mtuSizeMax = 517;
const maxPacketSize = 20;
final meshProxyUuid = Uuid.parse('1828');
final meshProxyDataIn = Uuid.parse('2ADD');
final meshProxyDataOut = Uuid.parse('2ADE');
final meshProvisioningUuid = Uuid.parse('1827');
final meshProvisioningDataIn = Uuid.parse('2ADB');
final meshProvisioningDataOut = Uuid.parse('2ADC');
final clientCharacteristicConfigDescriptorUuid = Uuid.parse('2902');
final enableNotificationValue = [0x01, 0x00];
const Duration kConnectionTimeout = Duration(seconds: 30);

abstract class BleManager<E extends BleManagerCallbacks> {
  DiscoveredDevice _device;
  bool _connected = false;
  bool isProvisioningCompleted = false;
  E _callbacks;
  StreamSubscription<ConnectionStateUpdate> _connectedDeviceStatusStream;

  int mtuSize = maxPacketSize;

  set callbacks(final E callbacks) => _callbacks = callbacks;

  E get callbacks => _callbacks;

  DiscoveredDevice get device => _device;

  bool get connected => _connected;

  final FlutterReactiveBle _bleInstance;
  FlutterReactiveBle get bleInstance => _bleInstance;

  BleManager(this._bleInstance);

  Future<void> dispose() async {
    await callbacks?.dispose();
    await _connectedDeviceStatusStream?.cancel();
  }

  Future<void> connect(final DiscoveredDevice device) async {
    if (_callbacks == null) {
      throw Exception('You have to set callbacks using callbacks(E callbacks) before connecting');
    }
    if (!_callbacks.onServicesDiscoveredController.isClosed && _callbacks.onServicesDiscoveredController.hasListener) {
      _callbacks.onDeviceConnectingController.add(device);
    }
    _connectedDeviceStatusStream = _bleInstance
        .connectToDevice(id: device.id, connectionTimeout: kConnectionTimeout)
        .listen((connectionStateUpdate) async {
      switch (connectionStateUpdate.connectionState) {
        case DeviceConnectionState.connecting:
          if (!_callbacks.onDeviceConnectingController.isClosed &&
              _callbacks.onDeviceConnectingController.hasListener) {
            _callbacks.onDeviceConnectingController.add(device);
          }
          break;
        case DeviceConnectionState.connected:
          if (!_callbacks.onDeviceConnectedController.isClosed && _callbacks.onDeviceConnectedController.hasListener) {
            _callbacks.onDeviceConnectedController.add(device);
          }
          _connected = true;
          _device = device;
          await _negociateAndInitGatt();
          break;
        case DeviceConnectionState.disconnecting:
          if (!_callbacks.onDeviceDisconnectedController.isClosed &&
              _callbacks.onDeviceDisconnectedController.hasListener) {
            _callbacks.onDeviceDisconnectedController.add(device);
          }
          break;
        case DeviceConnectionState.disconnected:
          if (!_callbacks.onDeviceDisconnectedController.isClosed &&
              _callbacks.onDeviceDisconnectedController.hasListener) {
            _callbacks.onDeviceDisconnectedController.add(device);
          }
          break;
      }
    }, onError: (Object error) {
      if (!_callbacks.onErrorController.isClosed && _callbacks.onErrorController.hasListener) {
        _callbacks.onErrorController.add(BleManagerCallbacksError(_device, 'ERROR CAUGHT IN CONNECTION STREAM', error));
      }
    });
  }

  Future<void> _negociateAndInitGatt() async {
    final service = await isRequiredServiceSupported();
    if (service == null) {
      throw Exception('Required service not found');
    }
    isProvisioningCompleted = service?.serviceId == meshProxyUuid;
    await _callbacks.sendMtuToMeshManagerApi(isProvisioningCompleted ? 22 : mtuSize);
    if (!_callbacks.onServicesDiscoveredController.isClosed && _callbacks.onServicesDiscoveredController.hasListener) {
      _callbacks.onServicesDiscoveredController.add(BleManagerCallbacksDiscoveredServices(device, service, false));
    }
    await initGatt();
    final negociatedMtu = await _bleInstance.requestMtu(deviceId: _device.id, mtu: 517);
    if (Platform.isAndroid) {
      mtuSize = negociatedMtu - 3;
    } else if (Platform.isIOS) {
      mtuSize = negociatedMtu;
    }
    await _callbacks.sendMtuToMeshManagerApi(mtuSize);
    if (!_callbacks.onDeviceReadyController.isClosed && _callbacks.onDeviceReadyController.hasListener) {
      _callbacks.onDeviceReadyController.add(device);
    }
  }

  @visibleForOverriding
  Future<DiscoveredService> isRequiredServiceSupported();

  @visibleForOverriding
  Future<void> initGatt();

  Future<void> disconnect() async {
    if (!_callbacks.onDeviceDisconnectingController.isClosed &&
        _callbacks.onDeviceDisconnectingController.hasListener) {
      _callbacks.onDeviceDisconnectingController.add(_device);
    }
    await _connectedDeviceStatusStream.cancel();
    _connected = false;
    if (!_callbacks.onDeviceDisconnectedController.isClosed && _callbacks.onDeviceDisconnectedController.hasListener) {
      _callbacks.onDeviceDisconnectedController.add(_device);
    }
  }
}
