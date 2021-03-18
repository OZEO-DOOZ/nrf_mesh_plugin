import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';

import 'ble_manager.dart'; // for mesh guid constants

const Duration defaultScanDuration = Duration(seconds: 3);

class BleScanner {
  static BleScanner _instance;

  BleScanner._();

  factory BleScanner() => _instance ??= BleScanner._();

  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  Future<bool> get isScanning => _flutterBlue.isScanning.first;

  Future stopScan() async {
    if (await _flutterBlue.isScanning.first) {
      await _flutterBlue.stopScan();
    }
  }

  /// Will begin a ble scan with the given parameters or defaults and wait for [timeoutDuration].
  ///
  /// Returns a List of [ScanResult] that may be empty if no device is in range.
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  /// TODO migrate this when using new ble lib
  Future<List<ScanResult>> _scanWithParamsAsFuture({
    ScanMode scanMode = ScanMode.lowLatency,
    List<Guid> withServices = const [],
    Duration timeoutDuration = defaultScanDuration,
    bool allowDuplicates = false,
  }) async {
    if (Platform.isIOS || Platform.isAndroid) {
      // FlutterBlue startScan method returns a dynamic Future.. so we get it and build the List with good Type after the scan is done
      final dynamicResult = await _flutterBlue.startScan(
        withServices: withServices,
        scanMode: scanMode,
        timeout: timeoutDuration,
        allowDuplicates: allowDuplicates,
      );
      final scanResults = <ScanResult>[];
      for (final result in dynamicResult) {
        if (result is ScanResult) {
          scanResults.add(result);
        }
      }
      return scanResults;
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  /// Will begin a ble scan with the given parameters or defaults.
  ///
  /// Returns a [Stream] of [ScanResult] that may be empty if no node is in range.
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  /// TODO migrate this when using new ble lib
  Stream<ScanResult> _scanWithParamsAsStream({
    ScanMode scanMode = ScanMode.lowLatency,
    List<Guid> withServices = const [],
    Duration timeoutDuration = defaultScanDuration,
    bool allowDuplicates = false,
  }) {
    if (Platform.isIOS || Platform.isAndroid) {
      return _flutterBlue.scan(
        withServices: withServices,
        scanMode: scanMode,
        timeout: timeoutDuration,
        allowDuplicates: allowDuplicates,
      );
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  Future<ScanResult> searchForSpecificUID(String uid) {
    final result = _scanWithParamsAsStream(
      withServices: [meshProvisioningUuid],
    ).firstWhere((s) => s.device.id.id == uid, orElse: () => null);
    stopScan();
    return result;
  }

  Future<List<ScanResult>> unprovisionedNodesInRange({
    Duration timeoutDuration = defaultScanDuration,
  }) =>
      _scanWithParamsAsFuture(
        withServices: [meshProvisioningUuid],
        timeoutDuration: timeoutDuration,
      );

  Future<List<ScanResult>> provisionedNodesInRange({
    Duration timeoutDuration = defaultScanDuration,
  }) =>
      _scanWithParamsAsFuture(
        withServices: [meshProxyUuid],
        timeoutDuration: timeoutDuration,
      );

  Stream<ScanResult> scanForProxy({
    Duration timeoutDuration = defaultScanDuration,
  }) =>
      _scanWithParamsAsStream(
        withServices: [meshProxyUuid],
        timeoutDuration: timeoutDuration,
      );
}
