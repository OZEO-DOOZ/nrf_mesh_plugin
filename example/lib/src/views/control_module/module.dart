import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

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
  final bleMeshManager = BleMeshManager();

  bool isLoading = true;
  List<ProvisionedMeshNode> nodes;
  List<String> nodesName = [];

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Text('Connecting ...'),
        ],
      ),
    );
    if (!isLoading) {
      body = ListView(
        children: <Widget>[
          for (var i = 0; i < nodes.length; i++)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Node(
                        meshManagerApi: widget.meshManagerApi,
                        node: nodes[i],
                        name: nodesName[i],
                      );
                    },
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Text(nodesName[i]),
                  ),
                ),
              ),
            ),
          Divider(),
          SendGenericLevel(meshManagerApi: widget.meshManagerApi),
          SendConfigModelSubscriptionAdd(widget.meshManagerApi),
          SendGroups(widget.meshManagerApi),
          SendGetElementsForGroup(widget.meshManagerApi),
          SendCreateGroupWithName(widget.meshManagerApi),
          SendDeleteGroup(widget.meshManagerApi),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Nodes list'),
      ),
      body: body,
    );
  }

  Future<void> _init() async {
    await bleMeshManager.connect(widget.device);
    nodes = (await widget.meshManagerApi.meshNetwork.nodes).skip(1).toList();
    nodesName = await Future.wait(nodes.map((e) => e.name));

    for (final node in nodes) {
      final elements = await node.elements;
      for (final element in elements) {
        for (final model in element.models) {
          if (model.boundAppKey.isEmpty) {
            if (element == elements.first && model == element.models.first) {
              continue;
            }
            final unicast = await node.unicastAddress;
            print('need to bind app key');
            await widget.meshManagerApi.sendConfigModelAppBind(
              unicast,
              element.address,
              model.modelId,
            );
          }
        }
      }
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
