import 'package:nordic_nrf_mesh/src/contants.dart';

/// An [Exception] that can be thrown during the lifecycle of a BLE connection
class BleManagerException implements Exception {
  final BleManagerFailureCode? code;
  final String? message;
  const BleManagerException([this.code, this.message]);
  @override
  String toString() => 'BleManagerException($code, $message)';
}
