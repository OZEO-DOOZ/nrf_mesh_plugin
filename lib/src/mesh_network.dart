import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/models/models.dart';

abstract class IMeshNetwork {
  Future<List<GroupData>> get groups;
  Future<int> get highestAllocatableAddress;
  Future<String> get name;
  Future<List<ProvisionedMeshNode>> get nodes;
  String get id;
  Future<List<Provisioner>> get provisionerList;

  Future<GroupData?> addGroupWithName(String name);

  Future<void> assignUnicastAddress(int unicastAddress);

  Future<List<ElementData>> elementsForGroup(int id);

  Future<int> nextAvailableUnicastAddress(int elementSize);

  Future<int> nextAvailableUnicastAddressWithMin(int minAddress, int elementSize);

  Future<bool> removeGroup(int id);

  Future<String> selectedProvisionerUuid();

  Future<void> selectProvisioner(int provisionerIndex);

  Future<bool> addProvisioner(int unicastAddressRange, int groupAddressRange, int sceneAddressRange, int globalTtl);

  Future<bool> updateProvisioner(Provisioner provisioner);

  Future<bool> removeProvisioner(String provisionerUUID);

  Future<bool> deleteNode(String uid);

  Future<Map> getMeshModelSubscriptions(int elementAddress, int modelIdentifier);

  Future<Map> getGroupElementIds(int groupAddress);

  Future<ProvisionedMeshNode?> getNode(int address);

  Future<ProvisionedMeshNode?> getNodeUsingUUID(String uuid);

  Future<NetworkKey> generateNetKey();

  Future<NetworkKey?> getNetKey(int netKeyIndex);

  Future<bool?> removeNetKey(int netKeyIndex);

  Future<NetworkKey?> distributeNetKey(int netKeyIndex);
}

class MeshNetwork implements IMeshNetwork {
  final MethodChannel _methodChannel;

  final String _id;

  MeshNetwork(this._id) : _methodChannel = MethodChannel('$namespace/mesh_network/$_id/methods');

  @override
  Future<List<GroupData>> get groups async {
    final _groups = await _methodChannel.invokeMethod<List>('groups');
    return _groups!.cast<Map>().map((e) => GroupData.fromJson(e.cast<String, dynamic>())).toList();
  }

  @override
  Future<int> get highestAllocatableAddress async =>
      (await _methodChannel.invokeMethod<int>('highestAllocatableAddress'))!;

  @override
  Future<List<ElementData>> elementsForGroup(int groupAddress) async {
    final _elements = await _methodChannel.invokeMethod<List>('getElementsForGroup', {'groupAddress': groupAddress});
    return _elements!.cast<Map>().map((e) => ElementData.fromJson(e.cast<String, dynamic>())).toList();
  }

  @override
  String get id => _id;

  @override
  Future<String> get name async => (await _methodChannel.invokeMethod<String>('getMeshNetworkName'))!;

  @override
  Future<List<ProvisionedMeshNode>> get nodes async {
    final _nodes = await _methodChannel.invokeMethod<List<dynamic>>('nodes');
    return _nodes!.map((e) => ProvisionedMeshNode(e['uuid'])).toList();
  }

  @override
  Future<GroupData?> addGroupWithName(String name) async {
    final result = await _methodChannel.invokeMethod<Map>('addGroupWithName', {'name': name});
    if (result!['successfullyAdded'] == false) {
      return null;
    }
    return GroupData.fromJson((result.cast<String, dynamic>()['group'] as Map).cast<String, dynamic>());
  }

  @override
  Future<void> assignUnicastAddress(int unicastAddress) =>
      _methodChannel.invokeMethod<void>('assignUnicastAddress', {'unicastAddress': unicastAddress});

  @override
  Future<int> nextAvailableUnicastAddress(int elementSize) async =>
      (await _methodChannel.invokeMethod<int>('nextAvailableUnicastAddress', {'elementSize': elementSize}))!;

  @override
  Future<int> nextAvailableUnicastAddressWithMin(int minAddress, int elementSize) async =>
      (await _methodChannel.invokeMethod<int>(
          'nextAvailableUnicastAddressWithMin', {'minAddress': minAddress, 'elementSize': elementSize}))!;

  @override
  Future<bool> removeGroup(int groupAddress) async =>
      (await _methodChannel.invokeMethod<bool>('removeGroup', {'groupAddress': groupAddress}))!;

  @override
  Future<String> selectedProvisionerUuid() async =>
      (await _methodChannel.invokeMethod<String>('selectedProvisionerUuid'))!;

  @override
  String toString() => 'MeshNetwork{$_id}';

  @override
  Future<void> selectProvisioner(int provisionerIndex) =>
      _methodChannel.invokeMethod<void>('selectProvisioner', {'provisionerIndex': provisionerIndex});

  @override
  Future<List<Provisioner>> get provisionerList async {
    var provisioners = <Provisioner>[];
    final result = await _methodChannel.invokeMethod('getProvisionersAsJson');
    var prov = json.decode(result) as List;
    for (final value in prov) {
      provisioners.add(Provisioner.fromJson(value));
    }
    return provisioners;
  }

  @override
  Future<bool> addProvisioner(
      int unicastAddressRange, int groupAddressRange, int sceneAddressRange, int globalTtl) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return (await _methodChannel.invokeMethod<bool>(
        'addProvisioner',
        {
          'unicastAddressRange': unicastAddressRange,
          'groupAddressRange': groupAddressRange,
          'sceneAddressRange': sceneAddressRange,
          'globalTtl': globalTtl,
        },
      ))!;
    } else {
      throw UnsupportedError('Platform "${Platform.operatingSystem}" not supported');
    }
  }

  @override
  Future<bool> updateProvisioner(Provisioner provisioner) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return (await _methodChannel.invokeMethod<bool>(
        'updateProvisioner',
        {
          'provisionerUuid': provisioner.provisionerUuid,
          'provisionerName': provisioner.provisionerName,
          'provisionerAddress': provisioner.provisionerAddress,
          'globalTtl': provisioner.globalTtl,
          'lastSelected': provisioner.lastSelected
        },
      ))!;
    } else {
      throw UnsupportedError('Platform "${Platform.operatingSystem}" not supported');
    }
  }

  @override
  Future<bool> removeProvisioner(String provisionerUUID) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return (await _methodChannel.invokeMethod<bool>('removeProvisioner', {'provisionerUUID': provisionerUUID}))!;
    } else {
      throw UnsupportedError('Platform "${Platform.operatingSystem}" not supported');
    }
  }

  @override
  Future<bool> deleteNode(String uid) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return (await _methodChannel.invokeMethod<bool>('deleteNode', {'uid': uid}))!;
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  @override
  Future<Map> getMeshModelSubscriptions(int elementAddress, int modelIdentifier) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return (await _methodChannel.invokeMethod<Map>(
        'getMeshModelSubscriptions',
        {
          'elementAddress': elementAddress,
          'modelIdentifier': modelIdentifier,
        },
      ))!;
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  @override
  Future<Map> getGroupElementIds(int groupAddress) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return (await _methodChannel.invokeMethod<Map>('getGroupElementIds', {'groupAddress': groupAddress}))!;
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  @override
  Future<ProvisionedMeshNode?> getNode(int address) async {
    if (Platform.isIOS || Platform.isAndroid) {
      final _node = await _methodChannel.invokeMethod<String>('getNode', {'address': address});
      if (_node != null) {
        return ProvisionedMeshNode(_node);
      } else {
        debugPrint('node not found');
        return null;
      }
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  @override
  Future<ProvisionedMeshNode?> getNodeUsingUUID(String uuid) async {
    if (Platform.isIOS || Platform.isAndroid) {
      final _node = await _methodChannel.invokeMethod<String>('getNodeUsingUUID', {'uuid': uuid});
      if (_node != null) {
        return ProvisionedMeshNode(_node);
      } else {
        debugPrint('node not found');
        return null;
      }
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  @override
  Future<NetworkKey> generateNetKey() async {
    if (/* Platform.isIOS ||  */ Platform.isAndroid) {
      final result = await _methodChannel.invokeMethod<Map>('generateNetKey');
      return NetworkKey.fromJson(Map<String, dynamic>.from(result!));
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  @override
  Future<NetworkKey?> getNetKey(int netKeyIndex) async {
    if (/* Platform.isIOS ||  */ Platform.isAndroid) {
      final result = await _methodChannel.invokeMethod<Map>('getNetKey', {'netKeyIndex': netKeyIndex});
      return NetworkKey.fromJson(Map<String, dynamic>.from(result!));
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  @override
  Future<bool?> removeNetKey(int netKeyIndex) async {
    if (/* Platform.isIOS ||  */ Platform.isAndroid) {
      return _methodChannel.invokeMethod<bool>('removeNetKey', {'netKeyIndex': netKeyIndex});
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  @override
  Future<NetworkKey?> distributeNetKey(int netKeyIndex) async {
    if (/* Platform.isIOS ||  */ Platform.isAndroid) {
      final result = await _methodChannel.invokeMethod<Map>('distributeNetKey', {'netKeyIndex': netKeyIndex});
      return NetworkKey.fromJson(Map<String, dynamic>.from(result!));
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }
}
