import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendConfigModelSubscriptionAdd extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendConfigModelSubscriptionAdd(this.meshManagerApi) : super();

  @override
  _SendConfigModelSubscriptionAddState createState() =>
      _SendConfigModelSubscriptionAddState();
}

class _SendConfigModelSubscriptionAddState
    extends State<SendConfigModelSubscriptionAdd> {
  int _id;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Send a add group command'),
      children: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: 'id'),
          onChanged: (text) {
            _id = int.parse(text);
          },
        ),
        RaisedButton(
          child: Text('Send add group'),
          onPressed: () async {
            final status =
                await widget.meshManagerApi.meshNetwork.addGroup(_id);
            print(status);
          },
        )
      ],
    );
  }
}
