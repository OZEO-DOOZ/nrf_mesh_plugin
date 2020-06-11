import 'dart:async';

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

  @protected
  int mtuSize = maxPacketSize;

  set callbacks(final E callbacks) => _callbacks = callbacks;

  E get callbacks => _callbacks;

  Future<void> connect(final BluetoothDevice device) async {
    if (_callbacks == null) {
      throw Exception('You have to set callbacks using callbacks(E callbacks) before connecting');
    }
    if (_connected) {
      return;
    }
    _callbacks.onDeviceConnectingController.add(device);
    await device.connect(autoConnect: false);
    _device = device;
    _connected = true;
    await _mtuSizeSubscription?.cancel();
    _mtuSizeSubscription = device.mtu.listen((event) {
      mtuSize = event - 3;
    });
    await _callbacks.sendMtuToMeshManagerApi(await device.mtu.first);
    _callbacks.onDeviceConnectedController.add(device);
    final service = await isRequiredServiceSupported(device);
    if (service == null) {
      print('required service not found');
      return;
    }
    _callbacks.onServicesDiscoveredController.add(BleManagerCallbacksDiscoveredServices(device, service, false));
    //  init gatt
    await initGatt(device);
    _callbacks.onDeviceReadyController.add(device);
  }

  @visibleForOverriding
  Future<BluetoothService> isRequiredServiceSupported(final BluetoothDevice device);

  @visibleForOverriding
  Future<void> initGatt(final BluetoothDevice device);

  Future<void> disconnect() async {
    _callbacks.onDeviceDisconnectingController.add(_device);
    await _device.disconnect();
    _callbacks.onDeviceDisconnectedController.add(_device);
  }
}
