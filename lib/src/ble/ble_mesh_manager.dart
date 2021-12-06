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

  void _log(String msg) => debugPrint('[NordicNrfMesh] $msg');

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

  Future<String?> getServiceMacId() async {
    if (hasExpectedService(doozCustomServiceUuid)) {
      final service = _discoveredServices.firstWhere((service) => service.serviceId == doozCustomServiceUuid);
      if (hasExpectedCharacteristicUuid(service, doozCustomCharacteristicUuid)) {
        return getMacId();
      }
    }
  }

  @override
  Future<DiscoveredService?> isRequiredServiceSupported(bool shouldCheckDoozCustomService) async {
    _discoveredServices = await bleInstance.discoverServices(device!.id);
    isProvisioningCompleted = false;
    if (hasExpectedService(meshProxyUuid)) {
      isProvisioningCompleted = true;
      // check for meshProxy characs
      final service = _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid);
      if (hasExpectedCharacteristicUuid(service, meshProxyDataIn) &&
          hasExpectedCharacteristicUuid(service, meshProxyDataOut)) {
        // if shouldCheckDoozCustomService is true, will also check for the existence of doozCustomServiceUuid
        // that has been introduced in firmwares v1.1.0 so we can get the mac address even on iOS devices
        if (shouldCheckDoozCustomService) {
          if (hasExpectedService(doozCustomServiceUuid)) {
            final service = _discoveredServices.firstWhere((service) => service.serviceId == doozCustomServiceUuid);
            if (hasExpectedCharacteristicUuid(service, doozCustomCharacteristicUuid)) {
              return service;
            } else {
              throw const BleManagerException(
                BleManagerFailureCode.doozServiceNotFound,
                'plz update the firmware to v1.1.x',
              );
            }
          } else {
            throw const BleManagerException(
              BleManagerFailureCode.doozServiceNotFound,
              'plz update the firmware to v1.1.x',
            );
          }
        } else {
          return service;
        }
      }
      return null;
    } else {
      if (hasExpectedService(meshProvisioningUuid)) {
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
      discoveredService = _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid);
      await _meshProxyDataOutSubscription?.cancel();
      _meshProxyDataOutSubscription =
          getDataOutSubscription(getQualifiedCharacteristic(meshProxyDataOut, discoveredService.serviceId));
    } else {
      discoveredService = _discoveredServices.firstWhere((service) => service.serviceId == meshProvisioningUuid);
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
      bleInstance.subscribeToCharacteristic(qCharacteristic).where((data) => data.isNotEmpty == true).listen((data) {
        if (!(callbacks?.onDataReceivedController.isClosed == true) &&
            callbacks!.onDataReceivedController.hasListener) {
          callbacks!.onDataReceivedController.add(BleMeshManagerCallbacksDataReceived(device!, mtuSize, data));
        } else {
          if (!connectCompleter.isCompleted) {
            const _msg = 'no callback ready to receive data event';
            _log(_msg);
            connectCompleter.completeError(const BleManagerException(BleManagerFailureCode.callbacks, _msg));
          }
        }
      }, onError: (e, s) {
        const _msg = 'error in device data stream';
        _log('$_msg : $e\n$s');
        if (!(callbacks?.onErrorController.isClosed == true) && callbacks!.onErrorController.hasListener) {
          callbacks!.onErrorController.add(BleManagerCallbacksError(device, _msg, e));
        }
        if (!connectCompleter.isCompleted) {
          // will notify for error as the connection could not be properly established
          connectCompleter.completeError(e);
        }
      });

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
            _log('cannot clear gatt cache because not connected');
          } else {
            rethrow;
          }
        }
      }
    }
  }
}
