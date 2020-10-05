import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGroups extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGroups(this.meshManagerApi) : super();

  @override
  _SendGroupsState createState() => _SendGroupsState();
}

class _SendGroupsState extends State<SendGroups> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Send a groups command'),
      children: <Widget>[
        RaisedButton(
          child: Text('groups'),
          onPressed: () async {
            final status = await widget.meshManagerApi.meshNetwork.groups;
            print(status);
          },
        )
      ],
    );
  }
}
