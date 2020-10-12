import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/views/control_module/mesh_element.dart';

class Node extends StatefulWidget {
  final ProvisionedMeshNode node;
  final MeshNetwork meshNetwork;
  const Node(this.node, this.meshNetwork) : super();

  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> {
  String _nodeName = 'reaching...';
  String _nodeAdress = 'reaching...';
  List<ElementData> _elements = [];

  @override
  void initState() {
    super.initState();
    widget.node.name.then((value) => setState(() => _nodeName = value));
    widget.node.unicastAddress
        .then((value) => setState(() => _nodeAdress = value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(_nodeName),
      subtitle: Text(_nodeAdress),
      onExpansionChanged: (isOpen) {
        if (isOpen) {
          print('load elements');
          widget.node.elements
              .then((value) => setState(() => _elements = value));
        }
      },
      children: <Widget>[
        Text('Elements :'),
        Column(
          children: <Widget>[
            ..._elements.map((e) => MeshElement(e)).toList(),
          ],
        ),
      ],
    );
  }
}
