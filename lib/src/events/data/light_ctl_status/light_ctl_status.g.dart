// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light_ctl_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LightCtlStatusData _$_$_LightCtlStatusDataFromJson(
    Map<String, dynamic> json) {
  return _$_LightCtlStatusData(
    json['presentLightness'] as int,
    json['targetLightness'] as int,
    json['presentTemperature'] as int,
    json['targetTemperature'] as int,
    json['transitionSteps'] as int,
    json['transitionResolution'] as int,
    json['source'] as int,
    json['destination'] as int,
  );
}

Map<String, dynamic> _$_$_LightCtlStatusDataToJson(
        _$_LightCtlStatusData instance) =>
    <String, dynamic>{
      'presentLightness': instance.presentLightness,
      'targetLightness': instance.targetLightness,
      'presentTemperature': instance.presentTemperature,
      'targetTemperature': instance.targetTemperature,
      'transitionSteps': instance.transitionSteps,
      'transitionResolution': instance.transitionResolution,
      'source': instance.source,
      'destination': instance.destination,
    };
