import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/data/board_data.dart';
import 'package:nordic_nrf_mesh_example/src/views/control_module/mesh_element.dart';

class Node extends StatefulWidget {
  final String name;
  final ProvisionedMeshNode node;
  final MeshManagerApi meshManagerApi;

  const Node({Key? key, required this.node, required this.meshManagerApi, required this.name}) : super(key: key);

  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> {
  bool isLoading = true;
  late int nodeAddress;
  late List<ElementData> elements;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    nodeAddress = await widget.node.unicastAddress;
    elements = await widget.node.elements;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Text('Configuring...'),
        ],
      ),
    );
    if (!isLoading) {
      body = ListView(
        children: [
          Text('Node $nodeAddress'),
          Text('${widget.node.uuid}'),
          ...[
            Text('Elements :'),
            Column(
              children: <Widget>[
                ...elements.map((element) => MeshElement(element)).toList(),
              ],
            ),
          ],
          Divider(),
          ConfigureOutputAsLightDimmer(
            meshManagerApi: widget.meshManagerApi,
            node: widget.node,
          ),
          ConfigureOuputAsLightOnOff(
            meshManagerApi: widget.meshManagerApi,
            node: widget.node,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: body,
    );
  }
}

class ConfigureOutputAsLightDimmer extends StatelessWidget {
  final MeshManagerApi meshManagerApi;
  final ProvisionedMeshNode node;

  const ConfigureOutputAsLightDimmer({Key? key, required this.meshManagerApi, required this.node}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfigureAs(
      text: 'Configure output as light dimmer',
      onPressed: () async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final target = 0;
        // final provisioner = (await meshManagerApi.meshNetwork.nodes).first;
        try {
          final getBoardTypeStatus = await meshManagerApi
              .sendGenericLevelSet(await node.unicastAddress, BoardData.configuration(target).toByte())
              .timeout(Duration(seconds: 40));
          final boardType = BoardData.decode(getBoardTypeStatus.level);
          if (boardType.payload == 0xA) {
            final setupDimmerStatus = await meshManagerApi
                .sendGenericLevelSet(await node.unicastAddress, BoardData.lightDimmerOutput(target).toByte())
                .timeout(Duration(seconds: 40));
            BoardData.decode(setupDimmerStatus.level);
            scaffoldMessenger.showSnackBar(SnackBar(content: Text('Board successfully configured')));
          } else {
            scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('Board type ${boardType.payload} not supported as dimmer (for now)')));
          }
        } on TimeoutException catch (_) {
          scaffoldMessenger.showSnackBar(SnackBar(content: Text('Board didn\'t respond')));
        }
      },
    );
  }
}

class ConfigureOuputAsLightOnOff extends StatelessWidget {
  final MeshManagerApi meshManagerApi;
  final ProvisionedMeshNode node;

  const ConfigureOuputAsLightOnOff({Key? key, required this.meshManagerApi, required this.node}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfigureAs(
      text: 'Configure output as light On/Off',
      onPressed: () async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final target = 0;
        try {
          final getBoardTypeStatus = await meshManagerApi
              .sendGenericLevelSet(await node.unicastAddress, BoardData.configuration(target).toByte())
              .timeout(Duration(seconds: 40));
          final boardType = BoardData.decode(getBoardTypeStatus.level);
          if (boardType.payload == 0xA) {
            final setupDimmerStatus = await meshManagerApi
                .sendGenericLevelSet(await node.unicastAddress, BoardData.lightOnOffOutput(target).toByte())
                .timeout(Duration(seconds: 40));
            BoardData.decode(setupDimmerStatus.level);
            scaffoldMessenger.showSnackBar(SnackBar(content: Text('Board successfully configured')));
          } else {
            scaffoldMessenger.showSnackBar(
                SnackBar(content: Text('Board type ${boardType.payload} not supported as on/off (for now)')));
          }
        } on TimeoutException catch (_) {
          scaffoldMessenger.showSnackBar(SnackBar(content: Text('Board didn\'t respond')));
        }
      },
    );
  }
}

class ConfigureAs extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ConfigureAs({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
