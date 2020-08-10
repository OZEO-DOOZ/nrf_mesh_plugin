import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class Module extends StatefulWidget {
  final BluetoothDevice device;
  final MeshManagerApi meshManagerApi;

  const Module({Key key, this.device, this.meshManagerApi}) : super(key: key);

  @override
  _ModuleState createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  bool isLoading = true;
  final bleMeshManager = BleMeshManager();

  @override
  void initState() {
    super.initState();

    bleMeshManager.callbacks = DoozProvisionedBleMeshManagerCallbacks(widget.meshManagerApi);

    _init();
  }

  @override
  void dispose() {
    bleMeshManager.disconnect();
    bleMeshManager.callbacks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: CircularProgressIndicator(),
    );
    if (!isLoading) {
      body = Container();
    }
    return Scaffold(
      body: body,
    );
  }

  Future<void> _init() async {
    await bleMeshManager.connect(widget.device);

    //  TODO: get list of nodes from native directly
    final meshNetworkJson = json.decode(await widget.meshManagerApi.exportMeshNetwork());
    debugPrint(json.encode(meshNetworkJson), wrapWidth: 180);
    final node = meshNetworkJson['nodes'].firstWhere((node) => node['name'] == widget.device.id.id, orElse: () => null);
    if (node == null) {
      print('module not found');
      return;
    }
    debugPrint(json.encode(node), wrapWidth: 180);

    final provisionedMeshNode = ProvisionedMeshNode(node['uuid']);

    //  TODO: get mesh network data to know if we should setup the board
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
  Future<void> dispose() {
    onDeviceConnectingSubscription.cancel();
    onDeviceConnectedSubscription.cancel();
    onServicesDiscoveredSubscription.cancel();
    onDeviceReadySubscription.cancel();
    onDataReceivedSubscription.cancel();
    onDataSentSubscription.cancel();
    onDeviceDisconnectingSubscription.cancel();
    onDeviceDisconnectedSubscription.cancel();
    onMeshPduCreatedSubscription.cancel();
    return super.dispose();
  }

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) => meshManagerApi.setMtu(mtu);
}
