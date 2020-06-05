import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/store/mesh_store.dart';

import 'widget/mesh_manager_api_widget.dart';
import 'widget/platform.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MeshStore _meshStore = MeshStore();
  MeshNetwork _meshNetwork;

  List<Widget> getMeshNetworkButtons() {
    if (_meshNetwork == null) {
      return [Text('No mesh network')];
    } else {
      return [Text('Name: ${_meshNetwork.id}')];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            PlatformVersion(),
            Observer(builder: (_) => MeshManagerApiWidget(_meshStore)),
            Divider(),
//            ...getMeshNetworkButtons()
          ],
        )),
      ),
    );
  }
}
