import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/mesh_manager_api.dart';
import 'package:nordic_nrf_mesh/src/provisioned_mesh_node.dart';
import 'package:nordic_nrf_mesh/src/utils/provisioning.dart'
    as utils_provisioning;
import 'package:nordic_nrf_mesh/src/utils/advertisement_data.dart'
    as utils_advertisement_data;

class NordicNrfMesh {
  final _methodChannel = const MethodChannel('$namespace/methods');

  Future<MeshManagerApi> _meshManagerApi;

  NordicNrfMesh();

  Future<String> get platformVersion async {
    final version = await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<MeshManagerApi> get meshManagerApi =>
      _meshManagerApi ??= _createMeshManagerApi();

  Future<MeshManagerApi> _createMeshManagerApi() async {
    await _methodChannel.invokeMethod('createMeshManagerApi');
    final meshManagerApi = MeshManagerApi();
    return meshManagerApi;
  }

  Future<ProvisionedMeshNode> provisioning(
    final MeshManagerApi meshManagerApi,
    final BleMeshManager bleMeshManager,
    final BluetoothDevice device,
    final String serviceDataUuid, {
    final utils_provisioning.ProvisioningEvent events,
  }) =>
      utils_provisioning.provisioning(
          meshManagerApi, bleMeshManager, device, serviceDataUuid,
          events: events);

  bool addressIsInAdvertisementData(
          final List<int> address, final List<int> advertisementData) =>
      utils_advertisement_data.addressIsInAdvertisementData(
          address, advertisementData);

  Stream<String> macAddressesFromAdvertisementData(
          final List<int> advertisementData) =>
      utils_advertisement_data
          .macAddressesFromAdvertisementData(advertisementData);
}
