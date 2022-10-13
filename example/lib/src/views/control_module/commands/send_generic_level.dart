import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGenericLevel extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGenericLevel({Key? key, required this.meshManagerApi}) : super(key: key);

  @override
  State<SendGenericLevel> createState() => _SendGenericLevelState();
}

class _SendGenericLevelState extends State<SendGenericLevel> {
  int? selectedElementAddress;

  int? selectedLevel;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const ValueKey('module-send-generic-level-form'),
      title: const Text('Send a generic level set'),
      children: <Widget>[
        TextField(
          key: const ValueKey('module-send-generic-level-address'),
          decoration: const InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            selectedElementAddress = int.parse(text);
          },
        ),
        TextField(
          key: const ValueKey('module-send-generic-level-value'),
          decoration: const InputDecoration(hintText: 'Level Value'),
          onChanged: (text) {
            setState(() {
              selectedLevel = int.tryParse(text);
            });
          },
        ),
        TextButton(
          onPressed: selectedLevel != null
              ? () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  debugPrint('send level $selectedLevel to $selectedElementAddress');
                  try {
                    await widget.meshManagerApi
                        .sendGenericLevelSet(selectedElementAddress!, selectedLevel!)
                        .timeout(const Duration(seconds: 40));
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
                  } on TimeoutException catch (_) {
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
                  } on PlatformException catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              : null,
          child: const Text('Send level'),
        )
      ],
    );
  }
}
