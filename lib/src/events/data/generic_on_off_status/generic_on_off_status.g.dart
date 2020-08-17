// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_on_off_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GenericOnOffStatusData _$_$_GenericOnOffStatusDataFromJson(
    Map<String, dynamic> json) {
  return _$_GenericOnOffStatusData(
    json['source'] as int,
    json['presentState'] as bool,
    json['targetState'] as bool,
    json['transitionResolution'] as int,
    json['transitionSteps'] as int,
  );
}

Map<String, dynamic> _$_$_GenericOnOffStatusDataToJson(
        _$_GenericOnOffStatusData instance) =>
    <String, dynamic>{
      'source': instance.source,
      'presentState': instance.presentState,
      'targetState': instance.targetState,
      'transitionResolution': instance.transitionResolution,
      'transitionSteps': instance.transitionSteps,
    };
