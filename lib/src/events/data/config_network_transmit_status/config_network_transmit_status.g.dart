// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_network_transmit_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConfigNetworkTransmitStatus _$_$_ConfigNetworkTransmitStatusFromJson(Map<String, dynamic> json) {
  return _$_ConfigNetworkTransmitStatus(
    json['source'] as int,
    json['destination'] as int,
    json['transmitCount'] as int,
    json['transmitIntervalSteps'] as int,
  );
}

Map<String, dynamic> _$_$_ConfigNetworkTransmitStatusToJson(_$_ConfigNetworkTransmitStatus instance) =>
    <String, dynamic>{
      'source': instance.source,
      'destination': instance.destination,
      'transmitCount': instance.transmitCount,
      'transmitIntervalSteps': instance.transmitIntervalSteps,
    };
