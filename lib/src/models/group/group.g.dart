// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GroupData _$_$_GroupDataFromJson(Map<String, dynamic> json) {
  return _$_GroupData(
    json['id'] as int,
    json['name'] as String,
    json['address'] as int,
    json['addressLabel'] as String,
    json['meshUuid'] as String,
    json['parentAddress'] as int,
    json['parentAddressLabel'] as String,
  );
}

Map<String, dynamic> _$_$_GroupDataToJson(_$_GroupData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'addressLabel': instance.addressLabel,
      'meshUuid': instance.meshUuid,
      'parentAddress': instance.parentAddress,
      'parentAddressLabel': instance.parentAddressLabel,
    };
