import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendConfigModelPublicationAdd extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendConfigModelPublicationAdd(this.meshManagerApi, {Key? key}) : super(key: key);

  @override
  State<SendConfigModelPublicationAdd> createState() => _SendConfigModelPublicationAddState();
}

class _SendConfigModelPublicationAddState extends State<SendConfigModelPublicationAdd> {
  late int selectedElementAddress;
  late int selectedModelId;
  late int selectedSubscriptionAddress;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Send a config model Publication add'),
      children: <Widget>[
        TextField(
          decoration: const InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            selectedElementAddress = int.parse(text);
          },
        ),
        TextField(
          decoration: const InputDecoration(hintText: 'Model id'),
          onChanged: (text) {
            selectedModelId = int.parse(text);
          },
        ),
        TextField(
          decoration: const InputDecoration(hintText: 'publication address'),
          onChanged: (text) {
            selectedSubscriptionAddress = int.parse(text);
          },
        ),
        TextButton(
          onPressed: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            try {
              await widget.meshManagerApi
                  .sendConfigModelPublicationSet(selectedElementAddress, selectedSubscriptionAddress, selectedModelId)
                  .timeout(const Duration(seconds: 40));
              scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
            } on TimeoutException catch (_) {
              scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
            } on PlatformException catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
            } catch (e) {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
          child: const Text('Send config message'),
        )
      ],
    );
  }
}
