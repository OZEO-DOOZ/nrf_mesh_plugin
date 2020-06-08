// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_provisioning_pdu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SendProvisioningPduData _$_$_SendProvisioningPduDataFromJson(
    Map<String, dynamic> json) {
  return _$_SendProvisioningPduData(
    (json['pdu'] as List)?.map((e) => e as int)?.toList(),
    json['meshNodeUuid'] as String,
  );
}

Map<String, dynamic> _$_$_SendProvisioningPduDataToJson(
        _$_SendProvisioningPduData instance) =>
    <String, dynamic>{
      'pdu': instance.pdu,
      'meshNodeUuid': instance.meshNodeUuid,
    };
