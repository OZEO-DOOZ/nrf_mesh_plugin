import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/data/board_data.dart';
import 'package:nordic_nrf_mesh_example/src/global.dart';

import 'commands/send_create_group_with_name.dart';
import 'commands/send_delete_group.dart';
import 'commands/send_get_elements_for_group.dart';
import 'commands/send_groups.dart';
import 'commands/send_config_model_subscription_add.dart';
import 'commands/send_generic_level.dart';
import 'node.dart';

class Module extends StatefulWidget {
  final BluetoothDevice device;
  final MeshManagerApi meshManagerApi;

  const Module({Key key, this.device, this.meshManagerApi}) : super(key: key);

  @override
  _ModuleState createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  bool isLoading = true;
  int selectedElementAddress;
  int selectedLevel;
  ProvisionedMeshNode currentNode;
  final bleMeshManager = BleMeshManager();

  @override
  void initState() {
    super.initState();

    bleMeshManager.callbacks = DoozProvisionedBleMeshManagerCallbacks(widget.meshManagerApi, bleMeshManager);

    _init();
  }

  @override
  void dispose() async {
    super.dispose();
    await bleMeshManager.disconnect();
    await bleMeshManager.callbacks.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: CircularProgressIndicator(),
    );
    if (!isLoading) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Node(currentNode),
          Divider(),
          Text('Commands :'),
          SendGenericLevel(widget.meshManagerApi),
          SendConfigModelSubscriptionAdd(widget.meshManagerApi),
          SendGroups(widget.meshManagerApi),
          SendGetElementsForGroup(widget.meshManagerApi),
          SendCreateGroupWithName(widget.meshManagerApi),
          SendDeleteGroup(widget.meshManagerApi),
        ],
      );
    }
    return Scaffold(
      body: body,
    );
  }

  Future<void> _init() async {
    await bleMeshManager.connect(widget.device);
    final _nodes = await widget.meshManagerApi.meshNetwork.nodes;
    final provisionerUuid = await widget.meshManagerApi.meshNetwork.selectedProvisionerUuid();
    final provisioner = _nodes.firstWhere((element) => element.uuid == provisionerUuid, orElse: () => null);
    if (provisioner == null) {
      print('provisioner is null');
      return;
    }

    currentNode = _nodes.firstWhere((element) => element.uuid != provisionerUuid, orElse: () => null);
    if (currentNode == null) {
      print('node mesh not connected');
      return;
    }
    final elements = await currentNode.elements;
    for (final element in elements) {
      for (final model in element.models) {
        if (model.boundAppKey.isEmpty) {
          if (element == elements.first && model == element.models.first) {
            continue;
          }
          final unicast = await currentNode.unicastAddress;
          print('need to bind app key');
          await widget.meshManagerApi.sendConfigModelAppBind(
            unicast,
            element.address,
            model.modelId,
          );
        }
      }
    }

    final target = 0;
    //  check if the board need to be configured

    int sequenceNumber;
    if (Platform.isIOS) {
      sequenceNumber = await widget.meshManagerApi.getSequenceNumber(await provisioner.unicastAddress);
    } else if (Platform.isAndroid) {
      sequenceNumber = await provisioner.sequenceNumber;
    }

    final getBoardTypeStatus = await widget.meshManagerApi.sendGenericLevelSet(
        await currentNode.unicastAddress, BoardData.configuration(target).toByte(), sequenceNumber);
    print('getBoardTypeStatus $getBoardTypeStatus');
    final boardType = BoardData.decode(getBoardTypeStatus.level);
    if (boardType.payload == 0xA) {
      print('it\'s a Doobl V board');
      print('setup sortie ${target + 1} to be a dimmer');
      if (Platform.isIOS) {
        sequenceNumber = await widget.meshManagerApi.getSequenceNumber(await provisioner.unicastAddress);
      } else if (Platform.isAndroid) {
        sequenceNumber = await provisioner.sequenceNumber;
      }
      final setupDimmerStatus = await widget.meshManagerApi.sendGenericLevelSet(
          await currentNode.unicastAddress, BoardData.lightDimmerOutput(target).toByte(), sequenceNumber);
      final dimmerBoardData = BoardData.decode(setupDimmerStatus.level);
      print(dimmerBoardData);
    }

    setState(() {
      isLoading = false;
    });
  }
}

class DoozProvisionedBleMeshManagerCallbacks extends BleMeshManagerCallbacks {
  final MeshManagerApi meshManagerApi;
  final BleMeshManager bleMeshManager;

  StreamSubscription<BluetoothDevice> onDeviceConnectingSubscription;
  StreamSubscription<BluetoothDevice> onDeviceConnectedSubscription;
  StreamSubscription<BleManagerCallbacksDiscoveredServices> onServicesDiscoveredSubscription;
  StreamSubscription<BluetoothDevice> onDeviceReadySubscription;
  StreamSubscription<BleMeshManagerCallbacksDataReceived> onDataReceivedSubscription;
  StreamSubscription<BleMeshManagerCallbacksDataSent> onDataSentSubscription;
  StreamSubscription<BluetoothDevice> onDeviceDisconnectingSubscription;
  StreamSubscription<BluetoothDevice> onDeviceDisconnectedSubscription;
  StreamSubscription<List<int>> onMeshPduCreatedSubscription;

  DoozProvisionedBleMeshManagerCallbacks(this.meshManagerApi, this.bleMeshManager) {
    onDeviceConnectingSubscription = onDeviceConnecting.listen((event) {
      print('onDeviceConnecting $event');
    });
    onDeviceConnectedSubscription = onDeviceConnected.listen((event) {
      print('onDeviceConnected $event');
    });

    onServicesDiscoveredSubscription = onServicesDiscovered.listen((event) {
      print('onServicesDiscovered');
    });

    onDeviceReadySubscription = onDeviceReady.listen((event) async {
      print('onDeviceReady ${event.id.id}');
    });

    onDataReceivedSubscription = onDataReceived.listen((event) async {
      print('onDataReceived ${event.device.id} ${event.pdu} ${event.mtu}');
      await meshManagerApi.handleNotifications(event.mtu, event.pdu);
    });
    onDataSentSubscription = onDataSent.listen((event) async {
      print('onDataSent ${event.device.id} ${event.pdu} ${event.mtu}');
      await meshManagerApi.handleWriteCallbacks(event.mtu, event.pdu);
    });

    onDeviceDisconnectingSubscription = onDeviceDisconnecting.listen((event) {
      print('onDeviceDisconnecting $event');
    });
    onDeviceDisconnectedSubscription = onDeviceDisconnected.listen((event) {
      print('onDeviceDisconnected $event');
    });

    onMeshPduCreatedSubscription = meshManagerApi.onMeshPduCreated.listen((event) async {
      print('onMeshPduCreated $event');
      await bleMeshManager.sendPdu(event);
    });
  }

  @override
  Future<void> dispose() => Future.wait([
        onDeviceConnectingSubscription.cancel(),
        onDeviceConnectedSubscription.cancel(),
        onServicesDiscoveredSubscription.cancel(),
        onDeviceReadySubscription.cancel(),
        onDataReceivedSubscription.cancel(),
        onDataSentSubscription.cancel(),
        onDeviceDisconnectingSubscription.cancel(),
        onDeviceDisconnectedSubscription.cancel(),
        onMeshPduCreatedSubscription.cancel(),
        super.dispose(),
      ]);

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) => meshManagerApi.setMtu(mtu);
}
