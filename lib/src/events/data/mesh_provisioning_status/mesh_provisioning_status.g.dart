// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mesh_provisioning_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MeshProvisioningStatusData _$_$_MeshProvisioningStatusDataFromJson(
    Map<String, dynamic> json) {
  return _$_MeshProvisioningStatusData(
    json['state'] as String,
    (json['data'] as List)?.map((e) => e as int)?.toList(),
    json['meshNodeUuid'] as String,
  );
}

Map<String, dynamic> _$_$_MeshProvisioningStatusDataToJson(
        _$_MeshProvisioningStatusData instance) =>
    <String, dynamic>{
      'state': instance.state,
      'data': instance.data,
      'meshNodeUuid': instance.meshNodeUuid,
    };
