import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/views/control_module/mesh_element.dart';

class Node extends StatefulWidget {
  final ProvisionedMeshNode node;
  final IMeshNetwork meshNetwork;
  final String testKey; // For flutter driver tests
  const Node(this.node, this.meshNetwork, this.testKey, {Key? key}) : super(key: key);

  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> {
  String _nodeUuid = 'reaching...';
  String _nodeAdress = 'reaching...';
  List<ElementData> _elements = [];

  @override
  void initState() {
    super.initState();
    _nodeUuid = widget.node.uuid;
    widget.node.unicastAddress.then((value) => setState(() => _nodeAdress = value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: Key(widget.testKey),
      title: Text(_nodeUuid),
      subtitle: Text(_nodeAdress),
      onExpansionChanged: (isOpen) {
        if (isOpen) {
          debugPrint('load elements');
          widget.node.elements.then((value) => setState(() => _elements = value));
        }
      },
      children: <Widget>[
        const Text('Elements :'),
        Column(
          children: <Widget>[
            ..._elements.map((e) => MeshElement(e)).toList(),
          ],
        ),
      ],
    );
  }
}
