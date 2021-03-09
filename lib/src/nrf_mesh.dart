import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_node_reset_status/config_node_reset_status.dart';
import 'package:nordic_nrf_mesh/src/mesh_manager_api.dart';
import 'package:nordic_nrf_mesh/src/provisioned_mesh_node.dart';
import 'package:nordic_nrf_mesh/src/utils/provisioning.dart' as utils_provisioning;
import 'package:nordic_nrf_mesh/src/utils/advertisement_data.dart' as utils_advertisement_data;

class NordicNrfMesh {
  final _methodChannel = const MethodChannel('$namespace/methods');

  Future<MeshManagerApi> _meshManagerApi;

  NordicNrfMesh();

  Future<String> get platformVersion async {
    final version = await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<MeshManagerApi> get meshManagerApi => _meshManagerApi ??= _createMeshManagerApi();

  Future<MeshManagerApi> _createMeshManagerApi() async {
    await _methodChannel.invokeMethod('createMeshManagerApi');
    final meshManagerApi = MeshManagerApi();
    return meshManagerApi;
  }

  /// Will try to provision the specified [BluetoothDevice].
  ///
  /// Returns a [ProvisionedMeshNode] if success.
  ///
  /// Throws an [Exception] if provisioning failed
  /// or an [UnsupportedError] if the current OS is not supported.
  Future<ProvisionedMeshNode> provisioning(
    final MeshManagerApi meshManagerApi,
    final BleMeshManager bleMeshManager,
    final BluetoothDevice device,
    final String serviceDataUuid, {
    final utils_provisioning.ProvisioningEvent events,
  }) =>
      utils_provisioning.provisioning(meshManagerApi, bleMeshManager, device, serviceDataUuid, events: events);

  /// Will try to deprovision the specified [ProvisionedMeshNode].
  ///
  /// Returns a [ConfigNodeResetStatus] or null if timeout after 5sec.
  ///
  /// Throws a method channel error "NOT FOUND" if not found in the currently loaded mesh n/w
  /// or an [UnsupportedError] if the current OS is not supported.
  Future<ConfigNodeResetStatus> deprovision(
    final MeshManagerApi meshManagerApi,
    final ProvisionedMeshNode meshNode,
  ) =>
      utils_provisioning.deprovision(meshManagerApi, meshNode);

  /// Will try to cancel the provisioning.
  ///
  /// Returns `true` if the call has been successful, `false` otherwise.
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Future<bool> cancelProvisioning(
    final MeshManagerApi meshManagerApi,
    final BleMeshManager bleMeshManager,
  ) =>
      utils_provisioning.cancelProvisioning(meshManagerApi, bleMeshManager);

  bool addressIsInAdvertisementData(final List<int> address, final List<int> advertisementData) =>
      utils_advertisement_data.addressIsInAdvertisementData(address, advertisementData);

  Stream<String> macAddressesFromAdvertisementData(final List<int> advertisementData) =>
      utils_advertisement_data.macAddressesFromAdvertisementData(advertisementData);
}
