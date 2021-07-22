// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_level_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GenericLevelStatusData _$_$_GenericLevelStatusDataFromJson(Map<String, dynamic> json) {
  return _$_GenericLevelStatusData(
    json['level'] as int,
    json['targetLevel'] as int,
    json['transitionSteps'] as int,
    json['transitionResolution'] as int,
    json['source'] as int,
    json['destination'] as int,
  );
}

Map<String, dynamic> _$_$_GenericLevelStatusDataToJson(_$_GenericLevelStatusData instance) => <String, dynamic>{
      'level': instance.level,
      'targetLevel': instance.targetLevel,
      'transitionSteps': instance.transitionSteps,
      'transitionResolution': instance.transitionResolution,
      'source': instance.source,
      'destination': instance.destination,
    };
