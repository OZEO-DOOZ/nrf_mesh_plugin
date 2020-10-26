import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager_callbacks.dart';
import 'package:nordic_nrf_mesh/src/mesh_manager_api.dart';
import 'package:nordic_nrf_mesh/src/provisioned_mesh_node.dart';
import 'package:nordic_nrf_mesh/src/unprovisioned_mesh_node.dart';
import 'package:pedantic/pedantic.dart';

class _ProvisioningEvent {
  final _provisioningController = StreamController<void>();
  final _provisioningCapabilitiesController = StreamController<void>();
  final _provisioningInvitationController = StreamController<void>();
  final _provisioningReconnectController = StreamController<void>();
  final _onConfigCompositionDataStatusController = StreamController<void>();
  final _onConfigAppKeyStatusController = StreamController<void>();
}

class ProvisioningEvent extends _ProvisioningEvent {
  Stream<void> get onProvisioning => _provisioningController.stream;
  Stream<void> get onProvisioningCapabilities => _provisioningCapabilitiesController.stream;
  Stream<void> get onProvisioningInvitation => _provisioningInvitationController.stream;
  Stream<void> get onProvisioningReconnect => _provisioningReconnectController.stream;
  Stream<void> get onConfigCompositionDataStatus => _onConfigCompositionDataStatusController.stream;
  Stream<void> get onConfigAppKeyStatus => _onConfigAppKeyStatusController.stream;

  Future<void> dispose() => Future.wait([
        _provisioningController.close(),
        _provisioningCapabilitiesController.close(),
        _provisioningInvitationController.close(),
        _provisioningReconnectController.close(),
        _onConfigCompositionDataStatusController.close(),
        _onConfigAppKeyStatusController.close(),
      ]);
}

Future<ProvisionedMeshNode> provisioning(
    MeshManagerApi meshManagerApi, BleMeshManager bleMeshManager, BluetoothDevice device, String serviceDataUuid,
    {ProvisioningEvent events}) async {
  if (Platform.isIOS || Platform.isAndroid) {
    return _provisioning(meshManagerApi, bleMeshManager, device, serviceDataUuid, events);
  }
  throw Exception('Platform ${Platform.operatingSystem} is not supported');
}

Future<ProvisionedMeshNode> _provisioning(MeshManagerApi meshManagerApi, BleMeshManager bleMeshManager,
    BluetoothDevice device, String serviceDataUuid, ProvisioningEvent events) async {
  assert(meshManagerApi.meshNetwork != null, 'You need to load a meshNetwork before being able to provision a device');
  final completer = Completer();
  ProvisionedMeshNode provisionedMeshNode;
  final provisioningCallbacks = BleMeshManagerProvisioningCallbacks(meshManagerApi);
  bleMeshManager.callbacks = provisioningCallbacks;

  final onProvisioningCompletedSubscription = meshManagerApi.onProvisioningCompleted.listen((event) async {
    await bleMeshManager.disconnect();
    ScanResult scanResult;
    while (scanResult == null) {
      final scanResults = (await FlutterBlue.instance.startScan(
        withServices: [meshProxyUuid],
        scanMode: ScanMode.lowLatency,
        timeout: Duration(seconds: 1),
      ) as List<ScanResult>);
      scanResult = scanResults.firstWhere((element) => element.device.id.id == device.id.id, orElse: () => null);
      await Future.delayed(Duration(milliseconds: 500));
    }
    if (scanResult == null) {
      completer.completeError(Exception('Didn\'t find module'));
      return;
    }
    await bleMeshManager.connect(scanResult.device);
    provisionedMeshNode = ProvisionedMeshNode(event.meshNode.uuid);
  });
  final onProvisioningFailedSubscription = meshManagerApi.onProvisioningFailed.listen((event) async {
    await meshManagerApi.cleanProvisioningData();
    completer.completeError(Exception('Failed to provision device ${device.id.id}'));
  });

  final onProvisioningStateChangedSubscription = meshManagerApi.onProvisioningStateChanged.listen((event) async {
    if (event.state == 'PROVISIONING_CAPABILITIES') {
      events?._provisioningCapabilitiesController?.add(null);
      final unprovisionedMeshNode = UnprovisionedMeshNode(event.meshNode.uuid, event.meshNode.provisionerPublicKeyXY);
      final elementSize = await unprovisionedMeshNode.getNumberOfElements();

      if (elementSize == 0) {
        await meshManagerApi.cleanProvisioningData();
        completer.completeError(Exception('Provisioning is failed. Module does not have any elements.'));
        return;
      }

      if (Platform.isAndroid) {
        var assigned = false;
        final maxAddress = await meshManagerApi.meshNetwork.highestAllocatableAddress;
        var unicast = await meshManagerApi.meshNetwork.nextAvailableUnicastAddress(elementSize);
        while (!assigned && unicast < maxAddress && unicast > 0) {
          try {
            await meshManagerApi.meshNetwork.assignUnicastAddress(unicast);
            assigned = true;
          } catch (e) {
            unicast += 1;
          }
        }
      }
      events?._provisioningController?.add(null);
      await meshManagerApi.provisioning(unprovisionedMeshNode);
    } else if (Platform.isAndroid && event.state == 'PROVISIONING_INVITE') {
      if (!bleMeshManager.isProvisioningCompleted) {
        events?._provisioningInvitationController?.add(null);
      } else if (bleMeshManager.isProvisioningCompleted) {
        events?._provisioningReconnectController?.add(null);
        final unicast = await provisionedMeshNode.unicastAddress;
        await meshManagerApi.createMeshPduForConfigCompositionDataGet(unicast);
      }
    }
  });

  final onDeviceReadySubscription = bleMeshManager.callbacks.onDeviceReady.listen((event) async {
    if (Platform.isIOS && bleMeshManager.isProvisioningCompleted) {
      final unicast = await provisionedMeshNode.unicastAddress;
      await meshManagerApi.createMeshPduForConfigCompositionDataGet(unicast);
    } else {
      await meshManagerApi.identifyNode(serviceDataUuid);
    }
  });

  final sendProvisioningPduSubscription = meshManagerApi.sendProvisioningPdu.listen((event) async {
    await bleMeshManager.sendPdu(event.pdu);
  });
  final onMeshPduCreatedSubscription = meshManagerApi.onMeshPduCreated.listen((event) async {
    await bleMeshManager.sendPdu(event);
  });
  StreamSubscription<BleMeshManagerCallbacksDataSent> onDataSentSubscription;
  if (Platform.isAndroid) {
    onDataSentSubscription = bleMeshManager.callbacks.onDataSent.listen((event) async {
      await meshManagerApi.handleWriteCallbacks(event.mtu, event.pdu);
    });
  }
  final onDataReceivedSubscription = bleMeshManager.callbacks.onDataReceived.listen((event) async {
    await meshManagerApi.handleNotifications(event.mtu, event.pdu);
  });

  final onConfigCompositionDataStatusSubscription = meshManagerApi.onConfigCompositionDataStatus.listen((event) async {
    events?._onConfigCompositionDataStatusController?.add(null);
    await meshManagerApi.createMeshPduForConfigAppKeyAdd(await provisionedMeshNode.unicastAddress);
  });
  final onConfigAppKeyStatusSubscription = meshManagerApi.onConfigAppKeyStatus.listen((event) async {
    events?._onConfigAppKeyStatusController?.add(null);
    completer.complete(provisionedMeshNode);
  });

  if (bleMeshManager.connected) {
    await bleMeshManager.disconnect();
  }

  await bleMeshManager.connect(device);

  try {
    await completer.future;

    await bleMeshManager.disconnect();
    return provisionedMeshNode;
  } catch (e) {
    await bleMeshManager.disconnect();
    rethrow;
  } finally {
    unawaited(Future.wait([
      onProvisioningCompletedSubscription.cancel(),
      onProvisioningStateChangedSubscription.cancel(),
      onProvisioningFailedSubscription.cancel(),
      sendProvisioningPduSubscription.cancel(),
      onConfigCompositionDataStatusSubscription.cancel(),
      onConfigAppKeyStatusSubscription.cancel(),
      onDeviceReadySubscription.cancel(),
      onDataReceivedSubscription.cancel(),
      onMeshPduCreatedSubscription.cancel(),
      if (Platform.isAndroid) onDataSentSubscription?.cancel(),
      if (bleMeshManager?.callbacks != null) bleMeshManager.callbacks.dispose(),
    ]));
  }
}

class BleMeshManagerProvisioningCallbacks extends BleMeshManagerCallbacks {
  final MeshManagerApi meshManagerApi;

  BleMeshManagerProvisioningCallbacks(this.meshManagerApi);

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) => meshManagerApi.setMtu(mtu);
}
