import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/models/group/group.dart';
import 'package:nordic_nrf_mesh/src/models/provisioner/provisioner.dart';
import 'package:nordic_nrf_mesh/src/provisioned_mesh_node.dart';

abstract class IMeshNetwork {
  Future<List<GroupData>> get groups;
  Future<int> get highestAllocatableAddress;
  Future<String> get name;
  Future<List<ProvisionedMeshNode>> get nodes;
  String get id;
  Future<List<String>> get provisionersUUIDList;
  Future<List<Provisioner>> get provisionersAsJson;

  Future<GroupData> addGroupWithName(String name);

  Future<void> assignUnicastAddress(int unicastAddress);

  Future<List<ElementData>> elementsForGroup(int id);

  Future<int> nextAvailableUnicastAddress(int elementSize);

  Future<bool> removeGroup(int id);

  Future<String> selectedProvisionerUuid();

  Future<void> selectProvisioner(int provisionerIndex);

  Future<bool> addProvisioner(int unicastAddressRange, int groupAddressRange, int sceneAddressRange, int globalTtl);
}

class MeshNetwork implements IMeshNetwork {
  MethodChannel _methodChannel;

  final String _id;

  MeshNetwork(this._id) {
    _methodChannel = MethodChannel('$namespace/mesh_network/$id/methods');
  }

  @override
  Future<List<GroupData>> get groups async {
    final _groups = await _methodChannel.invokeMethod<List>('groups');
    return _groups.cast<Map>().map((e) => GroupData.fromJson(e.cast<String, dynamic>())).toList();
  }

  @override
  Future<int> get highestAllocatableAddress => _methodChannel.invokeMethod('highestAllocatableAddress');

  @override
  Future<List<ElementData>> elementsForGroup(int groupAddress) async {
    final result = await _methodChannel.invokeMethod('getElementsForGroup', {'groupAddress': groupAddress}) as List;
    return result.cast<Map>().map((e) => ElementData.fromJson(e.cast<String, dynamic>())).toList();
  }

  @override
  String get id => _id;

  @override
  Future<String> get name => _methodChannel.invokeMethod('getMeshNetworkName');

  @override
  Future<List<ProvisionedMeshNode>> get nodes async {
    final _nodes = await _methodChannel.invokeMethod<List<dynamic>>('nodes');
    return _nodes.map((e) => ProvisionedMeshNode(e['uuid'])).toList();
  }

  @override
  Future<GroupData> addGroupWithName(String name) async {
    final result = await _methodChannel.invokeMethod<Map>('addGroupWithName', {'name': name});
    if (result['successfullyAdded'] == false) {
      return null;
    }
    return GroupData.fromJson((result.cast<String, dynamic>()['group'] as Map).cast<String, dynamic>());
  }

  @override
  Future<void> assignUnicastAddress(int unicastAddress) =>
      _methodChannel.invokeMethod('assignUnicastAddress', {'unicastAddress': unicastAddress});

  @override
  Future<int> nextAvailableUnicastAddress(int elementSize) =>
      _methodChannel.invokeMethod('nextAvailableUnicastAddress', {'elementSize': elementSize});

  @override
  Future<bool> removeGroup(int groupAddress) =>
      _methodChannel.invokeMethod('removeGroup', {'groupAddress': groupAddress});

  @override
  Future<String> selectedProvisionerUuid() => _methodChannel.invokeMethod('selectedProvisionerUuid');

  @override
  String toString() => 'MeshNetwork{ $_id }';

  @override
  Future<void> selectProvisioner(int provisionerIndex) =>
      _methodChannel.invokeMethod('selectProvisioner', {'provisionerIndex': provisionerIndex});

  @override
  Future<List<String>> get provisionersUUIDList async {
    final result = await _methodChannel.invokeMethod<List>('getProvisionersUUID');
    return result.cast<String>();
  }

  @override
  Future<List<Provisioner>> get provisionersAsJson async {
    var provisioners = <Provisioner>[];
    final result = await _methodChannel.invokeMethod('getProvisionersAsJson');
    var prov = json.decode(result) as List;
    prov.forEach((value) {
      provisioners.add(Provisioner.fromJson(value));
    });
    return provisioners;
  }

  @override
  Future<bool> addProvisioner(int unicastAddressRange, int groupAddressRange, int sceneAddressRange, int globalTtl) {
    if (Platform.isAndroid) {
      return _methodChannel.invokeMethod('addProvisioner', {
        'unicastAddressRange': unicastAddressRange,
        'groupAddressRange': groupAddressRange,
        'sceneAddressRange': sceneAddressRange,
        'globalTtl': globalTtl,
      });
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}
