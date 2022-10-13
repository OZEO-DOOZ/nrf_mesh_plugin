import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/constants.dart';
import 'package:retry/retry.dart';

/// {@template ble_mesh_manager}
/// A Singleton that should be used to handle **BLE Mesh** connectivity features.
///
/// It implements the methods to init GATT layer, subscribe to notifications and send PDUs for **BLE Mesh** nodes.
/// {@endtemplate}
class BleMeshManager<T extends BleMeshManagerCallbacks> extends BleManager<T> {
  static final BleMeshManager _instance = BleMeshManager._(FlutterReactiveBle());

  /// The list of [DiscoveredService] that were discovered during the last connection process
  late List<DiscoveredService> _discoveredServices;

  /// The subscription for data when the connected node is a mesh proxy (ie. already provisioned in a network)
  StreamSubscription<List<int>>? _meshProxyDataOutSubscription;

  /// The subscription for data when the connected node is a free mesh node (ie. waiting to be provisioned in a network)
  StreamSubscription<List<int>>? _meshProvisioningDataOutSubscription;

  BleMeshManager._(FlutterReactiveBle bleInstance) : super(bleInstance);

  /// {@macro ble_mesh_manager}
  factory BleMeshManager() => _instance as BleMeshManager<T>;

  void _log(String msg) => debugPrint('[NordicNrfMesh] $msg');

  /// A method to clear some resources when the device should be disconnected
  void _onDeviceDisconnected() async {
    isProvisioningCompleted = false;
    await _meshProxyDataOutSubscription?.cancel();
    _meshProxyDataOutSubscription = null;
    await _meshProvisioningDataOutSubscription?.cancel();
    _meshProvisioningDataOutSubscription = null;
  }

  @override
  Future<void> disconnect() {
    _onDeviceDisconnected();
    return super.disconnect();
  }

  /// A method to read the connected device's MAC address via [doozCustomServiceUuid]
  ///
  /// _(DooZ specific API)_
  Future<String?> getServiceMacId() async {
    String? macId;
    if (_hasExpectedService(doozCustomServiceUuid)) {
      final service = _discoveredServices.firstWhere((service) => service.serviceId == doozCustomServiceUuid);
      if (_hasExpectedCharacteristicUuid(service, doozCustomCharacteristicUuid)) {
        macId = await getMacId();
      }
    }
    return macId;
  }

  @override
  Future<DiscoveredService?> isRequiredServiceSupported(bool shouldCheckDoozCustomService) async {
    // In the case of a mesh node, the advertised service should be either 0x1827 or 0x1828
    _discoveredServices = await bleInstance.discoverServices(device!.id);
    _log('services $_discoveredServices');
    isProvisioningCompleted = false;
    if (_hasExpectedService(meshProxyUuid)) {
      isProvisioningCompleted = true;
      // check for meshProxy characs
      final service = _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid);
      if (_hasExpectedCharacteristicUuid(service, meshProxyDataIn) &&
          _hasExpectedCharacteristicUuid(service, meshProxyDataOut)) {
        // if shouldCheckDoozCustomService is true, will also check for the existence of doozCustomServiceUuid
        // that has been introduced in firmwares v1.1.0 so we can get the mac address even on iOS devices
        if (shouldCheckDoozCustomService) {
          if (_hasExpectedService(doozCustomServiceUuid)) {
            final service = _discoveredServices.firstWhere((service) => service.serviceId == doozCustomServiceUuid);
            if (_hasExpectedCharacteristicUuid(service, doozCustomCharacteristicUuid)) {
              return service;
            }
          }
          throw const BleManagerException(
            BleManagerFailureCode.doozServiceNotFound,
            'plz update the firmware to v1.1.x',
          );
        } else {
          return service;
        }
      }
      return null;
    } else {
      if (_hasExpectedService(meshProvisioningUuid)) {
        final service = _discoveredServices.firstWhere((service) => service.serviceId == meshProvisioningUuid);
        if (_hasExpectedCharacteristicUuid(service, meshProvisioningDataIn) &&
            _hasExpectedCharacteristicUuid(service, meshProvisioningDataOut)) {
          return service;
        }
      }
      return null;
    }
  }

  @override
  Future<void> initGatt() async {
    // request highest MTU (only useful on Android)
    final negotiatedMtu = await bleInstance.requestMtu(deviceId: device!.id, mtu: mtuSizeMax);
    if (Platform.isAndroid) {
      mtuSize = negotiatedMtu - 3;
    } else if (Platform.isIOS) {
      mtuSize = negotiatedMtu;
    }
    // notify about negociated MTU size
    await callbacks!.sendMtuToMeshManagerApi(mtuSize);
    // subscribe to notifications from the proper BLE service (proxy/provisioning)
    DiscoveredService? discoveredService;
    if (isProvisioningCompleted) {
      discoveredService = _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid);
      await _meshProxyDataOutSubscription?.cancel();
      _meshProxyDataOutSubscription =
          _getDataOutSubscription(_getQualifiedCharacteristic(meshProxyDataOut, discoveredService.serviceId));
    } else {
      discoveredService = _discoveredServices.firstWhere((service) => service.serviceId == meshProvisioningUuid);
      await _meshProvisioningDataOutSubscription?.cancel();
      _meshProvisioningDataOutSubscription =
          _getDataOutSubscription(_getQualifiedCharacteristic(meshProvisioningDataOut, discoveredService.serviceId));
    }
  }

  bool _hasExpectedService(Uuid serviceUuid) => _discoveredServices.any((service) => service.serviceId == serviceUuid);

  bool _hasExpectedCharacteristicUuid(DiscoveredService discoveredService, Uuid expectedCharacteristicId) =>
      discoveredService.characteristicIds.any((uuid) => uuid == expectedCharacteristicId);

  QualifiedCharacteristic _getQualifiedCharacteristic(Uuid characteristicId, Uuid serviceId) => QualifiedCharacteristic(
        characteristicId: characteristicId,
        serviceId: serviceId,
        deviceId: device!.id,
      );

  StreamSubscription<List<int>> _getDataOutSubscription(QualifiedCharacteristic qCharacteristic) =>
      bleInstance.subscribeToCharacteristic(qCharacteristic).where((data) => data.isNotEmpty == true).listen((data) {
        if (!(callbacks?.onDataReceivedController.isClosed == true) &&
            callbacks!.onDataReceivedController.hasListener) {
          callbacks!.onDataReceivedController.add(BleMeshManagerCallbacksDataReceived(device!, mtuSize, data));
        } else {
          if (!connectCompleter.isCompleted) {
            const msg = 'no callback ready to receive data event';
            _log(msg);
            connectCompleter.completeError(const BleManagerException(BleManagerFailureCode.callbacks, msg));
          }
        }
      }, onError: (e, s) {
        const msg = 'error in device data stream';
        _log('$msg : $e\n$s');
        if (!(callbacks?.onErrorController.isClosed == true) && callbacks!.onErrorController.hasListener) {
          callbacks!.onErrorController.add(BleManagerCallbacksError(device, msg, e));
        }
        if (!connectCompleter.isCompleted) {
          // will notify for error as the connection could not be properly established
          connectCompleter.completeError(e);
        }
      });

  /// This method will send the given PDU.
  ///
  /// It may split the data in chunks based on the current [mtuSize].
  Future<void> sendPdu(final List<int> pdu) async {
    final chunks = ((pdu.length / (mtuSize - 1)) + 1).floor();
    var srcOffset = 0;
    if (chunks > 1) {
      for (var i = 0; i < chunks; i++) {
        final length = math.min(pdu.length - srcOffset, mtuSize);
        final sublist = pdu.sublist(srcOffset, srcOffset + length);
        final segmentedBuffer = sublist;
        await _send(segmentedBuffer);
        srcOffset += length;
      }
    } else {
      await _send(pdu);
    }
  }

  Future<void> _send(final List<int> data) async {
    if (data.isEmpty) {
      return;
    }
    if (isProvisioningCompleted) {
      try {
        await retry(
          () async {
            final service = _discoveredServices.firstWhere((service) => service.serviceId == meshProxyUuid);
            await bleInstance.writeCharacteristicWithoutResponse(
                _getQualifiedCharacteristic(meshProxyDataIn, service.serviceId),
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
                _getQualifiedCharacteristic(meshProvisioningDataIn, service.serviceId),
                value: data);
          },
          retryIf: (e) => e is PlatformException,
        );
        callbacks!.onDataSentController.add(BleMeshManagerCallbacksDataSent(device!, mtuSize, data));
      } catch (_) {}
    }
  }

  /// A method to clear GATT cache (only useful in some cases in **Android**)
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
