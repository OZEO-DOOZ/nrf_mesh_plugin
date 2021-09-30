import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGetElementsForGroup extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGetElementsForGroup(this.meshManagerApi, {Key? key}) : super(key: key);

  @override
  _SendGetElementsForGroupState createState() => _SendGetElementsForGroupState();
}

class _SendGetElementsForGroupState extends State<SendGetElementsForGroup> {
  late int _id;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Send a get elements for group'),
      children: <Widget>[
        TextField(
          decoration: const InputDecoration(hintText: 'id address'),
          onChanged: (text) {
            _id = int.parse(text);
          },
        ),
        TextButton(
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            try {
              final result =
                  await widget.meshManagerApi.meshNetwork!.elementsForGroup(_id).timeout(const Duration(seconds: 40));
              debugPrint('$result');
              scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
            } on TimeoutException catch (_) {
              scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
            } on PlatformException catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
            } catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: const Text('Send get elements for group'),
        )
      ],
    );
  }
}
