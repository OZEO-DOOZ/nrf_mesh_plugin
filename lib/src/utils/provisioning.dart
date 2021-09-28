import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager_callbacks.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_scanner.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_node_reset_status/config_node_reset_status.dart';
import 'package:nordic_nrf_mesh/src/exceptions/exceptions.dart';
import 'package:nordic_nrf_mesh/src/mesh_manager_api.dart';
import 'package:nordic_nrf_mesh/src/provisioned_mesh_node.dart';
import 'package:nordic_nrf_mesh/src/unprovisioned_mesh_node.dart';

class _ProvisioningEvent {
  final _provisioningController = StreamController<void>();
  final _provisioningCapabilitiesController = StreamController<void>();
  final _provisioningInvitationController = StreamController<void>();
  final _provisioningReconnectController = StreamController<void>();
  final _onConfigCompositionDataStatusController = StreamController<void>();
  final _onConfigAppKeyStatusController = StreamController<void>();
  final _provisioningGattErrorController = StreamController<DiscoveredDevice?>();
}

class ProvisioningEvent extends _ProvisioningEvent {
  Stream<void> get onProvisioning => _provisioningController.stream;

  Stream<void> get onProvisioningCapabilities => _provisioningCapabilitiesController.stream;

  Stream<void> get onProvisioningInvitation => _provisioningInvitationController.stream;

  Stream<void> get onProvisioningReconnect => _provisioningReconnectController.stream;

  Stream<void> get onConfigCompositionDataStatus => _onConfigCompositionDataStatusController.stream;

  Stream<void> get onConfigAppKeyStatus => _onConfigAppKeyStatusController.stream;
  Stream<DiscoveredDevice?> get onProvisioningGattError => _provisioningGattErrorController.stream;

  Future<void> dispose() => Future.wait([
        _provisioningController.close(),
        _provisioningCapabilitiesController.close(),
        _provisioningInvitationController.close(),
        _provisioningReconnectController.close(),
        _onConfigCompositionDataStatusController.close(),
        _onConfigAppKeyStatusController.close(),
        _provisioningGattErrorController.close(),
      ]);
}

StreamSubscription? onBleScannerError;
StreamSubscription? onProvisioningCompletedSubscription;
StreamSubscription? onProvisioningStateChangedSubscription;
StreamSubscription? onProvisioningFailedSubscription;
StreamSubscription? sendProvisioningPduSubscription;
StreamSubscription? onConfigCompositionDataStatusSubscription;
StreamSubscription? onConfigAppKeyStatusSubscription;
StreamSubscription? onDeviceReadySubscription;
StreamSubscription? onDataReceivedSubscription;
StreamSubscription? onMeshPduCreatedSubscription;
StreamSubscription? onGattErrorSubscription;
StreamSubscription? onDataSentSubscription;

Future<ProvisionedMeshNode> provisioning(MeshManagerApi meshManagerApi, BleMeshManager bleMeshManager,
    BleScanner bleScanner, DiscoveredDevice device, String serviceDataUuid,
    {ProvisioningEvent? events}) async {
  if (Platform.isIOS || Platform.isAndroid) {
    return _provisioning(meshManagerApi, bleMeshManager, bleScanner, device, serviceDataUuid, events);
  } else {
    throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
  }
}

Future<ProvisionedMeshNode> _provisioning(
    MeshManagerApi meshManagerApi,
    BleMeshManager bleMeshManager,
    BleScanner bleScanner,
    DiscoveredDevice deviceToProvision,
    String serviceDataUuid,
    ProvisioningEvent? events) async {
  assert(meshManagerApi.meshNetwork != null, 'You need to load a meshNetwork before being able to provision a device');
  final completer = Completer();
  late final ProvisionedMeshNode provisionedMeshNode;

  //'Undocumented scan throttle' error caught here
  onBleScannerError = bleScanner.onScanErrorStream.listen((event) {
    debugPrint('Scanner Error : ${event.error}');
  });

  final provisioningCallbacks = BleMeshManagerProvisioningCallbacks(meshManagerApi);
  bleMeshManager.callbacks = provisioningCallbacks;
  onProvisioningCompletedSubscription = meshManagerApi.onProvisioningCompleted.listen((event) async {
    try {
      await bleMeshManager.refreshDeviceCache();
      await bleMeshManager.disconnect();

      DiscoveredDevice? device;
      var scanTries = 0;
      while (device == null && scanTries < 6) {
        scanTries++;
        debugPrint('attempt #$scanTries to scan for ${deviceToProvision.id}');
        final scanResults = await bleScanner.provisionedNodesInRange(
            timeoutDuration: const Duration(seconds: 5)); //increase in time reduces 'Undocumented scan throttle' error
        try {
          device = scanResults.firstWhere((device) => device.id == deviceToProvision.id);
        } on StateError catch (e) {
          debugPrint('not found in scan results\n$e');
        }
        if (device != null) break;
        await Future.delayed(const Duration(milliseconds: 1500));
      }
      if (device == null) {
        completer.completeError(NrfMeshProvisioningException(ProvisioningFailureCode.notFound, 'Didn\'t find module'));
      }
      events?._provisioningReconnectController.add(null);
      try {
        await _connect(bleMeshManager, device!);
        provisionedMeshNode = ProvisionedMeshNode(event.meshNode!.uuid);
      } catch (e) {
        completer.completeError(NrfMeshProvisioningException(
            ProvisioningFailureCode.reconnection, 'Error in connection during provisioning process'));
      }
    } catch (e) {
      completer.completeError(NrfMeshProvisioningException(
          ProvisioningFailureCode.provisioningCompleted, 'error during provisioning completed listener'));
    }
  });
  onProvisioningFailedSubscription = meshManagerApi.onProvisioningFailed.listen((event) async {
    completer.completeError(NrfMeshProvisioningException(
        ProvisioningFailureCode.mesh, 'Failed to provision device ${deviceToProvision.id}'));
  });
  onProvisioningStateChangedSubscription = meshManagerApi.onProvisioningStateChanged.listen((event) async {
    if (event.state == 'PROVISIONING_CAPABILITIES') {
      events?._provisioningCapabilitiesController.add(null);
      final unprovisionedMeshNode =
          UnprovisionedMeshNode(event.meshNode!.uuid, event.meshNode!.provisionerPublicKeyXY!);
      final elementSize = await unprovisionedMeshNode.getNumberOfElements();
      if (elementSize == 0) {
        completer.completeError(NrfMeshProvisioningException(
            ProvisioningFailureCode.nodeComposition, 'Provisioning is failed. Module does not have any elements.'));
        return;
      }
      if (Platform.isAndroid) {
        var assigned = false;
        final meshnw = meshManagerApi.meshNetwork!;
        final maxAddress = await meshnw.highestAllocatableAddress;
        var unicast = await meshnw.nextAvailableUnicastAddress(elementSize);
        while (!assigned && unicast < maxAddress && unicast > 0) {
          try {
            await meshnw.assignUnicastAddress(unicast);
            assigned = true;
          } catch (e) {
            unicast += 1;
            debugPrint('[Provisioning] error, incrementing unicast to $unicast');
          }
        }
        debugPrint('[Provisioning] successfully assigned $unicast to node !');
      }
      events?._provisioningController.add(null);
      await meshManagerApi.provisioning(unprovisionedMeshNode);
    } else if (Platform.isAndroid && event.state == 'PROVISIONING_INVITE') {
      if (!bleMeshManager.isProvisioningCompleted) {
        events?._provisioningInvitationController.add(null);
      } else if (bleMeshManager.isProvisioningCompleted) {
        final unicast = await provisionedMeshNode.unicastAddress;
        await meshManagerApi.sendConfigCompositionDataGet(unicast);
      }
    }
  });
  onDeviceReadySubscription = bleMeshManager.callbacks!.onDeviceReady.listen((event) async {
    if (Platform.isIOS && bleMeshManager.isProvisioningCompleted) {
      final unicast = await provisionedMeshNode.unicastAddress;
      await meshManagerApi.sendConfigCompositionDataGet(unicast);
    } else {
      await meshManagerApi.identifyNode(serviceDataUuid);
    }
  });
  sendProvisioningPduSubscription = meshManagerApi.sendProvisioningPdu.listen((event) async {
    await bleMeshManager.sendPdu(event.pdu);
  });
  onMeshPduCreatedSubscription = meshManagerApi.onMeshPduCreated.listen((event) async {
    await bleMeshManager.sendPdu(event);
  });
  if (Platform.isAndroid) {
    onDataSentSubscription = bleMeshManager.callbacks!.onDataSent.listen((event) async {
      await meshManagerApi.handleWriteCallbacks(event.mtu, event.pdu);
    });
  }
  onDataReceivedSubscription = bleMeshManager.callbacks!.onDataReceived.listen((event) async {
    await meshManagerApi.handleNotifications(event.mtu, event.pdu);
  });
  onGattErrorSubscription = bleMeshManager.callbacks!.onError.listen((event) {
    events?._provisioningGattErrorController.add(event.device);
  });
  onConfigCompositionDataStatusSubscription = meshManagerApi.onConfigCompositionDataStatus.listen((event) async {
    events?._onConfigCompositionDataStatusController.add(null);
    await meshManagerApi.sendConfigAppKeyAdd(await provisionedMeshNode.unicastAddress);
  });
  onConfigAppKeyStatusSubscription = meshManagerApi.onConfigAppKeyStatus.listen((event) async {
    events?._onConfigAppKeyStatusController.add(null);
    completer.complete(provisionedMeshNode);
  });
  try {
    await bleMeshManager.refreshDeviceCache();
    await bleMeshManager.disconnect();
    await _connect(bleMeshManager, deviceToProvision);
    await completer.future;
    await meshManagerApi.cleanProvisioningData();
    await bleMeshManager.refreshDeviceCache();
    // Added a 1 second to wait for a refreshDeviceCache.
    await Future.delayed(const Duration(seconds: 1));
    await bleMeshManager.disconnect();
    cancelProvisioningCallbackSubscription(bleMeshManager);
    return provisionedMeshNode;
  } catch (e) {
    await cancelProvisioning(meshManagerApi, bleScanner, bleMeshManager);
    rethrow;
  }
}

late int _connectRetryCount;
Future<void> _connect(BleMeshManager bleMeshManager, DiscoveredDevice deviceToConnect) async {
  _connectRetryCount = 0;
  await bleMeshManager
      .connect(deviceToConnect)
      .catchError((e) async => await _onConnectError(e, bleMeshManager, deviceToConnect));
}

Future<void> _onConnectError(Object e, BleMeshManager bleMeshManager, DiscoveredDevice deviceToConnect) async {
  debugPrint('caught error during connect $e');
  if (e is GenericFailure) {
    if (_connectRetryCount < 3 &&
        e.code == ConnectionError.failedToConnect &&
        e.message.contains('status') &&
        e.message.contains('133')) {
      debugPrint('will retry to connect after $_connectRetryCount tries');
      await Future.delayed(const Duration(milliseconds: 500));
      await _connect(bleMeshManager, deviceToConnect);
    } else {
      debugPrint(_connectRetryCount >= 3
          ? 'connect to ${deviceToConnect.id} failed after $_connectRetryCount tries'
          : 'unhandled GenericFailure $e');
      throw e;
    }
  } else if (e is BleManagerException) {
    if (_connectRetryCount < 3 && e.code == BleManagerFailureCode.serviceNotFound) {
      debugPrint('will retry to connect after $_connectRetryCount tries');
      await Future.delayed(const Duration(milliseconds: 500));
      await _connect(bleMeshManager, deviceToConnect);
    } else {
      debugPrint(_connectRetryCount >= 3
          ? 'connect to ${deviceToConnect.id} failed after $_connectRetryCount tries'
          : 'unhandled BleManagerException $e');
      throw e;
    }
  } else {
    if (e is TimeoutException && _connectRetryCount < 2) {
      debugPrint('timeout ! will retry to connect after $_connectRetryCount tries');
      await _connect(bleMeshManager, deviceToConnect);
    } else {
      debugPrint(_connectRetryCount >= 2
          ? 'connect to ${deviceToConnect.id} failed after $_connectRetryCount tries'
          : 'unhandled error $e');
      throw e;
    }
  }
}

void cancelProvisioningCallbackSubscription(BleMeshManager bleMeshManager) {
  onProvisioningCompletedSubscription?.cancel();
  onProvisioningStateChangedSubscription?.cancel();
  onProvisioningFailedSubscription?.cancel();
  sendProvisioningPduSubscription?.cancel();
  onConfigCompositionDataStatusSubscription?.cancel();
  onConfigAppKeyStatusSubscription?.cancel();
  onDeviceReadySubscription?.cancel();
  onDataReceivedSubscription?.cancel();
  onMeshPduCreatedSubscription?.cancel();
  onGattErrorSubscription?.cancel();
  onBleScannerError?.cancel();
  if (Platform.isAndroid) onDataSentSubscription?.cancel();
  if (bleMeshManager.callbacks != null) bleMeshManager.callbacks!.dispose();
}

Future<bool> cancelProvisioning(
    MeshManagerApi meshManagerApi, BleScanner bleScanner, BleMeshManager bleMeshManager) async {
  if (Platform.isIOS || Platform.isAndroid) {
    debugPrint('should cancel provisioning');
    try {
      bleScanner.dispose();

      final cachedProvisionedMeshNodeUuid = await meshManagerApi.cachedProvisionedMeshNodeUuid();
      if (bleMeshManager.isProvisioningCompleted && cachedProvisionedMeshNodeUuid != null) {
        final nodes = await meshManagerApi.meshNetwork!.nodes;
        ProvisionedMeshNode? nodeToDelete;
        try {
          nodeToDelete = nodes.firstWhere((element) => element.uuid == cachedProvisionedMeshNodeUuid);
        } on StateError catch (e) {
          debugPrint('node not found in network\n$e');
        }

        if (nodeToDelete != null) {
          final status = await meshManagerApi.deprovision(nodeToDelete);
          if (status.success == false) {
            await meshManagerApi.meshNetwork!.deleteNode(cachedProvisionedMeshNodeUuid);
          }
        }
      }
      await meshManagerApi.cleanProvisioningData();
      await bleMeshManager.refreshDeviceCache();
      await bleMeshManager.disconnect();
      cancelProvisioningCallbackSubscription(bleMeshManager);
      return true;
    } catch (e) {
      debugPrint('ERROR - $e');
      return false;
    }
  } else {
    throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
  }
}

Future<ConfigNodeResetStatus> deprovision(MeshManagerApi meshManagerApi, ProvisionedMeshNode meshNode) {
  if (Platform.isIOS || Platform.isAndroid) {
    return meshManagerApi.deprovision(meshNode);
  } else {
    throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
  }
}

class BleMeshManagerProvisioningCallbacks extends BleMeshManagerCallbacks {
  final MeshManagerApi meshManagerApi;

  BleMeshManagerProvisioningCallbacks(this.meshManagerApi);

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) => meshManagerApi.setMtu(mtu);
}
