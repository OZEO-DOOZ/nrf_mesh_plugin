import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGroups extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGroups(this.meshManagerApi, {Key? key}) : super(key: key);

  @override
  _SendGroupsState createState() => _SendGroupsState();
}

class _SendGroupsState extends State<SendGroups> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Send a groups command'),
      children: <Widget>[
        TextButton(
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            try {
              final status = await widget.meshManagerApi.meshNetwork!.groups.timeout(const Duration(seconds: 40));
              debugPrint('$status');
              scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
            } on TimeoutException catch (_) {
              scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
            } on PlatformException catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
            } catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: const Text('get groups'),
        )
      ],
    );
  }
}
