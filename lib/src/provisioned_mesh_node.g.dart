// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provisioned_mesh_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelData _$ModelDataFromJson(Map json) {
  return ModelData(
    json['key'] as int,
    json['modelId'] as int,
    (json['subscribedAddresses'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$ModelDataToJson(ModelData instance) => <String, dynamic>{
      'key': instance.key,
      'modelId': instance.modelId,
      'subscribedAddresses': instance.subscribedAddresses,
    };

ElementData _$ElementDataFromJson(Map json) {
  return ElementData(
    json['key'] as int,
    json['address'] as int,
    json['locationDescriptor'] as int,
    (json['models'] as List)
        ?.map((e) => e == null ? null : ModelData.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$ElementDataToJson(ElementData instance) =>
    <String, dynamic>{
      'key': instance.key,
      'address': instance.address,
      'locationDescriptor': instance.locationDescriptor,
      'models': instance.models,
    };
