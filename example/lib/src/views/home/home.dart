import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh_example/src/widgets/mesh_network_widget.dart';


class Home extends StatefulWidget {
  final NordicNrfMesh nordicNrfMesh;

  const Home({Key? key, required this.nordicNrfMesh}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late IMeshNetwork? _meshNetwork;
  late final MeshManagerApi _meshManagerApi;
  late final StreamSubscription<IMeshNetwork?> onNetworkUpdateSubscription;
  late final StreamSubscription<IMeshNetwork?> onNetworkImportSubscription;
  late final StreamSubscription<IMeshNetwork?> onNetworkLoadingSubscription;

  @override
  void initState() {
    super.initState();
    _meshManagerApi = widget.nordicNrfMesh.meshManagerApi;
    _meshNetwork = _meshManagerApi.meshNetwork;
    onNetworkUpdateSubscription = _meshManagerApi.onNetworkUpdated.listen((event) {
      setState(() {
        _meshNetwork = event;
      });
    });
    onNetworkImportSubscription = _meshManagerApi.onNetworkImported.listen((event) {
      setState(() {
        _meshNetwork = event;
      });
    });
    onNetworkLoadingSubscription = _meshManagerApi.onNetworkLoaded.listen((event) {
      setState(() {
        _meshNetwork = event;
      });
    });

    //
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
          ExpansionTile(
            title: const Text('Mesh network database'),
            expandedAlignment: Alignment.topLeft,
            children: [MeshNetworkDatabaseWidget(nordicNrfMesh: widget.nordicNrfMesh)],
          ),
          ExpansionTile(
            title: const Text('Mesh network manager'),
            expandedAlignment: Alignment.topLeft,
            children: [MeshNetworkManagerWidget(nordicNrfMesh: widget.nordicNrfMesh)],
          ),
          const Divider(),
          if (_meshNetwork != null)
            MeshNetworkDataWidget(meshNetwork: _meshNetwork!)
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
  State<PlatformVersion> createState() => _PlatformVersion();
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

/// A [Widget] to interact with network database.
///
/// User may either :
///   - import a mesh network using the given JSON scheme
///   - export a mesh network to get the associated JSON String
///   - load a mesh network from the local database
///   - reset a mesh network
class MeshNetworkDatabaseWidget extends StatelessWidget {
  final NordicNrfMesh nordicNrfMesh;

  const MeshNetworkDatabaseWidget({Key? key, required this.nordicNrfMesh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MeshManagerApi? meshManagerApi = nordicNrfMesh.meshManagerApi;
    IMeshNetwork? meshNetwork = meshManagerApi.meshNetwork;
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
            await meshManagerApi.importMeshNetworkJson(json);
            debugPrint('done !');
          },
          child: const Text('Import MeshNetwork (JSON)'),
        ),
        TextButton(
          onPressed: meshManagerApi.loadMeshNetwork,
          child: const Text('Load MeshNetwork'),
        ),
        TextButton(
          onPressed: meshNetwork != null
              ? () async {
                  final meshNetworkJson = await meshManagerApi.exportMeshNetwork();
                  debugPrint(meshNetworkJson);
                  Uint8List data = Uint8List.fromList(meshNetworkJson!.codeUnits);
                  MimeType type = MimeType.OTHER;
                  String path = await FileSaver.instance.saveAs("nRF_MeshNetwork", data, "json", type);
                  debugPrint(path);
                  debugPrint("Downloading");
                  try {
                    debugPrint("Download Completed.");
                  } catch (e) {
                    debugPrint("Download Failed.\n\n$e");
                  }
                }
              : null,
          child: const Text('Export MeshNetwork'),
        ),
        TextButton(
          onPressed: meshNetwork != null ? meshManagerApi.resetMeshNetwork : null,
          child: const Text('Reset MeshNetwork'),
        ),
      ],
    );
  }
}

/// A [Widget] to alter network's data without the need of an open connection.
/// _(Manage provisioners, groups, etc.)_
class MeshNetworkManagerWidget extends StatelessWidget {
  final NordicNrfMesh nordicNrfMesh;

  const MeshNetworkManagerWidget({Key? key, required this.nordicNrfMesh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MeshManagerApi? meshManagerApi = nordicNrfMesh.meshManagerApi;
    IMeshNetwork? meshNetwork = meshManagerApi.meshNetwork;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: meshNetwork != null
              ? () async {
                  //13 provisioners are maximum with the below given ranges and the default ttl is 5
                  //above that, will throw error
                  final result = await meshNetwork.addProvisioner(0x0888, 0x02F6, 0x0888, 5);
                  debugPrint('provisioner added : $result');
                }
              : null,
          child: const Text('add provisioner'),
        ),
        TextButton(
          onPressed: meshNetwork != null
              ? () async {
                  var provs = await meshNetwork.provisioners;
                  debugPrint('# of provs : ${provs.length}');
                  for (var value in provs) {
                    debugPrint('$value');
                  }
                }
              : null,
          child: const Text('get provisioner list'),
        ),
        TextButton(
          onPressed: meshNetwork != null
              ? () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final groupName = await showDialog<String>(
                      context: context,
                      builder: (c) {
                        String? groupName;
                        return Dialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  TextField(
                                    decoration: const InputDecoration(labelText: 'Group name'),
                                    onChanged: (text) => groupName = text,
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(c, groupName),
                                    child: const Text('OK'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                  if (groupName != null && groupName.isNotEmpty) {
                    try {
                      await meshManagerApi.meshNetwork!.addGroupWithName(groupName);
                      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
                    } on PlatformException catch (e) {
                      scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  } else {
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('No name given, aborting')));
                  }
                }
              : null,
          child: const Text('Create group with name'),
        ),
        TextButton(
          onPressed: meshNetwork != null
              ? () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final groupAdr = await showDialog<String>(
                      context: context,
                      builder: (c) {
                        String? groupAdr;
                        return Dialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  TextField(
                                    decoration: const InputDecoration(labelText: 'Group address'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (text) => groupAdr = text,
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(c, groupAdr),
                                    child: const Text('OK'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                  if (groupAdr != null && groupAdr.isNotEmpty) {
                    try {
                      await meshManagerApi.meshNetwork!.removeGroup(int.parse(groupAdr));
                      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
                    } on PlatformException catch (e) {
                      scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  } else {
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('No address given, aborting')));
                  }
                }
              : null,
          child: const Text('Delete group'),
        ),
        TextButton(
          onPressed: meshNetwork != null
              ? () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final groupAdr = await showDialog<String>(
                      context: context,
                      builder: (c) {
                        String? groupAdr;
                        return Dialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  TextField(
                                    decoration: const InputDecoration(labelText: 'Group address'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (text) => groupAdr = text,
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(c, groupAdr),
                                    child: const Text('OK'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                  if (groupAdr != null && groupAdr.isNotEmpty) {
                    try {
                      final subs = await meshManagerApi.meshNetwork!.elementsForGroup(int.parse(groupAdr));
                      debugPrint('$subs');
                      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('OK')));
                    } on PlatformException catch (e) {
                      scaffoldMessenger.showSnackBar(SnackBar(content: Text('${e.message}')));
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  } else {
                    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('No address given, aborting')));
                  }
                }
              : null,
          child: const Text('Get group elements'),
        ),
      ],
    );
  }
}
