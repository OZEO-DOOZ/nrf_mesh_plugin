import 'dart:async';
import 'dart:io';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:meta/meta.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager_callbacks.dart';

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
      if (!_callbacks.onDeviceReadyController.isClosed && _callbacks.onDeviceReadyController.hasListener) {
        _callbacks.onDeviceReadyController.add(_device!);
      }
    } catch (e) {
      if (!_callbacks.onErrorController.isClosed && _callbacks.onErrorController.hasListener) {
        _callbacks.onErrorController.add(BleManagerCallbacksError(_device, 'GATT error', e));
      }
    }
  }

  @visibleForOverriding
  Future<DiscoveredService?> isRequiredServiceSupported();

  @visibleForOverriding
  Future<void> initGatt();

  Future<void> disconnect() async {
    if (_device != null) {
      // we are connected
      if (callbacks != null) {
        // callbacks are defined, add events and cancel connection stream
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
        // no callbacks, just cancel connection stream
        await _connectedDeviceStatusStream?.cancel();
      }
    } else {
      print('calling disconnect without connected device');
    }
  }
}
