import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendDeleteGroup extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendDeleteGroup(this.meshManagerApi, {Key? key}) : super(key: key);

  @override
  _SendDeleteGroupState createState() => _SendDeleteGroupState();
}

class _SendDeleteGroupState extends State<SendDeleteGroup> {
  int? _id;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Send a delete group command'),
      children: <Widget>[
        TextField(
          decoration: const InputDecoration(hintText: 'id'),
          onChanged: (text) {
            _id = int.tryParse(text);
          },
        ),
        TextButton(
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            try {
              await widget.meshManagerApi.meshNetwork!.removeGroup(_id!).timeout(const Duration(seconds: 40));
              scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
            } on TimeoutException catch (_) {
              scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
            } on PlatformException catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
            } catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: const Text('Send delete group'),
        )
      ],
    );
  }
}
