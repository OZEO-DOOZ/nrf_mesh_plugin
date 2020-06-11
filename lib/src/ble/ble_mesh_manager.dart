import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager_callbacks.dart';

class BleMeshManager<T extends BleMeshManagerCallbacks> extends BleManager<T> {
  bool _isProvisioningComplete = false;

  BluetoothCharacteristic _meshProxyDataInCharacteristic;
  BluetoothCharacteristic _meshProxyDataOutCharacteristic;
  BluetoothCharacteristic _meshProvisioningDataInCharacteristic;
  BluetoothCharacteristic _meshProvisioningDataOutCharacteristic;

  StreamSubscription<List<int>> _meshProxyDataOutSubscription;
  StreamSubscription<List<int>> _meshProvisioningDataOutSubscription;

  void onDeviceDisconnected(final BluetoothDevice device) async {
    _isProvisioningComplete = false;
    _meshProvisioningDataInCharacteristic = null;
    _meshProvisioningDataOutCharacteristic = null;
    _meshProxyDataInCharacteristic = null;
    _meshProxyDataOutCharacteristic = null;
    await _meshProxyDataOutSubscription?.cancel();
    _meshProxyDataOutSubscription = null;
    await _meshProvisioningDataOutSubscription?.cancel();
    _meshProvisioningDataOutSubscription = null;
  }

  @override
  Future<BluetoothService> isRequiredServiceSupported(final BluetoothDevice device) async {
    var writeRequest = false;
    final services = await device.discoverServices();
    var service = services.firstWhere((element) => element.uuid == meshProxyUuid, orElse: () => null);
    if (service != null) {
      _isProvisioningComplete = true;
      _meshProxyDataInCharacteristic =
          service.characteristics.firstWhere((element) => element.uuid == meshProxyDataIn, orElse: () => null);
      _meshProxyDataOutCharacteristic =
          service.characteristics.firstWhere((element) => element.uuid == meshProxyDataOut, orElse: () => null);
      if (_meshProxyDataInCharacteristic != null) {
        writeRequest = _meshProxyDataInCharacteristic.properties.writeWithoutResponse;
      }
      if (_meshProxyDataInCharacteristic != null && _meshProxyDataOutCharacteristic != null && writeRequest) {
        return service;
      }
      return null;
    } else {
      service = services.firstWhere((element) => element.uuid == meshProvisioningUuid, orElse: () => null);
      if (service != null) {
        _isProvisioningComplete = false;
        _meshProvisioningDataInCharacteristic =
            service.characteristics.firstWhere((element) => element.uuid == meshProvisioningDataIn, orElse: () => null);
        _meshProvisioningDataOutCharacteristic = service.characteristics
            .firstWhere((element) => element.uuid == meshProvisioningDataOut, orElse: () => null);
        if (_meshProvisioningDataInCharacteristic != null) {
          writeRequest = _meshProvisioningDataInCharacteristic.properties.writeWithoutResponse;
        }
        if (_meshProvisioningDataInCharacteristic != null &&
            _meshProvisioningDataOutCharacteristic != null &&
            writeRequest) {
          return service;
        }
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> initGatt(final BluetoothDevice device) async {
    if (_isProvisioningComplete) {
      final dataOut = _meshProxyDataOutCharacteristic.properties;
      if (dataOut.read) {
        await _meshProxyDataOutCharacteristic.read();
      }

      final dataIn = _meshProxyDataInCharacteristic.properties;
      if (dataIn.read) {
        await _meshProxyDataInCharacteristic.read();
      }

      if (dataOut.notify) {
        await _meshProxyDataOutSubscription?.cancel();
        _meshProxyDataOutSubscription = _meshProxyDataOutCharacteristic.value.listen((event) async {
          callbacks.onDataReceivedController
              .add(BleMeshManagerCallbacksDataReceived(device, await device.mtu.first, event));
        });
        await _meshProxyDataOutCharacteristic.setNotifyValue(true);
        final descriptor = _meshProxyDataOutCharacteristic.descriptors
            .firstWhere((element) => element.uuid == clientCharacteristicConfigDescriptorUuid, orElse: () => null);
        if (descriptor != null) {
          await descriptor.write(enableNotificationValue);
        }
      }
    } else {
      final dataIn = _meshProvisioningDataInCharacteristic.properties;
      if (dataIn.read) {
        await _meshProvisioningDataInCharacteristic.read();
      }

      final dataOut = _meshProvisioningDataOutCharacteristic.properties;
      if (dataOut.read) {
        await _meshProvisioningDataOutCharacteristic.read();
      }

      if (dataOut.notify) {
        await _meshProvisioningDataOutSubscription?.cancel();
        _meshProvisioningDataOutSubscription =
            _meshProvisioningDataOutCharacteristic.value.where((event) => event.isNotEmpty).listen((event) async {
          callbacks.onDataReceivedController
              .add(BleMeshManagerCallbacksDataReceived(device, await device.mtu.first, event));
        });
        await _meshProvisioningDataOutCharacteristic.setNotifyValue(true);
        final descriptor = _meshProvisioningDataOutCharacteristic.descriptors
            .firstWhere((element) => element.uuid == clientCharacteristicConfigDescriptorUuid, orElse: () => null);
        if (descriptor != null) {
          await descriptor.write(enableNotificationValue);
        }
      }
    }
  }

  void sendPdu(final List<int> pdu) {
    final chunks = (pdu.length + (mtuSize - 1)) ~/ mtuSize;
    var srcOffset = 0;
    if (chunks > 1) {
      for (var i = 0; i < chunks; i++) {
        final length = math.min(pdu.length - srcOffset, mtuSize);
        final segmentedBuffer = [...pdu.sublist(srcOffset, length)];
        srcOffset += length;
        send(segmentedBuffer);
      }
    } else {
      send(pdu);
    }
  }

  Future<void> send(final List<int> data) async {
    if (_isProvisioningComplete) {
      if (_meshProxyDataInCharacteristic == null) {
        return;
      }
      if (_meshProxyDataInCharacteristic.properties.writeWithoutResponse) {
        await _meshProxyDataInCharacteristic.write(data);
      }
    } else {
      if (_meshProvisioningDataInCharacteristic == null) {
        return;
      }
      if (_meshProvisioningDataInCharacteristic.properties.writeWithoutResponse) {
        await _meshProvisioningDataInCharacteristic.write(data);
      }
    }
  }
}
