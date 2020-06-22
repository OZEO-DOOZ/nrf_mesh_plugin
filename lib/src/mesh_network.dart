import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';

class MeshNetwork {
  MethodChannel _methodChannel;

  final String _id;

  MeshNetwork(this._id) {
    _methodChannel = MethodChannel('$namespace/mesh_network/$id/methods');
  }

  String get id => _id;

  Future<String> get name => _methodChannel.invokeMethod('getMeshNetworkName');

  Future<int> nextAvailableUnicastAddress(int elementSize) =>
      _methodChannel.invokeMethod('nextAvailableUnicastAddress', {'elementSize': elementSize});

  Future<int> get highestAllocatableAddress => _methodChannel.invokeMethod('highestAllocatableAddress');

  Future<void> assignUnicastAddress(int unicastAddress) =>
      _methodChannel.invokeMethod('assignUnicastAddress', {'unicastAddress': unicastAddress});

  @override
  String toString() => 'MeshNetwork{ $_id }';
}
