import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';

class BleScanner {
  static BleScanner _instance;

  BleScanner._();

  factory BleScanner() => _instance ??= BleScanner._();

  Future<List<ScanResult>> scanWithParams(
    ScanMode scanMode,
    List<Guid> withServices,
    Duration timeoutDuration,
    bool allowDuplicates,
  ) async {
    if (Platform.isIOS || Platform.isAndroid) {
      // FlutterBlue startScan method returns a dynamic Future.. so we get it and build the List with good Type after the scan is done
      final dynamicResult = await FlutterBlue.instance.startScan(
        withServices: withServices,
        scanMode: scanMode,
        timeout: timeoutDuration,
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

  Future stopScan(FlutterBlue flutterBlue) => flutterBlue.stopScan();

  Future<int> getDeviceRssi(String uuid) {
    // TODO scan for devices with proxy uuid and return the rssi of the device with correct uuid if found (android --> mac, ios --> uid)
    throw UnimplementedError('waiting for new ble lib');
  }
}
