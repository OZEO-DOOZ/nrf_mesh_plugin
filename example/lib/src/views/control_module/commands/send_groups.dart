import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          child: Text('get groups'),
          onPressed: () async {
            final scaffoldState = Scaffold.of(context);
            try {
              final status = await widget.meshManagerApi.meshNetwork.groups.timeout(Duration(seconds: 40));
              print(status);
              scaffoldState.showSnackBar(SnackBar(content: Text('OK')));
            } on TimeoutException catch (_) {
              scaffoldState.showSnackBar(SnackBar(content: Text('Board didn\'t respond')));
            } on PlatformException catch (e) {
              scaffoldState.showSnackBar(SnackBar(content: Text(e.message)));
            }
          },
        )
      ],
    );
  }
}
