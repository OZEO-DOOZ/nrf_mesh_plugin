import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/widgets/mesh_network_widget.dart';

class Home extends StatefulWidget {
  final NordicNrfMesh nordicNrfMesh;

  const Home({Key? key, required this.nordicNrfMesh}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  IMeshNetwork? _meshNetwork;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          PlatformVersion(
            nordicNrfMesh: widget.nordicNrfMesh,
          ),
          const Divider(),
          MeshManagerApiWidget(
            nordicNrfMesh: widget.nordicNrfMesh,
            onNewMeshNetwork: (meshNetwork) {
              setState(() {
                _meshNetwork = meshNetwork;
              });
            },
          ),
          const Divider(),
          if (_meshNetwork != null)
            MeshNetworkWidget(meshNetwork: _meshNetwork!)
          else
            const Text('No meshNetwork loaded'),
        ],
      ),
    );
  }
}

class PlatformVersion extends StatefulWidget {
  const PlatformVersion({Key? key, required this.nordicNrfMesh}) : super(key: key);

  final NordicNrfMesh nordicNrfMesh;
  @override
  _PlatformVersion createState() => _PlatformVersion();
}

class _PlatformVersion extends State<PlatformVersion> {
  String? _platformVersion;

  @override
  Widget build(BuildContext context) {
    if (_platformVersion != null) {
      return Text('Run on $_platformVersion');
    } else {
      return TextButton(
        onPressed: () async {
          var version = await widget.nordicNrfMesh.platformVersion;
          setState(() {
            _platformVersion = version;
          });
        },
        child: const Text('Get Platform Version'),
      );
    }
  }
}

class MeshManagerApiWidget extends StatefulWidget {
  final NordicNrfMesh nordicNrfMesh;
  final ValueChanged<IMeshNetwork> onNewMeshNetwork;

  const MeshManagerApiWidget({Key? key, required this.nordicNrfMesh, required this.onNewMeshNetwork}) : super(key: key);

  @override
  _MeshManagerApiWidgetState createState() => _MeshManagerApiWidgetState();
}

class _MeshManagerApiWidgetState extends State<MeshManagerApiWidget> {
  MeshManagerApi? _meshManagerApi;
  IMeshNetwork? _meshNetwork;

  @override
  void initState() {
    super.initState();
    _meshManagerApi = widget.nordicNrfMesh.meshManagerApi;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () async {
            final filePath = await FilePicker.platform.pickFiles(type: FileType.any);
            if (filePath == null) return;
            final file = File(filePath.paths.first!);
            final json = await file.readAsString();
            _meshNetwork = await _meshManagerApi!.importMeshNetworkJson(json);
            widget.onNewMeshNetwork(_meshNetwork!);
          },
          child: const Text('import MeshNetwork Json'),
        ),
        TextButton(
          onPressed: () async {
            _meshNetwork = await _meshManagerApi!.loadMeshNetwork();

            widget.onNewMeshNetwork(_meshNetwork!);
          },
          child: const Text('Load MeshNetwork'),
        ),
        TextButton(
          onPressed: () async {
            //13 provisioners are maximum with the below given ranges and the default ttl is 5
            //above that, will throw error
            final result = await _meshNetwork!.addProvisioner(0x0888, 0x02F6, 0x0888, 5);
            debugPrint('provisioner added : $result');
          },
          child: const Text('add provisioner'),
        ),
        TextButton(
          onPressed: () async {
            final provisionerList = await _meshNetwork!.provisionerList;
            debugPrint('# of provs : ${provisionerList.length}');
          },
          child: const Text('get provisioner list'),
        ),
        TextButton(
          onPressed: () async {
            var provUUIDs = await _meshNetwork!.provisionerList;
            for (var value in provUUIDs) {
              debugPrint('$value');
            }
          },
          child: const Text('get provisioner list'),
        ),
        TextButton(
          onPressed: _meshNetwork != null
              ? () async {
                  final meshNetworkJson = await _meshManagerApi!.exportMeshNetwork();
                  debugPrint(meshNetworkJson);
                }
              : null,
          child: const Text('Export MeshNetwork'),
        ),
        TextButton(
          onPressed: _meshNetwork != null
              ? () async {
                  try {
                    await _meshManagerApi!.resetMeshNetwork();
                    setState(() {
                      _meshNetwork = null;
                    });
                    widget.onNewMeshNetwork(_meshNetwork!);
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Caught error: $err')));
                  }
                }
              : null,
          child: const Text('Reset MeshNetwork'),
        )
      ],
    );
  }
}
