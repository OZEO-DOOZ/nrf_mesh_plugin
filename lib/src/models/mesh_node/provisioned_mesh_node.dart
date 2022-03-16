import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nordic_nrf_mesh/src/constants.dart';

part 'provisioned_mesh_node.g.dart';

/// {@template model_data}
/// A serializable data class used to hold data about a specific model of a mesh node
/// {@endtemplate}
@JsonSerializable(anyMap: true)
class ModelData {
  final int key;
  final int modelId;
  final List<int> subscribedAddresses;
  final List<int> boundAppKey;

  /// {@macro model_data}
  ModelData(this.key, this.modelId, this.subscribedAddresses, this.boundAppKey);

  /// Provide a constructor to get [ModelData] from JSON [Map].
  /// {@macro model_data}
  factory ModelData.fromJson(Map json) => _$ModelDataFromJson(json);

  /// Provide a constructor to get [Map] from [ModelData].
  /// {@macro model_data}
  Map<String, dynamic> toJson() => _$ModelDataToJson(this);

  @override
  String toString() => 'ModelData ${toJson()}';
}

/// {@template element_data}
/// A serializable data class used to hold data about a specific element of a mesh node
/// {@endtemplate}
@JsonSerializable(anyMap: true)
class ElementData {
  final int key;
  final int address;
  final String name;
  final int locationDescriptor;
  final List<ModelData> models;

  /// {@macro element_data}
  ElementData(this.key, this.name, this.address, this.locationDescriptor, this.models);

  /// Provide a constructor to get [ElementData] from JSON [Map].
  /// {@macro element_data}
  factory ElementData.fromJson(Map json) => _$ElementDataFromJson(json.cast<String, dynamic>());

  /// Provide a constructor to get [Map] from [ElementData].
  /// {@macro element_data}
  Map<String, dynamic> toJson() => _$ElementDataToJson(this);

  @override
  String toString() => 'ElementData ${toJson()}';
}

/// {@template provisioned_node}
/// A class used to expose some data of a given **provisioned** mesh node
/// {@endtemplate}
class ProvisionedMeshNode {
  final MethodChannel _methodChannel;
  final String uuid;

  /// {@macro provisioned_node}
  ProvisionedMeshNode(this.uuid) : _methodChannel = MethodChannel('$namespace/provisioned_mesh_node/$uuid/methods');

  /// Will return the unicast address of this node as stored in the local database
  Future<int> get unicastAddress async => (await _methodChannel.invokeMethod<int>('unicastAddress'))!;

  /// Will set the name of this node to be stored in the local database
  set nodeName(String name) => _methodChannel.invokeMethod('nodeName', {'name': name});

  /// Will return the name of this node as stored in the local database
  Future<String> get name async => (await _methodChannel.invokeMethod<String>('name'))!;

  /// Will return the list of elements of this node as stored in the local database
  Future<List<ElementData>> get elements async {
    final _elements = await _methodChannel.invokeMethod<List>('elements');
    return _elements!.map((e) => ElementData.fromJson(e)).toList();
  }
}
