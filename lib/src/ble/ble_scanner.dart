import 'dart:async';
import 'dart:io';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

import 'ble_manager.dart'; // for mesh guid constants

const Duration defaultScanDuration = Duration(seconds: 5);

class BleScannerError {
  final String message;
  final Object error;

  const BleScannerError(this.message, this.error);
}

class BleScanner {
  static BleScanner _instance;

  BleScanner._();

  factory BleScanner() => _instance ??= BleScanner._();

  final FlutterReactiveBle _flutterReactiveBle = FlutterReactiveBle();

  Stream<BleStatus> get bleStatus => _flutterReactiveBle.statusStream;

  StreamController<BleScannerError> onErrorController;

  Stream<BleScannerError> get onError => onErrorController.stream;

  void initStream() {
    onErrorController = StreamController<BleScannerError>();
  }

  void dispose() {
    onErrorController?.close();
  }

  /// Will begin a ble scan with the given parameters or defaults and wait for [timeoutDuration].
  ///
  /// Returns a List of [ScanResult] that may be empty if no device is in range.
  ///
  /// Throws an [UnsupportedError] if the current OS is not supported.
  Future<List<DiscoveredDevice>> _scanWithParamsAsFuture({
    ScanMode scanMode = ScanMode.lowLatency,
    List<Uuid> withServices = const [],
    Duration timeoutDuration = defaultScanDuration,
  }) async {
    if (Platform.isIOS || Platform.isAndroid) {
      final scanResults = <DiscoveredDevice>[];
      final streamSub = _flutterReactiveBle
          .scanForDevices(
        withServices: withServices,
        scanMode: scanMode,
      )
          .listen((device) => scanResults.add(device), onError: (onError) {
        if (!onErrorController.isClosed && onErrorController.hasListener) {
          onErrorController.add(BleScannerError('Scanner Error', onError));
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

  Future<DiscoveredDevice> searchForSpecificUID(String uid, {bool forProxy = false}) async {
    final result = _scanWithParamsAsStream(
      withServices: [forProxy ? meshProxyUuid : meshProvisioningUuid],
    ).firstWhere((s) => validScanResult(s, uid), orElse: () => null);
    return result;
  }

  bool validScanResult(DiscoveredDevice s, String uid) {
    if (Platform.isAndroid) {
      return s.id == uid;
    } else if (Platform.isIOS) {
      //TODO
      throw UnimplementedError();
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  Future<List<DiscoveredDevice>> unprovisionedNodesInRange({
    Duration timeoutDuration = defaultScanDuration,
  }) =>
      _scanWithParamsAsFuture(
        withServices: [meshProvisioningUuid],
        timeoutDuration: timeoutDuration,
      );

  Stream<DiscoveredDevice> scanForUnprovisionedNodes() => _scanWithParamsAsStream(withServices: [meshProvisioningUuid]);

  Future<List<DiscoveredDevice>> provisionedNodesInRange({
    Duration timeoutDuration = defaultScanDuration,
  }) =>
      _scanWithParamsAsFuture(
        withServices: [meshProxyUuid],
        timeoutDuration: timeoutDuration,
      );

  Stream<DiscoveredDevice> scanForProxy() => _scanWithParamsAsStream(withServices: [meshProxyUuid]);
}
