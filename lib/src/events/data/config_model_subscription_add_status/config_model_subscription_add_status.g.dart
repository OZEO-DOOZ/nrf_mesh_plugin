// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model_subscription_add_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConfigModelSubscriptionAddStatus
    _$_$_ConfigModelSubscriptionAddStatusFromJson(Map<String, dynamic> json) {
  return _$_ConfigModelSubscriptionAddStatus(
    json['source'] as int,
    json['destination'] as int,
    json['elementAddress'] as int,
    json['subscriptionAddress'] as int,
    json['modelIdentifier'] as int,
  );
}

Map<String, dynamic> _$_$_ConfigModelSubscriptionAddStatusToJson(
        _$_ConfigModelSubscriptionAddStatus instance) =>
    <String, dynamic>{
      'source': instance.source,
      'destination': instance.destination,
      'elementAddress': instance.elementAddress,
      'subscriptionAddress': instance.subscriptionAddress,
      'modelIdentifier': instance.modelIdentifier,
    };
