import 'dart:async';
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
  late IMeshNetwork? _meshNetwork;
  late final StreamSubscription<IMeshNetwork?> onNetworkUpdateSubscription;
  late final StreamSubscription<IMeshNetwork?> onNetworkImportSubscription;
  late final StreamSubscription<IMeshNetwork?> onNetworkLoadingSubscription;

  @override
  void initState() {
    super.initState();
    _meshNetwork = widget.nordicNrfMesh.meshManagerApi.meshNetwork;
    onNetworkUpdateSubscription = widget.nordicNrfMesh.meshManagerApi.onNetworkUpdated.listen((event) {
      setState(() {
        _meshNetwork = event;
      });
    });
    onNetworkImportSubscription = widget.nordicNrfMesh.meshManagerApi.onNetworkImported.listen((event) {
      setState(() {
        _meshNetwork = event;
      });
    });
    onNetworkLoadingSubscription = widget.nordicNrfMesh.meshManagerApi.onNetworkLoaded.listen((event) {
      setState(() {
        _meshNetwork = event;
      });
    });
  }

  @override
  void dispose() {
    onNetworkUpdateSubscription.cancel();
    onNetworkLoadingSubscription.cancel();
    onNetworkImportSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          PlatformVersion(nordicNrfMesh: widget.nordicNrfMesh),
          const Divider(),
          MeshManagerApiWidget(nordicNrfMesh: widget.nordicNrfMesh),
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

class MeshManagerApiWidget extends StatelessWidget {
  final NordicNrfMesh nordicNrfMesh;

  const MeshManagerApiWidget({Key? key, required this.nordicNrfMesh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MeshManagerApi? _meshManagerApi = nordicNrfMesh.meshManagerApi;
    IMeshNetwork? _meshNetwork = _meshManagerApi.meshNetwork;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () async {
            final filePath = await FilePicker.platform.pickFiles(type: FileType.any);
            if (filePath == null) return;
            final file = File(filePath.paths.first!);
            debugPrint('loading and importing json file...');
            final json = await file.readAsString();
            await _meshManagerApi.importMeshNetworkJson(json);
            debugPrint('done !');
          },
          child: const Text('import MeshNetwork Json'),
        ),
        TextButton(
          onPressed: _meshManagerApi.loadMeshNetwork,
          child: const Text('Load MeshNetwork'),
        ),
        TextButton(
          onPressed: _meshNetwork != null
              ? () async {
                  //13 provisioners are maximum with the below given ranges and the default ttl is 5
                  //above that, will throw error
                  final result = await _meshNetwork.addProvisioner(0x0888, 0x02F6, 0x0888, 5);
                  debugPrint('provisioner added : $result');
                }
              : null,
          child: const Text('add provisioner'),
        ),
        TextButton(
          onPressed: _meshNetwork != null
              ? () async {
                  var provs = await _meshNetwork.provisioners;
                  debugPrint('# of provs : ${provs.length}');
                  for (var value in provs) {
                    debugPrint('$value');
                  }
                }
              : null,
          child: const Text('get provisioner list'),
        ),
        TextButton(
          onPressed: _meshNetwork != null
              ? () async {
                  final meshNetworkJson = await _meshManagerApi.exportMeshNetwork();
                  debugPrint(meshNetworkJson);
                }
              : null,
          child: const Text('Export MeshNetwork'),
        ),
        TextButton(
          onPressed: _meshNetwork != null ? _meshManagerApi.resetMeshNetwork : null,
          child: const Text('Reset MeshNetwork'),
        )
      ],
    );
  }
}
