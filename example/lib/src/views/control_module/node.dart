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

  const Node({Key key, this.node, this.meshManagerApi, this.name}) : super(key: key);

  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> {
  bool isLoading = true;
  int nodeAddress;
  List<ElementData> elements;

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
          Text('Node ${nodeAddress}'),
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
          ConfigureAsLightDimmer(
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

class ConfigureAsLightDimmer extends StatelessWidget {
  final MeshManagerApi meshManagerApi;
  final ProvisionedMeshNode node;

  const ConfigureAsLightDimmer({Key key, this.meshManagerApi, this.node}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfigureAs(
      text: 'Configure as light dimmer',
      onPressed: () async {
        final scaffoldState = Scaffold.of(context);
        final target = 0;
        final provisioner = (await meshManagerApi.meshNetwork.nodes).first;
        var sequenceNumber = await meshManagerApi.getSequenceNumber(provisioner);
        try {
          final getBoardTypeStatus = await meshManagerApi
              .sendGenericLevelSet(await node.unicastAddress, BoardData.configuration(target).toByte(), sequenceNumber)
              .timeout(Duration(seconds: 40));
          final boardType = BoardData.decode(getBoardTypeStatus.level);
          if (boardType.payload == 0xA) {
            sequenceNumber = await meshManagerApi.getSequenceNumber(provisioner);
            final setupDimmerStatus = await meshManagerApi
                .sendGenericLevelSet(
                    await node.unicastAddress, BoardData.lightDimmerOutput(target).toByte(), sequenceNumber)
                .timeout(Duration(seconds: 40));
            BoardData.decode(setupDimmerStatus.level);
            scaffoldState.showSnackBar(SnackBar(content: Text('Board successfully configured')));
          } else {
            scaffoldState.showSnackBar(
                SnackBar(content: Text('Board type ${boardType.payload} not supported as dimmer (for now)')));
          }
        } on TimeoutException catch (_) {
          scaffoldState.showSnackBar(SnackBar(content: Text('Board didn\'t respond')));
        }
      },
    );
  }
}

class ConfigureAs extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ConfigureAs({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: RaisedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
