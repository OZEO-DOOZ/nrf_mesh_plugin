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
  DiscoveredDevice? _device;
  bool isProvisioningCompleted = false;
  E? callbacks;
  StreamSubscription<ConnectionStateUpdate>? _connectedDeviceStatusStream;

  int mtuSize = maxPacketSize;

  DiscoveredDevice? get device => _device;

  final FlutterReactiveBle _bleInstance;

  FlutterReactiveBle get bleInstance => _bleInstance;

  BleManager(this._bleInstance);

  Future<void> dispose() async {
    await callbacks?.dispose();
    await _connectedDeviceStatusStream?.cancel();
  }

  Future<void> connect(final DiscoveredDevice device) async {
    if (callbacks == null) {
      throw Exception('You have to set callbacks using callbacks(E callbacks) before connecting');
    }
    final _callbacks = callbacks as E;
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
          _device = device;
          await Future.delayed(Duration(milliseconds: 500));
          await _negotiateAndInitGatt();
          break;
        case DeviceConnectionState.disconnecting:
          if (!_callbacks.onDeviceDisconnectingController.isClosed &&
              _callbacks.onDeviceDisconnectingController.hasListener) {
            _callbacks.onDeviceDisconnectingController.add(device);
          }
          break;
        case DeviceConnectionState.disconnected:
          if (!_callbacks.onDeviceDisconnectedController.isClosed &&
              _callbacks.onDeviceDisconnectedController.hasListener) {
            _callbacks.onDeviceDisconnectedController.add(device);
          }
          _device = null;
          break;
      }
    }, onError: (Object error) async {
      await disconnect();
      if (!_callbacks.onErrorController.isClosed && _callbacks.onErrorController.hasListener) {
        _callbacks.onErrorController.add(BleManagerCallbacksError(_device, 'ERROR CAUGHT IN CONNECTION STREAM', error));
      }
    });
  }

  Future<void> _negotiateAndInitGatt() async {
    final _callbacks = callbacks as E;
    try {
      final service = await isRequiredServiceSupported();
      if (service == null) {
        throw Exception('Required service not found');
      }
      isProvisioningCompleted = service.serviceId == meshProxyUuid;
      await _callbacks.sendMtuToMeshManagerApi(isProvisioningCompleted ? 22 : mtuSize);
      if (!_callbacks.onServicesDiscoveredController.isClosed &&
          _callbacks.onServicesDiscoveredController.hasListener) {
        _callbacks.onServicesDiscoveredController.add(BleManagerCallbacksDiscoveredServices(_device!, service, false));
      }
      await initGatt();
      final negotiatedMtu = await _bleInstance.requestMtu(deviceId: _device!.id, mtu: 517);
      if (Platform.isAndroid) {
        mtuSize = negotiatedMtu - 3;
      } else if (Platform.isIOS) {
        mtuSize = negotiatedMtu;
      }
      await _callbacks.sendMtuToMeshManagerApi(mtuSize);
      if (!_callbacks.onDeviceReadyController.isClosed && callbacks!.onDeviceReadyController.hasListener) {
        _callbacks.onDeviceReadyController.add(_device!);
      }
    } catch (e) {
      if (!_callbacks.onErrorController.isClosed && callbacks!.onErrorController.hasListener) {
        _callbacks.onErrorController.add(BleManagerCallbacksError(device, 'GATT error', e));
      }
    }
  }

  @visibleForOverriding
  Future<DiscoveredService?> isRequiredServiceSupported();

  @visibleForOverriding
  Future<void> initGatt();

  Future<void> disconnect() async {
    if (callbacks != null) {
      final _callbacks = callbacks as E;
      if (!_callbacks.onDeviceDisconnectingController.isClosed &&
          _callbacks.onDeviceDisconnectingController.hasListener) {
        _callbacks.onDeviceDisconnectingController.add(_device!);
      }
      await _connectedDeviceStatusStream?.cancel();
      if (!_callbacks.onDeviceDisconnectedController.isClosed &&
          _callbacks.onDeviceDisconnectedController.hasListener) {
        _callbacks.onDeviceDisconnectedController.add(_device!);
      }
    } else {
      await _connectedDeviceStatusStream?.cancel();
    }
  }
}
