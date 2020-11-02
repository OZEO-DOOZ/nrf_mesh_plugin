import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/models/group/group.dart';

import 'group.dart';
import 'node.dart';

class MeshNetworkWidget extends StatefulWidget {
  final IMeshNetwork meshNetwork;

  const MeshNetworkWidget({Key key, @required this.meshNetwork}) : super(key: key);

  @override
  _MeshNetworkWidgetState createState() => _MeshNetworkWidgetState();
}

class _MeshNetworkWidgetState extends State<MeshNetworkWidget> {
  List<ProvisionedMeshNode> _nodes = [];
  List<GroupData> _groups = [];

  @override
  void initState() {
    widget.meshNetwork.nodes.then((value) => setState(() => _nodes = value));
    widget.meshNetwork.groups.then((value) => setState(() => _groups = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.meshNetwork == null) {
      return Text('No mesh network');
    }
    return Column(
      children: <Widget>[
        Text('MeshNetwork ID: ${widget.meshNetwork.id}'),
        if (_nodes.isNotEmpty) ...[
          Text('Nodes: '),
          ..._nodes.map((e) => Node(e, widget.meshNetwork, 'node-${_nodes.indexOf(e)}')),
        ],
        if (_groups.isNotEmpty) ...[
          Text('Groups: '),
          ..._groups.map((e) => Group(e, widget.meshNetwork)),
        ]
      ],
    );
  }
}
