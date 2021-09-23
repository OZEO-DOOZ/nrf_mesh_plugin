import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager_callbacks.dart';
import 'package:retry/retry.dart';

class BleMeshManager<T extends BleMeshManagerCallbacks> extends BleManager<T> {
  static late final BleMeshManager _instance = BleMeshManager._(FlutterReactiveBle());

  late List<DiscoveredService> _discoveredServices;

  StreamSubscription<List<int>>? _meshProxyDataOutSubscription;
  StreamSubscription<List<int>>? _meshProvisioningDataOutSubscription;

  BleMeshManager._(FlutterReactiveBle _bleInstance) : super(_bleInstance);

  factory BleMeshManager() => _instance as BleMeshManager<T>;

  void onDeviceDisconnected() async {
    isProvisioningCompleted = false;
    await _meshProxyDataOutSubscription?.cancel();
    _meshProxyDataOutSubscription = null;
    await _meshProvisioningDataOutSubscription?.cancel();
    _meshProvisioningDataOutSubscription = null;
  }

  @override
  Future<void> disconnect() {
    onDeviceDisconnected();
    return super.disconnect();
  }

  @override
  Future<DiscoveredService?> isRequiredServiceSupported() async {
    _discoveredServices = await bleInstance.discoverServices(device!.id);
    if (hasExpectedService(meshProxyUuid)) {
      isProvisioningCompleted = true;
      final service = _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid);
      if (hasExpectedCharacteristicUuid(service, meshProxyDataIn) &&
          hasExpectedCharacteristicUuid(service, meshProxyDataOut)) {
        return service;
      }
      return null;
    } else {
      if (hasExpectedService(meshProvisioningUuid)) {
        isProvisioningCompleted = false;
        final service = _discoveredServices.firstWhere((service) => service.serviceId == meshProvisioningUuid);
        if (hasExpectedCharacteristicUuid(service, meshProvisioningDataIn) &&
            hasExpectedCharacteristicUuid(service, meshProvisioningDataOut)) {
          return service;
        }
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> initGatt() async {
    DiscoveredService? discoveredService;
    if (isProvisioningCompleted) {
      discoveredService = hasExpectedService(meshProxyUuid)
          ? _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid)
          : null;
      if (discoveredService == null) {
        throw 'could not find the appropriate service on device..aborting';
      }
      await _meshProxyDataOutSubscription?.cancel();
      _meshProxyDataOutSubscription =
          getDataOutSubscription(getQualifiedCharacteristic(meshProxyDataOut, discoveredService.serviceId));
    } else {
      discoveredService = hasExpectedService(meshProvisioningUuid)
          ? _discoveredServices.firstWhere((service) => service.serviceId == meshProvisioningUuid)
          : null;
      if (discoveredService == null) {
        throw 'could not find the appropriate service on device..aborting';
      }
      await _meshProvisioningDataOutSubscription?.cancel();
      _meshProvisioningDataOutSubscription =
          getDataOutSubscription(getQualifiedCharacteristic(meshProvisioningDataOut, discoveredService.serviceId));
    }
  }

  bool hasExpectedService(Uuid serviceUuid) {
    return _discoveredServices.any((service) => service.serviceId == serviceUuid);
  }

  bool hasExpectedCharacteristicUuid(DiscoveredService discoveredService, Uuid expectedCharacteristicId) {
    return discoveredService.characteristicIds.any((uuid) => uuid == expectedCharacteristicId);
  }

  QualifiedCharacteristic getQualifiedCharacteristic(Uuid characteristicId, Uuid serviceId) {
    return QualifiedCharacteristic(
      characteristicId: characteristicId,
      serviceId: serviceId,
      deviceId: device!.id,
    );
  }

  StreamSubscription<List<int>> getDataOutSubscription(QualifiedCharacteristic qCharacteristic) =>
      bleInstance.subscribeToCharacteristic(qCharacteristic).where((data) => data.isNotEmpty == true).listen((data) =>
          callbacks!.onDataReceivedController.add(BleMeshManagerCallbacksDataReceived(device!, mtuSize, data)));

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
      try {
        await retry(
          () async {
            final service = _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid);
            await bleInstance.writeCharacteristicWithoutResponse(
                getQualifiedCharacteristic(meshProxyDataIn, service.serviceId),
                value: data);
          },
          retryIf: (e) => e is PlatformException,
        );
        callbacks!.onDataSentController.add(BleMeshManagerCallbacksDataSent(device!, mtuSize, data));
      } catch (_) {}
    } else {
      try {
        await retry(
          () async {
            final service = _discoveredServices.firstWhere((service) => service.serviceId == meshProvisioningUuid);
            await bleInstance.writeCharacteristicWithoutResponse(
                getQualifiedCharacteristic(meshProvisioningDataIn, service.serviceId),
                value: data);
          },
          retryIf: (e) => e is PlatformException,
        );
        callbacks!.onDataSentController.add(BleMeshManagerCallbacksDataSent(device!, mtuSize, data));
      } catch (_) {}
    }
  }

  Future<void> refreshDeviceCache() async {
    if (Platform.isAndroid) {
      if (device != null) {
        try {
          return await bleInstance.clearGattCache(device!.id);
        } on Exception catch (e) {
          if (e.toString().toLowerCase().contains('not connected')) {
            debugPrint('cannot clear gatt cache because not connected');
          } else {
            rethrow;
          }
        }
      }
    }
  }
}
