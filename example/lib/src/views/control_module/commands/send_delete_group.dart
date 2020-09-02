import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendDeleteGroup extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendDeleteGroup(this.meshManagerApi) : super();

  @override
  _SendDeleteGroupState createState() => _SendDeleteGroupState();
}

class _SendDeleteGroupState extends State<SendDeleteGroup> {
  int _id;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Send a delete group command'),
      children: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: 'id'),
          onChanged: (text) {
            _id = int.parse(text);
          },
        ),
        RaisedButton(
          child: Text('Send delete group'),
          onPressed: () async {
            final status = await widget.meshManagerApi.meshNetwork.removeGroup(_id);
            print(status);
          },
        )
      ],
    );
  }
}
