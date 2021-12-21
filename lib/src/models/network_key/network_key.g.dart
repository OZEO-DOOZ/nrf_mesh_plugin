// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NetworkKey _$_$_NetworkKeyFromJson(Map<String, dynamic> json) {
  return _$_NetworkKey(
    json['name'] as String,
    json['netKeyIndex'] as int,
    json['phase'] as int,
    json['phaseDescription'] as String,
    json['isMinSecurity'] as bool,
    (json['netKeyBytes'] as List<dynamic>).map((e) => e as int).toList(),
    (json['oldNetKeyBytes'] as List<dynamic>?)?.map((e) => e as int).toList(),
    (json['txNetworkKey'] as List<dynamic>).map((e) => e as int).toList(),
    (json['identityKey'] as List<dynamic>).map((e) => e as int).toList(),
    (json['oldIdentityKey'] as List<dynamic>?)?.map((e) => e as int).toList(),
    json['meshUuid'] as String,
    json['timestamp'] as int,
  );
}

Map<String, dynamic> _$_$_NetworkKeyToJson(_$_NetworkKey instance) => <String, dynamic>{
      'name': instance.name,
      'netKeyIndex': instance.netKeyIndex,
      'phase': instance.phase,
      'phaseDescription': instance.phaseDescription,
      'isMinSecurity': instance.isMinSecurity,
      'netKeyBytes': instance.netKeyBytes,
      'oldNetKeyBytes': instance.oldNetKeyBytes,
      'txNetworkKey': instance.txNetworkKey,
      'identityKey': instance.identityKey,
      'oldIdentityKey': instance.oldIdentityKey,
      'meshUuid': instance.meshUuid,
      'timestamp': instance.timestamp,
    };
