// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mesh_provisioning_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UnprovisionedMeshNodeData _$_$_UnprovisionedMeshNodeDataFromJson(
    Map<String, dynamic> json) {
  return _$_UnprovisionedMeshNodeData(
    uuid: json['uuid'] as String,
    provisionerPublicKeyXY: (json['provisionerPublicKeyXY'] as List)
            ?.map((e) => e as int)
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$_$_UnprovisionedMeshNodeDataToJson(
        _$_UnprovisionedMeshNodeData instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'provisionerPublicKeyXY': instance.provisionerPublicKeyXY,
    };

_$_MeshProvisioningStatusData _$_$_MeshProvisioningStatusDataFromJson(
    Map json) {
  return _$_MeshProvisioningStatusData(
    json['state'] as String,
    (json['data'] as List)?.map((e) => e as int)?.toList(),
    json['meshNode'] == null
        ? null
        : UnprovisionedMeshNodeData.fromJson(json['meshNode'] as Map),
  );
}

Map<String, dynamic> _$_$_MeshProvisioningStatusDataToJson(
        _$_MeshProvisioningStatusData instance) =>
    <String, dynamic>{
      'state': instance.state,
      'data': instance.data,
      'meshNode': instance.meshNode?.toJson(),
    };
