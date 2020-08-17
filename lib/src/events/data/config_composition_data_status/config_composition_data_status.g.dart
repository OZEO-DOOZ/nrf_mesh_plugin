// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_composition_data_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConfigCompositionDataStatusData _$_$_ConfigCompositionDataStatusDataFromJson(
    Map json) {
  return _$_ConfigCompositionDataStatusData(
    json['src'] as int,
    json['meshMessage'] == null
        ? null
        : ConfigCompositionDataStatusMeshMessage.fromJson(
            (json['meshMessage'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$_$_ConfigCompositionDataStatusDataToJson(
        _$_ConfigCompositionDataStatusData instance) =>
    <String, dynamic>{
      'src': instance.src,
      'meshMessage': instance.meshMessage,
    };

_$_ConfigCompositionDataStatusMeshMessage
    _$_$_ConfigCompositionDataStatusMeshMessageFromJson(
        Map<String, dynamic> json) {
  return _$_ConfigCompositionDataStatusMeshMessage(
    json['src'] as int,
    json['aszmic'] as int,
    json['dst'] as int,
  );
}

Map<String, dynamic> _$_$_ConfigCompositionDataStatusMeshMessageToJson(
        _$_ConfigCompositionDataStatusMeshMessage instance) =>
    <String, dynamic>{
      'src': instance.src,
      'aszmic': instance.aszmic,
      'dst': instance.dst,
    };
