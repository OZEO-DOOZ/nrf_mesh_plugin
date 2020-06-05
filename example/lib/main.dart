import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion;
  MeshManagerApi _meshManagerApi;
  NordicNrfMesh _nordicNrfMesh;
  MeshNetwork _meshNetwork;

  @override
  void initState() {
    super.initState();
    _nordicNrfMesh = NordicNrfMesh();
  }

  Widget getPlatfromVersion() {
    if (_platformVersion != null) {
      return Text('Run on $_platformVersion');
    } else {
      return RaisedButton(
        child: Text('Get Platform Version'),
        onPressed: () async {
          var version = await _nordicNrfMesh.platformVersion;
          setState(() {
            _platformVersion = version;
          });
        },
      );
    }
  }

  List<Widget> getMeshManagerApiButtons() {
    if (_meshManagerApi == null) {
      return [
        RaisedButton(
          child: Text('Create MeshManagerApi'),
          onPressed: () async {
            var meshManagerApi = await _nordicNrfMesh.createMeshManagerApi();
            setState(() {
              _meshManagerApi = meshManagerApi;
            });
          },
        )
      ];
    } else {
      return [
        RaisedButton(
          child: Text('import MeshNetwork Json'),
          onPressed: () async {
            final filePath = await FilePicker.getFilePath(type: FileType.any);
            if (filePath == null) return;
            final file = await File(filePath);
            if (file == null) return;
            final json = await file.readAsString();
            if (json == null) return;
            var meshNetwork = await _meshManagerApi.importMeshNetworkJson(json);
            setState(() {
              _meshNetwork = meshNetwork;
            });
          },
        ),
        RaisedButton(
          child: Text('Load MeshNetwork'),
          onPressed: () async {
            var meshNetwork = await _meshManagerApi.loadMeshNetwork();
            setState(() {
              _meshNetwork = meshNetwork;
            });
          },
        )
      ];
    }
  }

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
            getPlatfromVersion(),
            Divider(),
            ...getMeshManagerApiButtons(),
            Divider(),
            ...getMeshNetworkButtons()
          ],
        )),
      ),
    );
  }
}
