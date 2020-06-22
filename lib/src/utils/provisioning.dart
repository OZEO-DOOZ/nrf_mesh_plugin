import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager_callbacks.dart';
import 'package:nordic_nrf_mesh/src/mesh_manager_api.dart';
import 'package:nordic_nrf_mesh/src/unprovisioned_mesh_node.dart';

Future<void> provisioning(MeshManagerApi meshManagerApi, BluetoothDevice device, String serviceDataUuid) async {
  print('serviceDataUuid $serviceDataUuid');
  if (Platform.isIOS) {
    await meshManagerApi.provisioningIos(serviceDataUuid);
  } else if (Platform.isAndroid) {
    await _provisioningAndroid(meshManagerApi, device, serviceDataUuid);
  }
}

Future<void> _provisioningAndroid(MeshManagerApi meshManagerApi, BluetoothDevice device, String serviceDataUuid) async {
  assert(meshManagerApi.meshNetwork != null, 'You need to load a meshNetwork before being able to provision a device');
  final completer = Completer();
  final bleMeshManager = BleMeshManager();

  final onProvisioningCompletedSubscription = meshManagerApi.onProvisioningCompleted.listen((event) async {
    print('onProvisioningCompleted $event');
    await meshManagerApi.cleanProvisioningData();
    await device.disconnect();
    await device.connect();
    completer.complete();
  });
  final onProvisioningStateChangedSubscription = meshManagerApi.onProvisioningStateChanged.listen((event) async {
    print('onProvisioningStateChanged $event');
    if (event.state == 'PROVISIONING_CAPABILITIES') {
      var assigned = false;
      final unprovisionedMeshNode = UnprovisionedMeshNode(event.meshNode.uuid, event.meshNode.provisionerPublicKeyXY);
      final elementSize = await unprovisionedMeshNode.getNumberOfElements();
      final maxAddress = await meshManagerApi.meshNetwork.highestAllocatableAddress;

      if (elementSize == 0) {
        await meshManagerApi.cleanProvisioningData();
        completer.completeError(Exception('Provisioning is failed. Module does not have any elements.'));
        return;
      }

      var unicast = await meshManagerApi.meshNetwork.nextAvailableUnicastAddress(elementSize);
      while (!assigned && unicast < maxAddress && unicast > 0) {
        try {
          await meshManagerApi.meshNetwork.assignUnicastAddress(unicast);
          assigned = true;
        } catch (e) {
          print('Failed to assign $unicast to meshNetwork retry with ${unicast + 1}');
          unicast += 1;
        }
      }
      await unprovisionedMeshNode.setUnicastAddress(unicast);
      await meshManagerApi.provisioning(unprovisionedMeshNode);
    }
  });
  final onProvisioningFailedSubscription = meshManagerApi.onProvisioningFailed.listen((event) async {
    print('onProvisioningFailed $event');
    await meshManagerApi.cleanProvisioningData();
    completer.completeError(Exception('Failed to provision device ${device.id.id}'));
  });

  final sendProvisioningPduSubscription = meshManagerApi.sendProvisioningPdu.listen((event) async {
    print('sendProvisioningPdu $event');
    await bleMeshManager.sendPdu(event.pdu);
  });
  final onMeshPduCreatedSubscription = meshManagerApi.onMeshPduCreated.listen((event) async {
    print('onMeshPduCreated $event');
    await bleMeshManager.sendPdu(event);
  });

  bleMeshManager.callbacks = _DoozBleMeshManagerCallbacks(meshManagerApi);
  bleMeshManager.callbacks.onDeviceConnecting.listen(print);
  bleMeshManager.callbacks.onDeviceConnected.listen(print);

  bleMeshManager.callbacks.onServicesDiscovered.listen((event) {
    print('onServicesDiscovered');
  });

  bleMeshManager.callbacks.onDeviceReady.listen((event) async {
    print('onDeviceReady ${event.id.id} ${serviceDataUuid}');
    await meshManagerApi.identifyNode(serviceDataUuid);
  });

  bleMeshManager.callbacks.onDataReceived.listen((event) async {
    print('onDataReceived ${event.device.id} ${event.pdu} ${event.mtu}');
    await meshManagerApi.handleNotifications(event.mtu, event.pdu);
  });
  bleMeshManager.callbacks.onDataSent.listen((event) async {
    print('onDataSent ${event.device.id} ${event.pdu} ${event.mtu}');
    await meshManagerApi.handleWriteCallbacks(event.mtu, event.pdu);
  });

  bleMeshManager.callbacks.onDeviceDisconnecting.listen(print);
  bleMeshManager.callbacks.onDeviceDisconnected.listen(print);

  print('connect');
  await bleMeshManager.connect(device);

  try {
    await completer.future;
  } catch (e) {
    await device.disconnect();
    rethrow;
  } finally {
    await Future.wait([
      onProvisioningCompletedSubscription.cancel(),
      onProvisioningStateChangedSubscription.cancel(),
      onProvisioningFailedSubscription.cancel(),
      sendProvisioningPduSubscription.cancel(),
      onMeshPduCreatedSubscription.cancel(),
      bleMeshManager?.callbacks?.dispose(),
    ]);
  }
}

class _DoozBleMeshManagerCallbacks extends BleMeshManagerCallbacks {
  final MeshManagerApi _meshManagerApi;

  _DoozBleMeshManagerCallbacks(this._meshManagerApi);

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) async => _meshManagerApi.setMtu(mtu);
}
