import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/models/group/group.dart';
import 'package:nordic_nrf_mesh_example/src/views/control_module/node.dart';

import 'group.dart';

class MeshNetworkWidget extends StatefulWidget {
  final MeshNetwork meshNetwork;

  const MeshNetworkWidget({Key key, @required this.meshNetwork})
      : super(key: key);

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
        Text('Nodes: '),
        ..._nodes.map((e) => Node(e)),
        if (_groups.isNotEmpty) ...[
          Text('Groups: '),
          ..._groups.map((e) => Group(e, widget.meshNetwork)),
        ]
      ],
    );
  }
}
