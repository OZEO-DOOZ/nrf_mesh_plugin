import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_scanner.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/utils/provisioning.dart' as utils_provisioning;

class NordicNrfMesh {
  final _methodChannel = const MethodChannel('$namespace/methods');
  final BleScanner _bleScanner = BleScanner();

  Future<String> get platformVersion async {
    final version = await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  late final MeshManagerApi _meshManagerApi = MeshManagerApi();
  MeshManagerApi get meshManagerApi => _meshManagerApi;

  /// Will try to provision the specified [BluetoothDevice].
  ///
  /// After the process or if any error occurs, the [BleManager] will be disconnected from device.
  ///
  /// Returns a [ProvisionedMeshNode] if success.
  ///
  /// Throws an [NrfMeshProvisioningException] if provisioning failed
  /// or an [UnsupportedError] if the current OS is not supported.
  Future<ProvisionedMeshNode> provisioning(
    final MeshManagerApi meshManagerApi,
    final BleMeshManager bleMeshManager,
    final DiscoveredDevice device,
    final String serviceDataUuid, {
    final utils_provisioning.ProvisioningEvent? events,
  }) =>
      utils_provisioning.provisioning(meshManagerApi, bleMeshManager, _bleScanner, device, serviceDataUuid,
          events: events);

  /// Will try to deprovision the specified [ProvisionedMeshNode] by sending a unicast [ConfigNodeReset] message.
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
      utils_provisioning.cancelProvisioning(meshManagerApi, _bleScanner, bleMeshManager);

  /// Will scan for **unprovisioned** nodes.
  ///
  /// Returns a [List] of [DiscoveredDevice] that may be empty if no device is in range.
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Future<List<DiscoveredDevice>> unprovisionedNodesInRange({
    Duration timeoutDuration = defaultScanDuration,
  }) =>
      _bleScanner.unprovisionedNodesInRange(timeoutDuration: timeoutDuration);

  /// Will scan for **unprovisioned** nodes.
  ///
  /// Returns a [Stream] of [DiscoveredDevice].
  ///
  /// To stop the scan, make sure to cancel any subscription to this [Stream].
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Stream<DiscoveredDevice> scanForUnprovisionedNodes() => _bleScanner.scanForUnprovisionedNodes();

  /// Will scan for **provisioned** nodes.
  ///
  /// Returns a [List] of [DiscoveredDevice] that may be empty if no device is in range.
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Future<List<DiscoveredDevice>> provisionedNodesInRange({
    Duration timeoutDuration = defaultScanDuration,
  }) =>
      _bleScanner.provisionedNodesInRange(timeoutDuration: timeoutDuration);

  /// Will scan for **provisioned** nodes.
  ///
  /// Returns a [Stream] of [DiscoveredDevice] for the user to listen to.
  ///
  /// To stop the scan, user has to make sure to cancel any subscription to this [Stream].
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Stream<DiscoveredDevice> scanForProxy() => _bleScanner.scanForProxy();

  /// Will scan for devices that broadcast given services.
  ///
  /// Returns a [Stream] of [DiscoveredDevice] for the user to listen to.
  ///
  /// To stop the scan, user has to make sure to cancel any subscription to this [Stream].
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Stream<DiscoveredDevice> scanWithServices(List<Uuid> services) => _bleScanner.scanWithServices(services);

  /// Will scan for the given node uid.
  ///
  /// It will scan by default for **unprovisioned** nodes, but one can switch to proxy candidates using the [isProxy] bool flag.
  ///
  /// Returns a [DiscoveredDevice] or null if not found after [timeoutDuration] (defaults to 5sec).
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Future<DiscoveredDevice?> searchForSpecificNode(
    String uid, {
    bool isProxy = false,
    Duration timeoutDuration = defaultScanDuration,
  }) =>
      _bleScanner.searchForSpecificNode(uid, timeoutDuration, isProxy);

  /// Provide a [Stream] of the current [BleStatus] of the host device.
  Stream<BleStatus> get bleStatus => _bleScanner.bleStatus;
}
