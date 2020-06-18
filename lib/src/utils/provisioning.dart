import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager_callbacks.dart';
import 'package:nordic_nrf_mesh/src/mesh_manager_api.dart';

Future<void> provisioning(MeshManagerApi meshManagerApi, BluetoothDevice device, String serviceDataUuid) async {
  final completer = Completer();
  final bleMeshManager = BleMeshManager();

  final onProvisioningCompletedSubscription = meshManagerApi.onProvisioningCompleted.listen((event) {
    print('onProvisioningCompleted $event');
    completer.complete();
  });
  final onProvisioningStateChangedSubscription = meshManagerApi.onProvisioningStateChanged.listen((event) {
    print('onProvisioningStateChanged $event');
    if (event.state == 'PROVISIONING_CAPABILITIES') {
      meshManagerApi.provisioning(event.meshNodeUuid);
    }
  });
  final onProvisioningFailedSubscription = meshManagerApi.onProvisioningFailed.listen((event) {
    print('onProvisioningFailed $event');
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
    print('onDeviceReady $event');
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
