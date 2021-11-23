// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_key_refresh_phase_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConfigKeyRefreshPhaseStatus _$_$_ConfigKeyRefreshPhaseStatusFromJson(
    Map<String, dynamic> json) {
  return _$_ConfigKeyRefreshPhaseStatus(
    json['source'] as int,
    json['destination'] as int,
    json['statusCode'] as int,
    json['statusCodeName'] as String,
    json['netKeyIndex'] as int,
    json['transition'] as int,
  );
}

Map<String, dynamic> _$_$_ConfigKeyRefreshPhaseStatusToJson(
        _$_ConfigKeyRefreshPhaseStatus instance) =>
    <String, dynamic>{
      'source': instance.source,
      'destination': instance.destination,
      'statusCode': instance.statusCode,
      'statusCodeName': instance.statusCodeName,
      'netKeyIndex': instance.netKeyIndex,
      'transition': instance.transition,
    };
