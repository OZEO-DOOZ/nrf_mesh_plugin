// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unprovisioned_mesh_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnprovisionedMeshNode _$UnprovisionedMeshNodeFromJson(Map<String, dynamic> json) {
  return UnprovisionedMeshNode(
    json['uuid'] as String,
    (json['provisionerPublicKeyXY'] as List<dynamic>).map((e) => e as int).toList(),
  );
}

Map<String, dynamic> _$UnprovisionedMeshNodeToJson(UnprovisionedMeshNode instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'provisionerPublicKeyXY': instance.provisionerPublicKeyXY,
    };
