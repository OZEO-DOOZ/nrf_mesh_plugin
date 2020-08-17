import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

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
  List<ProvisionedMeshNode> nodes = [];
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
          ...nodes.map((node) => Node(node)).toList(),
          Divider(),
          Text('Send a generic level set'),
          TextField(
            decoration: InputDecoration(hintText: 'Element Address'),
            onChanged: (text) {
              selectedElementAddress = int.parse(text);
            },
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Level Value'),
            onChanged: (text) {
              selectedLevel = int.parse(text);
            },
          ),
          RaisedButton(
            child: Text('Send level'),
            onPressed: () async {
              print('send level $selectedLevel to $selectedElementAddress');
              final provisionerUuid = await widget.meshManagerApi.meshNetwork.selectedProvisionerUuid();
              final nodes = await widget.meshManagerApi.meshNetwork.nodes;

              final provisionedNode =
                  nodes.firstWhere((element) => element.uuid == provisionerUuid, orElse: () => null);
              final provisionerAddress = await provisionedNode.unicastAddress;
              final status = await widget.meshManagerApi
                  .sendGenericLevelSet(selectedElementAddress, selectedLevel, provisionerAddress);
              print(status);
            },
          )
        ],
      );
    }
    return Scaffold(
      body: body,
    );
  }

  Future<void> _init() async {
    await bleMeshManager.connect(widget.device);

    setState(() {
      isLoading = false;
    });

    final _nodes = await widget.meshManagerApi.meshNetwork.nodes;

    setState(() {
      nodes = _nodes;
    });
//    final provisionedMeshNode = ProvisionedMeshNode(node['uuid']);

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

  StreamSubscription<GenericLevelStatusData> onGenericLevelStatusSubscription;
  StreamSubscription<GenericOnOffStatusData> onGenericOnOffStatusSubscription;

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
        onGenericLevelStatusSubscription.cancel(),
        super.dispose(),
      ]);

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) => meshManagerApi.setMtu(mtu);
}
