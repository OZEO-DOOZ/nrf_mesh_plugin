import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';

class MeshNetwork {
  MethodChannel _methodChannel;

  final String _meshName;
  final String _id;

  MeshNetwork(this._id, this._meshName) {
    _methodChannel = MethodChannel('$namespace/mesh_network/$id/methods');
  }

  String get id => _id;

  String get meshName => _meshName;

  Future<String> getId() => _methodChannel.invokeMethod('getId');

  @override
  String toString() => 'MeshNetwork{ $_id, $_meshName }';
}
