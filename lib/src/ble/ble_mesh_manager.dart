import 'dart:async';
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
  Future<DiscoveredService> isRequiredServiceSupported(final DiscoveredDevice device) async {
    _discoveredServices = await bleInstance.discoverServices(device.id);
    var service = _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid, orElse: () => null);
    if (service != null) {
      isProvisioningCompleted = true;
      _meshProxyDataInCharacteristicUuid =
          service.characteristicIds.firstWhere((uuid) => uuid == meshProxyDataIn, orElse: () => null);
      _meshProxyDataOutCharacteristicUuid =
          service.characteristicIds.firstWhere((uuid) => uuid == meshProxyDataOut, orElse: () => null);
      if (_meshProxyDataInCharacteristicUuid != null && _meshProxyDataOutCharacteristicUuid != null) {
        return service;
      }
      return null;
    } else {
      service =
          _discoveredServices.firstWhere((service) => service.serviceId == meshProvisioningUuid, orElse: () => null);
      if (service != null) {
        isProvisioningCompleted = false;
        _meshProvisioningDataInCharacteristicUuid =
            service.characteristicIds.firstWhere((uuid) => uuid == meshProvisioningDataIn, orElse: () => null);
        _meshProvisioningDataOutCharacteristicUuid =
            service.characteristicIds.firstWhere((uuid) => uuid == meshProvisioningDataOut, orElse: () => null);
        if (_meshProvisioningDataInCharacteristicUuid != null && _meshProvisioningDataOutCharacteristicUuid != null) {
          return service;
        }
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> initGatt(final DiscoveredDevice device) async {
    var service = _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid, orElse: () => null);
    if (isProvisioningCompleted) {
      final proxyOutCharact = QualifiedCharacteristic(
        characteristicId: _meshProxyDataOutCharacteristicUuid,
        serviceId: service.serviceId,
        deviceId: device.id,
      );
      await _meshProxyDataOutSubscription?.cancel();
      _meshProxyDataOutSubscription = bleInstance
          .subscribeToCharacteristic(proxyOutCharact)
          .where((data) => data?.isNotEmpty == true)
          .listen((data) =>
              callbacks.onDataReceivedController.add(BleMeshManagerCallbacksDataReceived(device, mtuSize, data)));
    } else {
      service =
          _discoveredServices.firstWhere((service) => service.serviceId == meshProvisioningUuid, orElse: () => null);
      final provOutCharac = QualifiedCharacteristic(
        characteristicId: _meshProvisioningDataOutCharacteristicUuid,
        serviceId: service.serviceId,
        deviceId: device.id,
      );
      await _meshProvisioningDataOutSubscription?.cancel();
      _meshProvisioningDataOutSubscription = bleInstance
          .subscribeToCharacteristic(provOutCharac)
          .where((data) => data?.isNotEmpty == true)
          .listen((data) =>
              callbacks.onDataReceivedController.add(BleMeshManagerCallbacksDataReceived(device, mtuSize, data)));
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
      if (_meshProxyDataInCharacteristicUuid == null) {
        return;
      }
      try {
        await retry(
          () async {
            final service =
                _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid, orElse: () => null);
            final dataInCharacteristic = QualifiedCharacteristic(
              characteristicId: _meshProxyDataInCharacteristicUuid,
              serviceId: service.serviceId,
              deviceId: device.id,
            );
            await bleInstance.writeCharacteristicWithoutResponse(dataInCharacteristic, value: data);
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
            final service = _discoveredServices.firstWhere((service) => service.serviceId == meshProvisioningUuid,
                orElse: () => null);
            final dataInCharacteristic = QualifiedCharacteristic(
              characteristicId: _meshProvisioningDataInCharacteristicUuid,
              serviceId: service.serviceId,
              deviceId: device.id,
            );
            await bleInstance.writeCharacteristicWithoutResponse(dataInCharacteristic, value: data);
          },
          retryIf: (e) => e is PlatformException,
        );
        callbacks.onDataSentController.add(BleMeshManagerCallbacksDataSent(device, mtuSize, data));
      } catch (_) {}
    }
  }

  Future<void> refreshDeviceCache() {
    if (device != null) {
      return bleInstance.clearGattCache(device.id);
    }
    return null;
  }
}
