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
          child: Text('Load MeshNetwork'),
          onPressed: () async {
            print('waht');
            var meshNetwork = await _meshManagerApi.loadMeshNetwork();
            print('the fuxk)');
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
      [Text('Name: ${_meshNetwork.name}')];
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
