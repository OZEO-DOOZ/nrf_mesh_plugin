import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendCreateGroupWithName extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendCreateGroupWithName(this.meshManagerApi) : super();

  @override
  _SendCreateGroupWithNameState createState() => _SendCreateGroupWithNameState();
}

class _SendCreateGroupWithNameState extends State<SendCreateGroupWithName> {
  late String _name;

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
        TextButton(
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            try {
              await widget.meshManagerApi.meshNetwork!.addGroupWithName(_name).timeout(Duration(seconds: 40));
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('OK')));
            } on TimeoutException catch (_) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('Board didn\'t respond')));
            } on PlatformException catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
            } catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: Text('Send create group'),
        )
      ],
    );
  }
}
