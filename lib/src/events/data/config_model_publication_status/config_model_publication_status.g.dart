// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model_publication_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConfigModelPublicationStatus _$_$_ConfigModelPublicationStatusFromJson(
    Map<String, dynamic> json) {
  return _$_ConfigModelPublicationStatus(
    json['elementAddress'] as int,
    json['publishAddress'] as int,
    json['appKeyIndex'] as int,
    json['credentialFlag'] as bool,
    json['publishTtl'] as int,
    json['publicationSteps'] as int,
    json['publicationResolution'] as int,
    json['publishRetransmitCount'] as int,
    json['publishRetransmitIntervalSteps'] as int,
    json['modelIdentifier'] as int,
    json['isSuccessful'] as bool,
  );
}

Map<String, dynamic> _$_$_ConfigModelPublicationStatusToJson(
        _$_ConfigModelPublicationStatus instance) =>
    <String, dynamic>{
      'elementAddress': instance.elementAddress,
      'publishAddress': instance.publishAddress,
      'appKeyIndex': instance.appKeyIndex,
      'credentialFlag': instance.credentialFlag,
      'publishTtl': instance.publishTtl,
      'publicationSteps': instance.publicationSteps,
      'publicationResolution': instance.publicationResolution,
      'publishRetransmitCount': instance.publishRetransmitCount,
      'publishRetransmitIntervalSteps': instance.publishRetransmitIntervalSteps,
      'modelIdentifier': instance.modelIdentifier,
      'isSuccessful': instance.isSuccessful,
    };
