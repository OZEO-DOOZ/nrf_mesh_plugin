import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendConfigModelSubscriptionAdd extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendConfigModelSubscriptionAdd(this.meshManagerApi) : super();

  @override
  _SendConfigModelSubscriptionAddState createState() => _SendConfigModelSubscriptionAddState();
}

class _SendConfigModelSubscriptionAddState extends State<SendConfigModelSubscriptionAdd> {
  int selectedElementAddress;
  int selectedModelType;
  int selectedSubscriptionAddress;
  int selectedAddress;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Send a config model Subscription add'),
      children: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: 'dest Address'),
          onChanged: (text) {
            selectedAddress = int.parse(text);
          },
        ),
        TextField(
          decoration: InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            selectedElementAddress = int.parse(text);
          },
        ),
        TextField(
          decoration: InputDecoration(hintText: 'Model type'),
          onChanged: (text) {
            selectedModelType = int.parse(text);
          },
        ),
        TextField(
          decoration: InputDecoration(hintText: 'subscription address'),
          onChanged: (text) {
            selectedSubscriptionAddress = int.parse(text);
          },
        ),
        RaisedButton(
          child: Text('Send level'),
          onPressed: () async {
            final scaffoldState = Scaffold.of(context);
            try {
              await widget.meshManagerApi
                  .sendConfigModelSubscriptionAdd(
                      selectedElementAddress, selectedSubscriptionAddress, selectedModelType)
                  .timeout(Duration(seconds: 40));
              scaffoldState.showSnackBar(SnackBar(content: Text('OK')));
            } on TimeoutException catch (_) {
              scaffoldState.showSnackBar(SnackBar(content: Text('Board didn\'t respond')));
            } on PlatformException catch (e) {
              scaffoldState.showSnackBar(SnackBar(content: Text(e.message)));
            } catch (e) {
              scaffoldState.showSnackBar(SnackBar(content: Text(e.toString())));
            }
          },
        )
      ],
    );
  }
}
