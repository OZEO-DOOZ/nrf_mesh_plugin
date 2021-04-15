import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendDeprovisioning extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendDeprovisioning({Key key, this.meshManagerApi}) : super(key: key);

  @override
  _SendDeprovisioningState createState() => _SendDeprovisioningState();
}

class _SendDeprovisioningState extends State<SendDeprovisioning> {
  int selectedElementAddress;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: ValueKey('module-send-deprovisioning-form'),
      title: Text('Send a deprovisioning'),
      children: <Widget>[
        TextField(
          key: ValueKey('module-send-deprovisioning-address'),
          decoration: InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            setState(() {
              selectedElementAddress = int.tryParse(text);
            });
          },
        ),
        RaisedButton(
          child: Text('Send on off'),
          onPressed: selectedElementAddress != null
              ? () async {
                  final scaffoldState = Scaffold.of(context);
                  final node = await widget.meshManagerApi.meshNetwork.getNode(selectedElementAddress);
                  final nodes = await widget.meshManagerApi.meshNetwork.nodes;

                  final provisionedNode = nodes.firstWhere((element) => element.uuid == node.uuid, orElse: () => null);
                  try {
                    await widget.meshManagerApi.deprovision(provisionedNode).timeout(Duration(seconds: 40));
                    scaffoldState.showSnackBar(SnackBar(content: Text('OK')));
                  } on TimeoutException catch (_) {
                    scaffoldState.showSnackBar(SnackBar(content: Text('Board didn\'t respond')));
                  } on PlatformException catch (e) {
                    scaffoldState.showSnackBar(SnackBar(content: Text(e.message)));
                  } catch (e) {
                    scaffoldState.showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              : null,
        )
      ],
    );
  }
}
