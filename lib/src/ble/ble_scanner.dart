import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
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
  static late final BleScanner _instance = BleScanner._();

  BleScanner._();

  factory BleScanner() => _instance;

  final FlutterReactiveBle _flutterReactiveBle = FlutterReactiveBle();

  Stream<BleStatus> get bleStatus => _flutterReactiveBle.statusStream;

  late final StreamController<BleScannerError> _onScanErrorController = StreamController<BleScannerError>.broadcast();

  Stream<BleScannerError> get onScanErrorStream => _onScanErrorController.stream;

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

  Future<DiscoveredDevice?> searchForSpecificNode(
    String uid,
    Duration scanTimeout,
    bool forProxy, {
    Uuid? optionalService,
  }) async {
    DiscoveredDevice? result;
    try {
      final services = [forProxy ? meshProxyUuid : meshProvisioningUuid];
      if (optionalService != null) {
        services.add(optionalService);
      }
      result = await _scanWithParamsAsStream(
        withServices: services,
      ).firstWhere((s) => s.id == uid).timeout(scanTimeout);
    } on StateError catch (e) {
      debugPrint('[NordicNrfMesh] StateError -- no device found with UUID : $uid\n$e\n${e.message}');
    } on TimeoutException catch (e) {
      debugPrint('[NordicNrfMesh] TimeoutException -- no device found with UUID : $uid\n$e\n${e.message}');
    }
    return result;
  }

  Future<List<DiscoveredDevice>> unprovisionedNodesInRange({
    Duration timeoutDuration = defaultScanDuration,
    Uuid? optionalService,
  }) {
    final services = [meshProvisioningUuid];
    if (optionalService != null) {
      services.add(optionalService);
    }
    return _scanWithParamsAsFuture(
      withServices: services,
      timeoutDuration: timeoutDuration,
    );
  }

  Stream<DiscoveredDevice> scanForUnprovisionedNodes({Uuid? optionalService}) {
    final services = [meshProvisioningUuid];
    if (optionalService != null) {
      services.add(optionalService);
    }
    return _scanWithParamsAsStream(withServices: services);
  }

  Future<List<DiscoveredDevice>> provisionedNodesInRange({
    Duration timeoutDuration = defaultScanDuration,
    Uuid? optionalService,
  }) {
    final services = [meshProxyUuid];
    if (optionalService != null) {
      services.add(optionalService);
    }
    return _scanWithParamsAsFuture(
      withServices: services,
      timeoutDuration: timeoutDuration,
    );
  }

  Stream<DiscoveredDevice> scanForProxy({Uuid? optionalService}) {
    final services = [meshProxyUuid];
    if (optionalService != null) {
      services.add(optionalService);
    }
    return _scanWithParamsAsStream(withServices: services);
  }

  Stream<DiscoveredDevice> scanWithServices(List<Uuid> services) => _scanWithParamsAsStream(withServices: services);
}
