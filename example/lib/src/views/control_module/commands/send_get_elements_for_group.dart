import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGetElementsForGroup extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGetElementsForGroup(this.meshManagerApi) : super();

  @override
  _SendGetElementsForGroupState createState() => _SendGetElementsForGroupState();
}

class _SendGetElementsForGroupState extends State<SendGetElementsForGroup> {
  late int _id;

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
        TextButton(
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            try {
              final result =
                  await widget.meshManagerApi.meshNetwork!.elementsForGroup(_id).timeout(Duration(seconds: 40));
              print(result);
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('OK')));
            } on TimeoutException catch (_) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('Board didn\'t respond')));
            } on PlatformException catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
            } catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: Text('Send get elements for group'),
        )
      ],
    );
  }
}
