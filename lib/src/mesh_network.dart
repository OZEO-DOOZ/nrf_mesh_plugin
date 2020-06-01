import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';

class MeshNetwork {
  final _methodChannel = MethodChannel('$namespace/mesh_network/methods');

  final String _meshName;
  final String id;

  MeshNetwork(this.id, this._meshName);

  String get meshName => _meshName;

  Future<String> getId() => _methodChannel.invokeMethod('getId');

  @override
  String toString() => 'MeshNetwork{ $_meshName }';
}
