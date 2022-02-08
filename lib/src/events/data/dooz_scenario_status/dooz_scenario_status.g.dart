// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dooz_scenario_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DoozScenarioStatusData _$_$_DoozScenarioStatusDataFromJson(Map<String, dynamic> json) {
  return _$_DoozScenarioStatusData(
    json['scenarioId'] as int,
    json['command'] as int,
    json['io'] as int,
    json['isActive'] as bool,
    json['unused'] as int,
    json['value'] as int,
    json['transition'] as int,
    json['startAt'] as int,
    json['duration'] as int,
    json['daysInWeek'] as int,
    json['correlation'] as int,
    json['extra'] as int,
    json['source'] as int,
    json['destination'] as int,
  );
}

Map<String, dynamic> _$_$_DoozScenarioStatusDataToJson(_$_DoozScenarioStatusData instance) => <String, dynamic>{
      'scenarioId': instance.scenarioId,
      'command': instance.command,
      'io': instance.io,
      'isActive': instance.isActive,
      'unused': instance.unused,
      'value': instance.value,
      'transition': instance.transition,
      'startAt': instance.startAt,
      'duration': instance.duration,
      'daysInWeek': instance.daysInWeek,
      'correlation': instance.correlation,
      'extra': instance.extra,
      'source': instance.source,
      'destination': instance.destination,
    };
