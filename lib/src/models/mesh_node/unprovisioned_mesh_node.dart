import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';

part 'unprovisioned_mesh_node.g.dart';

@JsonSerializable()
class UnprovisionedMeshNode {
  final MethodChannel _methodChannel;
  final String uuid;
  final List<int>? provisionerPublicKeyXY;

  UnprovisionedMeshNode(this.uuid, this.provisionerPublicKeyXY)
      : _methodChannel = MethodChannel('$namespace/unprovisioned_mesh_node/$uuid/methods');

  factory UnprovisionedMeshNode.fromJson(Map json) => _$UnprovisionedMeshNodeFromJson(json.cast<String, dynamic>());

  Future<int> getNumberOfElements() async => (await _methodChannel.invokeMethod<int>('getNumberOfElements'))!;

  Map<String, dynamic> toJson() => _$UnprovisionedMeshNodeToJson(this);
}
