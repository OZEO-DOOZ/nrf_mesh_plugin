// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_provisioning_pdu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SendProvisioningPduData _$$_SendProvisioningPduDataFromJson(Map json) => _$_SendProvisioningPduData(
      (json['pdu'] as List<dynamic>).map((e) => e as int).toList(),
      UnprovisionedMeshNode.fromJson(json['meshNode'] as Map),
    );

Map<String, dynamic> _$$_SendProvisioningPduDataToJson(_$_SendProvisioningPduData instance) => <String, dynamic>{
      'pdu': instance.pdu,
      'meshNode': instance.meshNode.toJson(),
    };
