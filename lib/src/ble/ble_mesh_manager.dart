import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager_callbacks.dart';
import 'package:retry/retry.dart';

class BleMeshManager<T extends BleMeshManagerCallbacks> extends BleManager<T> {
  static BleMeshManager _instance;

  Uuid _meshProxyDataInCharacteristicUuid;
  Uuid _meshProxyDataOutCharacteristicUuid;
  Uuid _meshProvisioningDataInCharacteristicUuid;
  Uuid _meshProvisioningDataOutCharacteristicUuid;

  List<DiscoveredService> _discoveredServices;

  StreamSubscription<List<int>> _meshProxyDataOutSubscription;
  StreamSubscription<List<int>> _meshProvisioningDataOutSubscription;

  BleMeshManager._(FlutterReactiveBle _bleInstance) : super(_bleInstance);

  factory BleMeshManager() => _instance ??= BleMeshManager._(FlutterReactiveBle());

  //TODO check calls
  void onDeviceDisconnected(final DiscoveredDevice device) async {
    isProvisioningCompleted = false;
    _meshProvisioningDataInCharacteristicUuid = null;
    _meshProvisioningDataOutCharacteristicUuid = null;
    _meshProxyDataInCharacteristicUuid = null;
    _meshProxyDataOutCharacteristicUuid = null;
    await _meshProxyDataOutSubscription?.cancel();
    _meshProxyDataOutSubscription = null;
    await _meshProvisioningDataOutSubscription?.cancel();
    _meshProvisioningDataOutSubscription = null;
  }

  @override
  Future<void> disconnect() {
    onDeviceDisconnected(device);
    return super.disconnect();
  }

  @override
  Future<DiscoveredService> isRequiredServiceSupported() async {
    _discoveredServices = await bleInstance.discoverServices(device.id);
    var service = getDiscoveredService(meshProxyUuid);
    if (service != null) {
      isProvisioningCompleted = true;
      _meshProxyDataInCharacteristicUuid = getCharacteristicUuid(service, meshProxyDataIn);
      _meshProxyDataOutCharacteristicUuid = getCharacteristicUuid(service, meshProxyDataOut);
      if (_meshProxyDataInCharacteristicUuid != null && _meshProxyDataOutCharacteristicUuid != null) {
        return service;
      }
      return null;
    } else {
      service = getDiscoveredService(meshProvisioningUuid);
      if (service != null) {
        isProvisioningCompleted = false;
        _meshProvisioningDataInCharacteristicUuid = getCharacteristicUuid(service, meshProvisioningDataIn);
        _meshProvisioningDataOutCharacteristicUuid = getCharacteristicUuid(service, meshProvisioningDataOut);
        if (_meshProvisioningDataInCharacteristicUuid != null && _meshProvisioningDataOutCharacteristicUuid != null) {
          return service;
        }
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> initGatt() async {
    var discoveredService;
    if (isProvisioningCompleted) {
      discoveredService = getDiscoveredService(meshProxyUuid);
      await _meshProxyDataOutSubscription?.cancel();
      _meshProxyDataOutSubscription = getDataOutSubscription(
          getQualifiedCharacteristic(_meshProxyDataOutCharacteristicUuid, discoveredService.serviceId));
    } else {
      discoveredService = getDiscoveredService(meshProvisioningUuid);
      await _meshProvisioningDataOutSubscription?.cancel();
      _meshProvisioningDataOutSubscription = getDataOutSubscription(
          getQualifiedCharacteristic(_meshProvisioningDataOutCharacteristicUuid, discoveredService.serviceId));
    }
  }

  DiscoveredService getDiscoveredService(Uuid serviceUuid) {
    return _discoveredServices.firstWhere((service) => service.serviceId == serviceUuid, orElse: () => null);
  }

  Uuid getCharacteristicUuid(DiscoveredService discoveredService, Uuid characteristicId) {
    return discoveredService.characteristicIds.firstWhere((uuid) => uuid == characteristicId, orElse: () => null);
  }

  QualifiedCharacteristic getQualifiedCharacteristic(Uuid characteristicId, Uuid serviceId) {
    return QualifiedCharacteristic(
      characteristicId: characteristicId,
      serviceId: serviceId,
      deviceId: device.id,
    );
  }

  StreamSubscription<List<int>> getDataOutSubscription(QualifiedCharacteristic qCharacteristic) {
    return bleInstance.subscribeToCharacteristic(qCharacteristic).where((data) => data?.isNotEmpty == true).listen(
        (data) => callbacks.onDataReceivedController.add(BleMeshManagerCallbacksDataReceived(device, mtuSize, data)));
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
      if (_meshProxyDataInCharacteristicUuid == null) {
        return;
      }
      try {
        await retry(
          () async {
            final service = getDiscoveredService(meshProxyUuid);
            await bleInstance.writeCharacteristicWithoutResponse(
                getQualifiedCharacteristic(_meshProxyDataInCharacteristicUuid, service.serviceId),
                value: data);
          },
          retryIf: (e) => e is PlatformException,
        );
        callbacks.onDataSentController.add(BleMeshManagerCallbacksDataSent(device, mtuSize, data));
      } catch (_) {}
    } else {
      if (_meshProvisioningDataInCharacteristicUuid == null) {
        return;
      }
      try {
        await retry(
          () async {
            final service = getDiscoveredService(meshProvisioningUuid);
            await bleInstance.writeCharacteristicWithoutResponse(
                getQualifiedCharacteristic(_meshProvisioningDataInCharacteristicUuid, service.serviceId),
                value: data);
          },
          retryIf: (e) => e is PlatformException,
        );
        callbacks.onDataSentController.add(BleMeshManagerCallbacksDataSent(device, mtuSize, data));
      } catch (_) {}
    }
  }

  Future<void> refreshDeviceCache() async {
    if (Platform.isAndroid) {
      if (device != null) {
        try {
          return await bleInstance.clearGattCache(device.id);
        } on GenericFailure catch (e) {
          if (e.message.toLowerCase().contains('not connected')) {
            print('cannot clear gatt cache because not connected');
          } else {
            rethrow;
          }
        }
      }
    }
    return null;
  }
}
