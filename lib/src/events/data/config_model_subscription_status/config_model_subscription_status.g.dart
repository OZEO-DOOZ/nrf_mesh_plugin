// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model_subscription_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConfigModelSubscriptionStatus _$_$_ConfigModelSubscriptionStatusFromJson(Map<String, dynamic> json) {
  return _$_ConfigModelSubscriptionStatus(
    json['source'] as int,
    json['destination'] as int,
    json['elementAddress'] as int,
    json['subscriptionAddress'] as int,
    json['modelIdentifier'] as int,
    json['isSuccessful'] as bool,
  );
}

Map<String, dynamic> _$_$_ConfigModelSubscriptionStatusToJson(_$_ConfigModelSubscriptionStatus instance) =>
    <String, dynamic>{
      'source': instance.source,
      'destination': instance.destination,
      'elementAddress': instance.elementAddress,
      'subscriptionAddress': instance.subscriptionAddress,
      'modelIdentifier': instance.modelIdentifier,
      'isSuccessful': instance.isSuccessful,
    };
