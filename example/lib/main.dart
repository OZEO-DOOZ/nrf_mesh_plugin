import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final nordicNrfMesh = NordicNrfMesh();
    String platformVersion;
    try {
      platformVersion = await nordicNrfMesh.platformVersion;
      final meshManagerApi = await nordicNrfMesh.createMeshManagerApi();
      final meshNetwork = await meshManagerApi.loadMeshNetwork();
      print(meshNetwork);
      meshManagerApi.onNetworkLoaded.listen(print);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
