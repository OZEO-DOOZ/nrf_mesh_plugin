import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/constants.dart';

import 'ble_manager.dart'; // for mesh guid constants

/// {@template ble_scanner_error}
/// A data class used to hold some data when an ble scan error occur
/// {@endtemplate}
class BleScannerError {
  final String message;
  final Object error;

  /// {@macro ble_scanner_error}
  const BleScannerError(this.message, this.error);
}

/// {@template ble_scanner}
/// This singleton is used to wrap the Bluetooth scanning features of [FlutterReactiveBle].
/// {@endtemplate}
class BleScanner {
  static final BleScanner _instance = BleScanner._();

  BleScanner._();

  /// {@macro ble_scanner}
  factory BleScanner() => _instance;

  /// The entry point for BLE library
  final FlutterReactiveBle _flutterReactiveBle = FlutterReactiveBle();

  /// {@macro ble_status_stream}
  Stream<BleStatus> get bleStatusStream => _flutterReactiveBle.statusStream;

  /// {@macro ble_status}
  BleStatus get bleStatus => _flutterReactiveBle.status;

  /// A [Stream] providing any [BleScannerError] that could occur when using (un)provisionedNodesInRange methods
  Stream<BleScannerError> get onScanErrorStream => _onScanErrorController.stream;
  late final StreamController<BleScannerError> _onScanErrorController = StreamController<BleScannerError>.broadcast();

  /// Used to close the [onScanErrorStream]
  void dispose() {
    _onScanErrorController.close();
  }

  /// Will begin a ble scan with the given parameters or defaults and wait for [timeoutDuration].
  ///
  /// Returns a List of [ScanResult] that may be empty if no device is in range.
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Future<List<DiscoveredDevice>> _scanWithParamsAsFuture({
    ScanMode scanMode = ScanMode.lowLatency,
    List<Uuid> withServices = const [],
    Duration timeoutDuration = kDefaultScanDuration,
  }) async {
    if (Platform.isIOS || Platform.isAndroid) {
      final scanResults = <DiscoveredDevice>[];
      final streamSub = _flutterReactiveBle
          .scanForDevices(
        withServices: withServices,
        scanMode: scanMode,
      )
          .listen((device) => scanResults.add(device), onError: (onError) {
        if (!_onScanErrorController.isClosed && _onScanErrorController.hasListener) {
          _onScanErrorController.add(BleScannerError('Scanner Error', onError));
        }
      });
      await Future.delayed(timeoutDuration, () => streamSub.cancel());
      return scanResults;
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  /// Will begin a ble scan with the given parameters or defaults.
  ///
  /// Returns a [Stream] of [DiscoveredDevice].
  ///
  /// To stop the scan, make sure to cancel any subscription to this [Stream].
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Stream<DiscoveredDevice> _scanWithParamsAsStream({
    ScanMode scanMode = ScanMode.lowLatency,
    List<Uuid> withServices = const [],
  }) {
    if (Platform.isIOS || Platform.isAndroid) {
      return _flutterReactiveBle.scanForDevices(
        withServices: withServices,
        scanMode: scanMode,
      );
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  /// {@macro get_specific_node}
  Future<DiscoveredDevice?> searchForSpecificNode(
    String deviceNameOrId,
    Duration scanTimeout,
    bool forProxy,
  ) async {
    DiscoveredDevice? result;
    try {
      result = await _scanWithParamsAsStream(
        withServices: [forProxy ? meshProxyUuid : meshProvisioningUuid],
      ).firstWhere((s) => s.name == deviceNameOrId || s.id == deviceNameOrId).timeout(scanTimeout);
    } on StateError catch (e) {
      debugPrint('[NordicNrfMesh] no device found with given deviceNameOrId : $deviceNameOrId\n$e');
    } on TimeoutException catch (e) {
      debugPrint('[NordicNrfMesh] no device found with given deviceNameOrId : $deviceNameOrId\n$e');
    }
    return result;
  }

  /// {@macro get_unprovisioned}
  Future<List<DiscoveredDevice>> unprovisionedNodesInRange({
    Duration timeoutDuration = kDefaultScanDuration,
  }) =>
      _scanWithParamsAsFuture(
        withServices: [meshProvisioningUuid],
        timeoutDuration: timeoutDuration,
      );

  /// {@macro scan_unprovisioned}
  Stream<DiscoveredDevice> scanForUnprovisionedNodes() => _scanWithParamsAsStream(withServices: [meshProvisioningUuid]);

  /// {@macro get_provisioned}
  Future<List<DiscoveredDevice>> provisionedNodesInRange({
    Duration timeoutDuration = kDefaultScanDuration,
  }) =>
      _scanWithParamsAsFuture(
        withServices: [meshProxyUuid],
        timeoutDuration: timeoutDuration,
      );

  /// {@macro scan_provisioned}
  Stream<DiscoveredDevice> scanForProxy() => _scanWithParamsAsStream(withServices: [meshProxyUuid]);

  /// {@macro custom_scan}
  Stream<DiscoveredDevice> scanWithServices(List<Uuid> services) => _scanWithParamsAsStream(withServices: services);
}
