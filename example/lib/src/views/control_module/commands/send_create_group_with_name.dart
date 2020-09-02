import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendCreateGroupWithName extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendCreateGroupWithName(this.meshManagerApi) : super();

  @override
  _SendCreateGroupWithNameState createState() => _SendCreateGroupWithNameState();
}

class _SendCreateGroupWithNameState extends State<SendCreateGroupWithName> {
  String _name;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Send a create group with name'),
      children: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: 'name'),
          onChanged: (text) {
            _name = text;
          },
        ),
        RaisedButton(
          child: Text('Send create group'),
          onPressed: () async {
            final status = await widget.meshManagerApi.meshNetwork.addGroupWithName(_name);
            print(status);
          },
        )
      ],
    );
  }
}
