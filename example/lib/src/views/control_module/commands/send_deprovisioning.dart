import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendDeprovisioning extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendDeprovisioning({Key? key, required this.meshManagerApi}) : super(key: key);

  @override
  State<SendDeprovisioning> createState() => _SendDeprovisioningState();
}

class _SendDeprovisioningState extends State<SendDeprovisioning> {
  int? selectedElementAddress;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const ValueKey('module-send-deprovisioning-form'),
      title: const Text('Send a deprovisioning'),
      children: <Widget>[
        TextField(
          key: const ValueKey('module-send-deprovisioning-address'),
          decoration: const InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            setState(() {
              selectedElementAddress = int.tryParse(text);
            });
          },
        ),
        TextButton(
          onPressed: selectedElementAddress != null
              ? () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final node = await widget.meshManagerApi.meshNetwork!.getNode(selectedElementAddress!);
                  final nodes = await widget.meshManagerApi.meshNetwork!.nodes;
                  try {
                    final provisionedNode = nodes.firstWhere((element) => element.uuid == node!.uuid);
                    await widget.meshManagerApi.deprovision(provisionedNode).timeout(const Duration(seconds: 40));
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
                  } on TimeoutException catch (_) {
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Board didn\'t respond')));
                  } on PlatformException catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                  } on StateError catch (_) {
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('No node found with this uuid')));
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              : null,
          child: const Text('Send node reset'),
        )
      ],
    );
  }
}
