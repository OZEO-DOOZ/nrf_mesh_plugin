import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

import '../control_module/mesh_element.dart';

class Node extends StatefulWidget {
  final String name;
  final ProvisionedMeshNode node;
  final MeshManagerApi meshManagerApi;

  const Node({Key? key, required this.node, required this.meshManagerApi, required this.name}) : super(key: key);

  @override
  State<Node> createState() => _NodeState();
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
        children: const [
          CircularProgressIndicator(),
          Text('Configuring...'),
        ],
      ),
    );
    if (!isLoading) {
      body = ListView(
        children: [
          Text('Node $nodeAddress'),
          Text(widget.node.uuid),
          ...[
            const Text('Elements :'),
            Column(
              children: <Widget>[
                ...elements.map((element) => MeshElement(element)).toList(),
              ],
            ),
          ],
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
