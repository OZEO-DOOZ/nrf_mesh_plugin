// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light_hsl_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LightHslStatusData _$_$_LightHslStatusDataFromJson(
    Map<String, dynamic> json) {
  return _$_LightHslStatusData(
    json['presentLightness'] as int,
    json['presentHue'] as int,
    json['presentSaturation'] as int,
    json['transitionSteps'] as int,
    json['transitionResolution'] as int,
    json['source'] as int,
    json['destination'] as int,
  );
}

Map<String, dynamic> _$_$_LightHslStatusDataToJson(
        _$_LightHslStatusData instance) =>
    <String, dynamic>{
      'presentLightness': instance.presentLightness,
      'presentHue': instance.presentHue,
      'presentSaturation': instance.presentSaturation,
      'transitionSteps': instance.transitionSteps,
      'transitionResolution': instance.transitionResolution,
      'source': instance.source,
      'destination': instance.destination,
    };
