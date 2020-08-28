import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/models/group/group.dart';
import 'package:nordic_nrf_mesh/src/provisioned_mesh_node.dart';

class MeshNetwork {
  MethodChannel _methodChannel;

  final String _id;

  MeshNetwork(this._id) {
    _methodChannel = MethodChannel('$namespace/mesh_network/$id/methods');
  }

  String get id => _id;

  Future<String> get name => _methodChannel.invokeMethod('getMeshNetworkName');

  Future<int> nextAvailableUnicastAddress(int elementSize) =>
      _methodChannel.invokeMethod('nextAvailableUnicastAddress', {'elementSize': elementSize});

  Future<int> get highestAllocatableAddress => _methodChannel.invokeMethod('highestAllocatableAddress');

  Future<void> assignUnicastAddress(int unicastAddress) =>
      _methodChannel.invokeMethod('assignUnicastAddress', {'unicastAddress': unicastAddress});

  Future<String> selectedProvisionerUuid() => _methodChannel.invokeMethod('selectedProvisionerUuid');

  Future<int> getSequenceNumber(int address) =>
      _methodChannel.invokeMethod('getSequenceNumberForAddress', {'address': address});

  Future<GroupData> createGroupWithName(String name) async {
    final result = await _methodChannel.invokeMethod('createGroupWithName', {'name': name});
    return GroupData.fromJson(result);
  }

  Future<List<ProvisionedMeshNode>> get nodes async {
    final _nodes = await _methodChannel.invokeMethod<List<dynamic>>('nodes');
    //  skip 1 is to skip the provisionner since it's not a provisioned mesh node
    return _nodes.map((e) => ProvisionedMeshNode(e['uuid'])).toList();
  }

  @override
  String toString() => 'MeshNetwork{ $_id }';
}
