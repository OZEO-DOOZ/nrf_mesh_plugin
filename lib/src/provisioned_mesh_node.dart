import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';

class ProvisionedMeshNode {
  final MethodChannel _methodChannel;
  final String uuid;

  ProvisionedMeshNode(this.uuid) : _methodChannel = MethodChannel('$namespace/provisioned_mesh_node/${uuid}/methods');

  Future<int> get unicastAddress => _methodChannel.invokeMethod('unicastAddress');

  Future<void> nodeName(String name) => _methodChannel.invokeMethod('nodeName', {'name': name});

  Future<List> get elements async {
    final _elements = await _methodChannel.invokeMethod<List<dynamic>>('elements');
    return _elements;
  }
}
