import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:meta/meta.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager_callbacks.dart';

const mtuSizeMax = 517;
const maxPacketSize = 20;
final meshProxyUuid = Guid('00001828-0000-1000-8000-00805F9B34FB');
final meshProxyDataIn = Guid('00002ADD-0000-1000-8000-00805F9B34FB');
final meshProxyDataOut = Guid('00002ADE-0000-1000-8000-00805F9B34FB');
final meshProvisioningUuid = Guid('00001827-0000-1000-8000-00805F9B34FB');
final meshProvisioningDataIn = Guid('00002ADB-0000-1000-8000-00805F9B34FB');
final meshProvisioningDataOut = Guid('00002ADC-0000-1000-8000-00805F9B34FB');
final clientCharacteristicConfigDescriptorUuid = Guid('00002902-0000-1000-8000-00805f9b34fb');
final enableNotificationValue = [0x01, 0x00];

abstract class BleManager<E extends BleManagerCallbacks> {
  BluetoothDevice _device;
  bool _connected = false;
  bool isProvisioningCompleted = false;
  E _callbacks;

  StreamSubscription<int> _mtuSizeSubscription;

  int mtuSize = maxPacketSize;

  set callbacks(final E callbacks) => _callbacks = callbacks;

  E get callbacks => _callbacks;

  BluetoothDevice get device => _device;

  bool get connected => _connected;

  Future<void> dispose() async {
    await callbacks?.dispose();
    await _mtuSizeSubscription?.cancel();
  }

  Future<void> connect(final BluetoothDevice device) async {
    if (_callbacks == null) {
      throw Exception('You have to set callbacks using callbacks(E callbacks) before connecting');
    }
    _callbacks.onDeviceConnectingController.add(device);
    await device.connect(autoConnect: false);
    _connected = true;
    _callbacks.onDeviceConnectedController.add(device);
    _device = device;
    _mtuSizeSubscription = device.mtu.skip(1).listen((event) async {
      print('mtu changed $event');

      if (Platform.isAndroid) {
        mtuSize = event - 3;
      } else if (Platform.isIOS) {
        mtuSize = event;
      }

      await _callbacks.sendMtuToMeshManagerApi(mtuSize);
    });
    await _callbacks.sendMtuToMeshManagerApi(mtuSize);
    final service = await isRequiredServiceSupported(device);
    if (service == null) {
      print('required service not found');
      return;
    }
    _callbacks.onServicesDiscoveredController.add(BleManagerCallbacksDiscoveredServices(device, service, false));
    await initGatt(device);
    final fMtuChanged = device.mtu.skip(1).first;
    if (Platform.isAndroid) {
      await device.requestMtu(517);
      await fMtuChanged;
    }

    _callbacks.onDeviceReadyController.add(device);
  }

  @visibleForOverriding
  Future<BluetoothService> isRequiredServiceSupported(final BluetoothDevice device);

  @visibleForOverriding
  Future<void> initGatt(final BluetoothDevice device);

  Future<void> disconnect() async {
    _callbacks.onDeviceDisconnectingController.add(_device);
    await _device.disconnect();
    _connected = false;
    _callbacks.onDeviceDisconnectedController.add(_device);
    await _mtuSizeSubscription.cancel();
  }
}
