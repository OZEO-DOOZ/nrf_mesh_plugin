import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class Node extends StatefulWidget {
  final ProvisionedMeshNode provisionedMeshNode;

  const Node(this.provisionedMeshNode) : super();

  @override
  _NodeState createState() => _NodeState();
}

class _NodeState extends State<Node> {
  int nodeAddress;
  List elements = [];

  @override
  void initState() {
    super.initState();
    widget.provisionedMeshNode.unicastAddress
        .then((value) => setState(() => nodeAddress = value));
    widget.provisionedMeshNode.elements
        .then((value) => setState(() => elements = value));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Node ${nodeAddress}'),
      subtitle: Text('${widget.provisionedMeshNode.uuid}'),
      children: <Widget>[
        Text('Elements :'),
        Column(
          children: <Widget>[
            ...elements.map((element) => Element(element)).toList(),
          ],
        ),
      ],
    );
  }
}

class Element extends StatelessWidget {
  final element;

  const Element(this.element) : super();

  @override
  Widget build(BuildContext context) {
    return Text('$element');
  }
}
