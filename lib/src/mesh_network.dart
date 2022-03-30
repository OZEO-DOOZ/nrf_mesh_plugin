import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/constants.dart';

/// {@template mesh_network}
/// The class defining the API to manage a bluetooth mesh network.
/// {@endtemplate}
abstract class IMeshNetwork {
  /// The id of the network
  String get id;

  /// The name of the network
  Future<String> get name;

  /// The current list of provisioners
  Future<List<Provisioner>> get provisioners;

  /// The current list of nodes (provisioners + provisioned mesh devices)
  Future<List<ProvisionedMeshNode>> get nodes;

  /// The currently defined group(s)
  Future<List<GroupData>> get groups;

  /// The max address that the current selected provisioner can allocate
  Future<int> get highestAllocatableAddress;

  /// Will try to add a new group in the network with the given [name]
  Future<GroupData?> addGroupWithName(String name);

  /// Will check if the given [unicastAddress] is free of use
  Future<void> assignUnicastAddress(int unicastAddress);

  /// Will return the data of elements subscribed to the given [groupAddress]
  Future<List<ElementData>> elementsForGroup(int groupAddress);

  /// Will return the next free unicast address based on the number of elements of a node
  Future<int> nextAvailableUnicastAddress(int elementSize);

  /// Will return the next free unicast address based on the number of elements of a node. The address shall be greater than the given [minAddress]
  Future<int> nextAvailableUnicastAddressWithMin(int minAddress, int elementSize);

  /// Will remove the group with the given [groupAddress]
  Future<bool> removeGroup(int groupAddress);

  /// Will return the UUID of the current selected provisioner
  Future<String> selectedProvisionerUuid();

  /// Will select the provisioner at the given index of the [provisioners] list
  Future<void> selectProvisioner(int provisionerIndex);

  /// Will add a provisioner in the current network using the given ranges and ttl.
  ///
  /// Will return false if the creation is a failure (e.g the unicast address range is incompatible with the current configuration)
  Future<bool> addProvisioner(
    int unicastAddressRange,
    int groupAddressRange,
    int sceneAddressRange,
    int globalTtl, {
    String name,
  });

  /// Will update the given [provisioner]
  Future<bool> updateProvisioner(Provisioner provisioner);

  /// Will remove the provisioner with the given uuid
  Future<bool> removeProvisioner(String provisionerUUID);

  /// Will manually remove a node from the network.
  ///
  /// If you want to deprovision a node, please use the `deprovision` method of [NordicNrfMesh]
  Future<bool> deleteNode(String uid);

  /// Will return the subscribed addresses of the given element and model
  Future<Map> getMeshModelSubscriptions(int elementAddress, int modelIdentifier);

  /// Will return the elements that have subscribed either **Generic Level** models or **Generic ON/OFF** models to the given [groupAddress]
  Future<Map> getGroupElementIds(int groupAddress);

  /// Will return the node corresponding to the given [address]
  Future<ProvisionedMeshNode?> getNode(int address);

  /// Will return the node corresponding to the given [uuid]
  Future<ProvisionedMeshNode?> getNodeUsingUUID(String uuid);

  /// Will return a newly generated Network Key
  Future<NetworkKey> generateNetKey();

  /// Will return the Network Key at the given index
  Future<NetworkKey?> getNetKey(int netKeyIndex);

  /// Will remove the Network Key at the given index
  Future<bool?> removeNetKey(int netKeyIndex);

  /// Will distribute the Network Key at the given index
  Future<NetworkKey?> distributeNetKey(int netKeyIndex);
}

/// {@template mesh_network_impl}
/// The implementation of [IMeshNetwork] used at runtime.
/// {@endtemplate}
class MeshNetwork implements IMeshNetwork {
  /// The [MethodChannel] used to interact with Nordic Semiconductor's API
  final MethodChannel _methodChannel;

  /// The unique id of the currently loaded [MeshNetwork]
  final String _id;

  /// {@macro mesh_network_impl}
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
  Future<List<Provisioner>> get provisioners async {
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
    int unicastAddressRange,
    int groupAddressRange,
    int sceneAddressRange,
    int globalTtl, {
    String name = 'DooZ Mesh Provisioner',
  }) async {
    if (Platform.isIOS || Platform.isAndroid) {
      return (await _methodChannel.invokeMethod<bool>(
        'addProvisioner',
        {
          'name': name,
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
