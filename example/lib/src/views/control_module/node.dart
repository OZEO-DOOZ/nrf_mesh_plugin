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
  final ElementData element;

  const Element(this.element) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('address : ${element.address}'),
        Row(
          children: <Widget>[
            Text('Models: '),
            ...element.models.map((e) => Model(e))
          ],
        )
      ],
    );
  }
}

class Model extends StatelessWidget {
  final ModelData model;

  const Model(this.model) : super();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Text(' ${model.modelId} '),
        appKeyBindIcon(),
        Text(', ')
      ],
    );
  }

  bool isAppKeyBound() {
    return model.boundAppKey.isNotEmpty;
  }

  Icon appKeyBindIcon() {
    return isAppKeyBound()
        ? Icon(
            Icons.check,
            size: 15,
            color: Colors.green,
          )
        : Icon(
            Icons.clear,
            size: 15,
            color: Colors.red,
          );
  }
}
