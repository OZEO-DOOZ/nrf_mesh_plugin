import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class SendGenericLevel extends StatefulWidget {
  final MeshManagerApi meshManagerApi;

  const SendGenericLevel({Key key, this.meshManagerApi}) : super(key: key);

  @override
  _SendGenericLevelState createState() => _SendGenericLevelState();
}

class _SendGenericLevelState extends State<SendGenericLevel> {
  int selectedElementAddress;

  int selectedLevel;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: ValueKey('module-send-generic-level-form'),
      title: Text('Send a generic level set'),
      children: <Widget>[
        TextField(
          key: ValueKey('module-send-generic-level-address'),
          decoration: InputDecoration(hintText: 'Element Address'),
          onChanged: (text) {
            selectedElementAddress = int.parse(text);
          },
        ),
        TextField(
          key: ValueKey('module-send-generic-level-value'),
          decoration: InputDecoration(hintText: 'Level Value'),
          onChanged: (text) {
            setState(() {
              selectedLevel = int.tryParse(text);
            });
          },
        ),
        RaisedButton(
          child: Text('Send level'),
          onPressed: selectedLevel != null
              ? () async {
                  final scaffoldState = Scaffold.of(context);
                  print('send level $selectedLevel to $selectedElementAddress');
                  try {
                    await widget.meshManagerApi
                        .sendGenericLevelSet(selectedElementAddress, selectedLevel)
                        .timeout(Duration(seconds: 40));
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
