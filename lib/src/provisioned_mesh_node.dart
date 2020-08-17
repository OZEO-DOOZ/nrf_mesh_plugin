import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';

part 'provisioned_mesh_node.g.dart';

@JsonSerializable(anyMap: true)
class ModelData {
  final int key;
  final int modelId;
  final List<int> subscribedAddresses;

  ModelData(this.key, this.modelId, this.subscribedAddresses);

  factory ModelData.fromJson(Map json) => _$ModelDataFromJson(json);
}

@JsonSerializable(anyMap: true)
class ElementData {
  final int key;
  final int address;
  final int locationDescriptor;
  final List<ModelData> models;

  ElementData(this.key, this.address, this.locationDescriptor, this.models);

  factory ElementData.fromJson(Map json) => _$ElementDataFromJson(json.cast<String, dynamic>());
}

class ProvisionedMeshNode {
  final MethodChannel _methodChannel;
  final String uuid;

  ProvisionedMeshNode(this.uuid) : _methodChannel = MethodChannel('$namespace/provisioned_mesh_node/${uuid}/methods');

  Future<int> get unicastAddress => _methodChannel.invokeMethod('unicastAddress');

  Future<void> nodeName(String name) => _methodChannel.invokeMethod('nodeName', {'name': name});

  Future<List> get elements async {
    final _elements = await _methodChannel.invokeMethod<List>('elements');
    return _elements.map((e) => ElementData.fromJson(e)).toList();
  }
}
