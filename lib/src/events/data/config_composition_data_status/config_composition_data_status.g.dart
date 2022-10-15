// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_composition_data_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConfigCompositionDataStatusData _$$_ConfigCompositionDataStatusDataFromJson(Map json) =>
    _$_ConfigCompositionDataStatusData(
      json['source'] as int,
      ConfigCompositionDataStatusMeshMessage.fromJson(Map<String, dynamic>.from(json['meshMessage'] as Map)),
    );

Map<String, dynamic> _$$_ConfigCompositionDataStatusDataToJson(_$_ConfigCompositionDataStatusData instance) =>
    <String, dynamic>{
      'source': instance.source,
      'meshMessage': instance.meshMessage,
    };

_$_ConfigCompositionDataStatusMeshMessage _$$_ConfigCompositionDataStatusMeshMessageFromJson(
        Map<String, dynamic> json) =>
    _$_ConfigCompositionDataStatusMeshMessage(
      json['source'] as int,
      json['aszmic'] as int?,
      json['destination'] as int,
    );

Map<String, dynamic> _$$_ConfigCompositionDataStatusMeshMessageToJson(
        _$_ConfigCompositionDataStatusMeshMessage instance) =>
    <String, dynamic>{
      'source': instance.source,
      'aszmic': instance.aszmic,
      'destination': instance.destination,
    };
