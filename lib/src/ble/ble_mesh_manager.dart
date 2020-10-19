import 'dart:async';
import 'dart:math' as math;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager_callbacks.dart';
import 'package:retry/retry.dart';

class BleMeshManager<T extends BleMeshManagerCallbacks> extends BleManager<T> {
  static BleMeshManager _instance;

  BluetoothCharacteristic _meshProxyDataInCharacteristic;
  BluetoothCharacteristic _meshProxyDataOutCharacteristic;
  BluetoothCharacteristic _meshProvisioningDataInCharacteristic;
  BluetoothCharacteristic _meshProvisioningDataOutCharacteristic;

  StreamSubscription<List<int>> _meshProxyDataOutSubscription;
  StreamSubscription<List<int>> _meshProvisioningDataOutSubscription;

  BleMeshManager._();

  factory BleMeshManager() => _instance ??= BleMeshManager._();

  void onDeviceDisconnected(final BluetoothDevice device) async {
    isProvisioningCompleted = false;
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
      isProvisioningCompleted = true;
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
        isProvisioningCompleted = false;
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
    if (isProvisioningCompleted) {
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
        _meshProxyDataOutSubscription =
            _meshProxyDataOutCharacteristic.value.where((event) => event?.isNotEmpty == true).listen((event) {
          callbacks.onDataReceivedController.add(BleMeshManagerCallbacksDataReceived(device, mtuSize, event));
        });
        await _meshProxyDataOutCharacteristic.setNotifyValue(true);
        if (Platform.isAndroid) {
          final descriptor = _meshProxyDataOutCharacteristic.descriptors
              .firstWhere((element) => element.uuid == clientCharacteristicConfigDescriptorUuid, orElse: () => null);
          if (descriptor != null) {
            await descriptor.write(enableNotificationValue);
          }
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
            _meshProvisioningDataOutCharacteristic.value.where((event) => event?.isNotEmpty == true).listen((event) {
          callbacks.onDataReceivedController.add(BleMeshManagerCallbacksDataReceived(device, mtuSize, event));
        });

        await _meshProvisioningDataOutCharacteristic.setNotifyValue(true);

        if (Platform.isAndroid) {
          final descriptor = _meshProvisioningDataOutCharacteristic.descriptors
              .firstWhere((element) => element.uuid == clientCharacteristicConfigDescriptorUuid, orElse: () => null);
          if (descriptor != null) {
            await descriptor.write(enableNotificationValue);
          }
        }
      }
    }
  }

  Future<void> sendPdu(final List<int> pdu) async {
    final chunks = ((pdu.length / (mtuSize - 1)) + 1).floor();
    var srcOffset = 0;
    if (chunks > 1) {
      for (var i = 0; i < chunks; i++) {
        final length = math.min(pdu.length - srcOffset, mtuSize);
        final sublist = pdu.sublist(srcOffset, srcOffset + length);
        final segmentedBuffer = sublist;
        await send(segmentedBuffer);
        srcOffset += length;
      }
    } else {
      await send(pdu);
    }
  }

  Future<void> send(final List<int> data) async {
    if (data.isEmpty) {
      return;
    }
    if (isProvisioningCompleted) {
      if (_meshProxyDataInCharacteristic == null) {
        return;
      }
      if (_meshProxyDataInCharacteristic.properties.writeWithoutResponse) {
        try {
          await retry(
            () async => await _meshProxyDataInCharacteristic.write(data, withoutResponse: true),
            retryIf: (e) => e is PlatformException,
          );
          callbacks.onDataSentController.add(BleMeshManagerCallbacksDataSent(device, mtuSize, data));
        } catch (_) {}
      }
    } else {
      if (_meshProvisioningDataInCharacteristic == null) {
        return;
      }
      if (_meshProvisioningDataInCharacteristic.properties.writeWithoutResponse) {
        try {
          await retry(
            () async => await _meshProvisioningDataInCharacteristic.write(data, withoutResponse: true),
            retryIf: (e) => e is PlatformException,
          );
          callbacks.onDataSentController.add(BleMeshManagerCallbacksDataSent(device, mtuSize, data));
        } catch (_) {}
      }
    }
  }
}
