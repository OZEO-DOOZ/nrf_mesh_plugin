// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provisioner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Provisioner _$_$_ProvisionerFromJson(Map<String, dynamic> json) {
  return _$_Provisioner(
    json['provisionerName'] as String,
    json['provisionerUuid'] as String,
    json['globalTtl'] as int,
    json['provisionerAddress'] as int,
    (json['allocatedUnicastRanges'] as List<dynamic>)
        .map((e) => AllocatedUnicastRange.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['allocatedGroupRanges'] as List<dynamic>)
        .map((e) => AllocatedGroupRange.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['allocatedSceneRanges'] as List<dynamic>)
        .map((e) => AllocatedSceneRange.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['lastSelected'] as bool,
  );
}

Map<String, dynamic> _$_$_ProvisionerToJson(_$_Provisioner instance) => <String, dynamic>{
      'provisionerName': instance.provisionerName,
      'provisionerUuid': instance.provisionerUuid,
      'globalTtl': instance.globalTtl,
      'provisionerAddress': instance.provisionerAddress,
      'allocatedUnicastRanges': instance.allocatedUnicastRanges,
      'allocatedGroupRanges': instance.allocatedGroupRanges,
      'allocatedSceneRanges': instance.allocatedSceneRanges,
      'lastSelected': instance.lastSelected,
    };
