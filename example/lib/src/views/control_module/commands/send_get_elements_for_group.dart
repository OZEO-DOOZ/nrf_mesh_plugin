import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGetElementsForGroup extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGetElementsForGroup(this.meshManagerApi) : super();

  @override
  _SendGetElementsForGroupState createState() =>
      _SendGetElementsForGroupState();
}

class _SendGetElementsForGroupState extends State<SendGetElementsForGroup> {
  int _id;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Send a get elements for group'),
      children: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: 'id address'),
          onChanged: (text) {
            _id = int.parse(text);
          },
        ),
        RaisedButton(
          child: Text('Send get elements for group'),
          onPressed: () async {
            final status =
                await widget.meshManagerApi.meshNetwork.elementsForGroup(_id);
            print(status);
          },
        )
      ],
    );
  }
}
