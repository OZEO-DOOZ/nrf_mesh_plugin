import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class Home extends StatefulWidget {
  final NordicNrfMesh nordicNrfMesh;

  const Home({Key key, @required this.nordicNrfMesh}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MeshNetwork _meshNetwork;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          PlatformVersion(
            nordicNrfMesh: widget.nordicNrfMesh,
          ),
          Divider(),
          MeshManagerApiWidget(
            nordicNrfMesh: widget.nordicNrfMesh,
            onNewMeshNetwork: (meshNetwork) {
              setState(() {
                _meshNetwork = meshNetwork;
              });
            },
          ),
          Divider(),
          if (_meshNetwork != null)
            MeshNetworkWidget(
              meshNetwork: _meshNetwork,
            ),
        ],
      ),
    );
  }
}

class PlatformVersion extends StatefulWidget {
  const PlatformVersion({Key key, this.nordicNrfMesh}) : super(key: key);

  final NordicNrfMesh nordicNrfMesh;
  @override
  _PlatformVersion createState() => _PlatformVersion();
}

class _PlatformVersion extends State<PlatformVersion> {
  String _platformVersion;

  @override
  Widget build(BuildContext context) {
    if (_platformVersion != null) {
      return Text('Run on $_platformVersion');
    } else {
      return RaisedButton(
        child: Text('Get Platform Version'),
        onPressed: () async {
          var version = await widget.nordicNrfMesh.platformVersion;
          setState(() {
            _platformVersion = version;
          });
        },
      );
    }
  }
}

class MeshManagerApiWidget extends StatefulWidget {
  final NordicNrfMesh nordicNrfMesh;
  final ValueChanged<MeshNetwork> onNewMeshNetwork;

  const MeshManagerApiWidget({Key key, @required this.nordicNrfMesh, @required this.onNewMeshNetwork})
      : super(key: key);

  @override
  _MeshManagerApiWidgetState createState() => _MeshManagerApiWidgetState();
}

class _MeshManagerApiWidgetState extends State<MeshManagerApiWidget> {
  MeshManagerApi _meshManagerApi;
  MeshNetwork _meshNetwork;

  @override
  void initState() {
    super.initState();
    widget.nordicNrfMesh.meshManagerApi.then((value) => setState(() => _meshManagerApi = value));
  }

  @override
  Widget build(BuildContext context) {
    if (_meshManagerApi == null) {
      return CircularProgressIndicator();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RaisedButton(
          child: Text('import MeshNetwork Json'),
          onPressed: () async {
            final filePath = await FilePicker.getFilePath(type: FileType.any);
            if (filePath == null) return;
            final file = await File(filePath);
            if (file == null) return;
            final json = await file.readAsString();
            if (json == null) return;
            _meshNetwork = await _meshManagerApi.importMeshNetworkJson(json);
            widget.onNewMeshNetwork(_meshNetwork);
          },
        ),
        RaisedButton(
          child: Text('Load MeshNetwork'),
          onPressed: () async {
            _meshNetwork = await _meshManagerApi.loadMeshNetwork();
            widget.onNewMeshNetwork(_meshNetwork);
          },
        ),
        RaisedButton(
          child: Text('Export MeshNetwork'),
          onPressed: _meshNetwork != null
              ? () async {
                  final meshNetworkJson = await _meshManagerApi.exportMeshNetwork();
                  debugPrint(meshNetworkJson);
                }
              : null,
        ),
        RaisedButton(
          child: Text('Reset MeshNetwork'),
          onPressed: _meshNetwork != null
              ? () async {
                  await _meshManagerApi.resetMeshNetwork();
                  setState(() {
                    _meshNetwork = null;
                  });
                  widget.onNewMeshNetwork(_meshNetwork);
                }
              : null,
        )
      ],
    );
  }
}

class MeshNetworkWidget extends StatefulWidget {
  final MeshNetwork meshNetwork;

  const MeshNetworkWidget({Key key, @required this.meshNetwork}) : super(key: key);

  @override
  _MeshNetworkWidgetState createState() => _MeshNetworkWidgetState();
}

class _MeshNetworkWidgetState extends State<MeshNetworkWidget> {
  @override
  void initState() {
    super.initState();

    widget.meshNetwork.nodes.then((nodes) async {
      for (final node in nodes) {
        print('node uuid : ${node.uuid}, elements: ${await node.elements}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.meshNetwork == null) {
      return Text('No mesh network');
    }
    return Text('MeshNetwork ID: ${widget.meshNetwork.id}');
  }
}
