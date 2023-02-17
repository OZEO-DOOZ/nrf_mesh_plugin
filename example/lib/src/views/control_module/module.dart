import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/views/control_module/commands/send_config_model_publication_add.dart';
import 'package:nordic_nrf_mesh_example/src/views/control_module/commands/send_light_hsl.dart';

import 'commands/send_deprovisioning.dart';
import 'commands/send_generic_on_off.dart';
import 'commands/send_config_model_subscription_add.dart';
import 'commands/send_generic_level.dart';
import 'node.dart';

class Module extends StatefulWidget {
  final DiscoveredDevice device;
  final MeshManagerApi meshManagerApi;
  final VoidCallback onDisconnect;

  const Module({
    Key? key,
    required this.device,
    required this.meshManagerApi,
    required this.onDisconnect,
  }) : super(key: key);

  @override
  State<Module> createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  final bleMeshManager = BleMeshManager();

  bool isLoading = true;
  late List<ProvisionedMeshNode> nodes;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _deinit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget layout = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(),
          Text('Connecting ...'),
        ],
      ),
    );
    if (!isLoading) {
      layout = ListView(
        children: <Widget>[
          TextButton(
            onPressed: () {
              _deinit();
              widget.onDisconnect();
            },
            child: const Text('Disconnect from network'),
          ),
          for (var i = 0; i < nodes.length; i++)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Node(
                        meshManagerApi: widget.meshManagerApi,
                        node: nodes[i],
                        name: nodes[i].uuid,
                      );
                    },
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    key: ValueKey('node-$i'),
                    child: Text(nodes[i].uuid),
                  ),
                ),
              ),
            ),
          const Divider(),
          SendGenericLevel(meshManagerApi: widget.meshManagerApi),
          SendGenericOnOff(meshManagerApi: widget.meshManagerApi),
          SendLightHsl(meshManagerApi: widget.meshManagerApi),
          SendConfigModelSubscriptionAdd(widget.meshManagerApi),
          SendConfigModelPublicationAdd(widget.meshManagerApi),
          SendDeprovisioning(meshManagerApi: widget.meshManagerApi),
        ],
      );
    }
    return layout;
  }

  Future<void> _init() async {
    bleMeshManager.callbacks = DoozProvisionedBleMeshManagerCallbacks(widget.meshManagerApi, bleMeshManager);
    await bleMeshManager.connect(widget.device);
    // get nodes (ignore first node which is the default provisioner)
    nodes = (await widget.meshManagerApi.meshNetwork!.nodes).skip(1).toList();
    // will bind app keys (needed to be able to configure node)
    for (final node in nodes) {
      final elements = await node.elements;
      for (final element in elements) {
        for (final model in element.models) {
          if (model.boundAppKey.isEmpty) {
            if (element == elements.first && model == element.models.first) {
              continue;
            }
            final unicast = await node.unicastAddress;
            debugPrint('need to bind app key');
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

  void _deinit() async {
    await bleMeshManager.disconnect();
    await bleMeshManager.callbacks!.dispose();
  }
}

class DoozProvisionedBleMeshManagerCallbacks extends BleMeshManagerCallbacks {
  final MeshManagerApi meshManagerApi;
  final BleMeshManager bleMeshManager;

  late StreamSubscription<ConnectionStateUpdate> onDeviceConnectingSubscription;
  late StreamSubscription<ConnectionStateUpdate> onDeviceConnectedSubscription;
  late StreamSubscription<BleManagerCallbacksDiscoveredServices> onServicesDiscoveredSubscription;
  late StreamSubscription<DiscoveredDevice> onDeviceReadySubscription;
  late StreamSubscription<BleMeshManagerCallbacksDataReceived> onDataReceivedSubscription;
  late StreamSubscription<BleMeshManagerCallbacksDataSent> onDataSentSubscription;
  late StreamSubscription<ConnectionStateUpdate> onDeviceDisconnectingSubscription;
  late StreamSubscription<ConnectionStateUpdate> onDeviceDisconnectedSubscription;
  late StreamSubscription<List<int>> onMeshPduCreatedSubscription;

  DoozProvisionedBleMeshManagerCallbacks(this.meshManagerApi, this.bleMeshManager) {
    onDeviceConnectingSubscription = onDeviceConnecting.listen((event) {
      debugPrint('onDeviceConnecting $event');
    });
    onDeviceConnectedSubscription = onDeviceConnected.listen((event) {
      debugPrint('onDeviceConnected $event');
    });

    onServicesDiscoveredSubscription = onServicesDiscovered.listen((event) {
      debugPrint('onServicesDiscovered');
    });

    onDeviceReadySubscription = onDeviceReady.listen((event) async {
      debugPrint('onDeviceReady ${event.id}');
    });

    onDataReceivedSubscription = onDataReceived.listen((event) async {
      debugPrint('onDataReceived ${event.device.id} ${event.pdu} ${event.mtu}');
      await meshManagerApi.handleNotifications(event.mtu, event.pdu);
    });
    onDataSentSubscription = onDataSent.listen((event) async {
      debugPrint('onDataSent ${event.device.id} ${event.pdu} ${event.mtu}');
      await meshManagerApi.handleWriteCallbacks(event.mtu, event.pdu);
    });

    onDeviceDisconnectingSubscription = onDeviceDisconnecting.listen((event) {
      debugPrint('onDeviceDisconnecting $event');
    });
    onDeviceDisconnectedSubscription = onDeviceDisconnected.listen((event) {
      debugPrint('onDeviceDisconnected $event');
    });

    onMeshPduCreatedSubscription = meshManagerApi.onMeshPduCreated.listen((event) async {
      debugPrint('onMeshPduCreated $event');
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
