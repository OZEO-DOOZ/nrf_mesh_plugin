import 'package:nordic_nrf_mesh/src/constants.dart';

/// An [Exception] that can be thrown during the provisioning process
class NrfMeshProvisioningException implements Exception {
  final ProvisioningFailureCode? code;
  final String? message;
  NrfMeshProvisioningException([this.code, this.message]);
  @override
  String toString() => 'NrfMeshProvisioningException($code, $message)';
}
