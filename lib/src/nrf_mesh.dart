import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_scanner.dart';
import 'package:nordic_nrf_mesh/src/constants.dart';
import 'package:nordic_nrf_mesh/src/utils/provisioning.dart' as utils_provisioning;

/// {@template nordic_nrf_mesh}
/// The entry point for the plugin.
/// It exposes some important methods such as Bluetooth scanning and mesh (de)provisioning.
///
/// To leverage all Bluetooth capabilities, one shall instantiate [BleMeshManager].
///
/// To use the Nordic APIs, one should use the [MeshManagerApi] available via the [meshManagerApi] getter of the [NordicNrfMesh] instance.
/// {@endtemplate}
///
/// {@macro mesh_manager_api}
class NordicNrfMesh {
  final _methodChannel = const MethodChannel('$namespace/methods');

  Future<String> get platformVersion async {
    final version = await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// {@macro ble_scanner}
  late final BleScanner _bleScanner = BleScanner();

  /// {@macro mesh_manager_api}
  MeshManagerApi get meshManagerApi => _meshManagerApi;
  late final MeshManagerApi _meshManagerApi = MeshManagerApi();

  /// {@template provisioning}
  /// Will try to provision the specified [DiscoveredDevice].
  ///
  /// After the process or if any error occurs, the [BleManager] will be disconnected from device.
  ///
  /// Returns a [ProvisionedMeshNode] if success.
  ///
  /// Throws an [NrfMeshProvisioningException] if provisioning failed
  /// or an [UnsupportedError] if the current OS is not supported.
  /// {@endtemplate}
  Future<ProvisionedMeshNode> provisioning(
    final MeshManagerApi meshManagerApi,
    final BleMeshManager bleMeshManager,
    final DiscoveredDevice device,
    final String serviceDataUuid, {
    final utils_provisioning.ProvisioningEvent? events,
  }) =>
      utils_provisioning.provisioning(meshManagerApi, bleMeshManager, _bleScanner, device, serviceDataUuid,
          events: events);

  /// {@template deprovision}
  /// Will try to deprovision the specified [ProvisionedMeshNode] by sending [ConfigNodeReset] message via the unicast address.
  ///
  /// Returns a [ConfigNodeResetStatus] or null if timeout after 5sec.
  ///
  /// Throws a method channel error "NOT FOUND" if not found in the currently loaded mesh n/w
  /// or an [UnsupportedError] if the current OS is not supported.
  /// {@endtemplate}
  Future<ConfigNodeResetStatus> deprovision(
    final MeshManagerApi meshManagerApi,
    final ProvisionedMeshNode meshNode,
  ) =>
      meshManagerApi.deprovision(meshNode);

  /// {@template cancel_provisioning}
  /// Will try to cancel the provisioning.
  ///
  /// Returns `true` if the call has been successful, `false` otherwise.
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  /// {@endtemplate}
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

  /// Will scan for the given device using name or id (MAC on Android or UUID on iOS).
  ///
  /// It will scan by default for **unprovisioned** nodes, but one can switch to proxy candidates using the [isProxy] bool flag.
  ///
  /// Returns a [DiscoveredDevice] or null if not found after [timeoutDuration] (defaults to 5sec).
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Future<DiscoveredDevice?> searchForSpecificNode(
    String deviceNameOrId, {
    bool isProxy = false,
    Duration timeoutDuration = defaultScanDuration,
  }) =>
      _bleScanner.searchForSpecificNode(deviceNameOrId, timeoutDuration, isProxy);

  /// Provide a [Stream] of the current [BleStatus] of the host device.
  Stream<BleStatus> get bleStatusStream => _bleScanner.bleStatusStream;

  /// Will return the last known [BleStatus] (tracked via stream by BLE library, so it should always be up-to-date)
  BleStatus get bleStatus => _bleScanner.bleStatus;
}
