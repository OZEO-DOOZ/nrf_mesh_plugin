import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGenericOnOff extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGenericOnOff({Key? key, required this.meshManagerApi}) : super(key: key);

  @override
  _SendGenericOnOffState createState() => _SendGenericOnOffState();
}

class _SendGenericOnOffState extends State<SendGenericOnOff> {
  int? selectedElementAddress;

  bool? onOff = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: ValueKey('module-send-generic-on-off-form'),
      title: Text('Send a generic On Off set'),
      children: <Widget>[
        TextField(
          key: ValueKey('module-send-generic-on-off-address'),
          decoration: InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            setState(() {
              selectedElementAddress = int.tryParse(text);
            });
          },
        ),
        Checkbox(
          key: ValueKey('module-send-generic-on-off-value'),
          value: onOff,
          onChanged: (value) {
            setState(() {
              onOff = value;
            });
          },
        ),
        TextButton(
          onPressed: selectedElementAddress != null
              ? () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  print('send level $onOff to $selectedElementAddress');
                  final provisionerUuid = await widget.meshManagerApi.meshNetwork!.selectedProvisionerUuid();
                  final nodes = await widget.meshManagerApi.meshNetwork!.nodes;
                  try {
                    final provisionedNode = nodes.firstWhere((element) => element.uuid == provisionerUuid);
                    final sequenceNumber = await widget.meshManagerApi.getSequenceNumber(provisionedNode);
                    await widget.meshManagerApi
                        .sendGenericOnOffSet(selectedElementAddress!, onOff!, sequenceNumber)
                        .timeout(Duration(seconds: 40));
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text('OK')));
                  } on TimeoutException catch (_) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text('Board didn\'t respond')));
                  } on StateError catch (_) {
                    scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('No provisioner found with this uuid : $provisionerUuid')));
                  } on PlatformException catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              : null,
          child: Text('Send on off'),
        )
      ],
    );
  }
}
