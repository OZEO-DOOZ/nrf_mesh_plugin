import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

class Module extends StatefulWidget {
  final BluetoothDevice device;
  final MeshManagerApi meshManagerApi;

  const Module({Key key, this.device, this.meshManagerApi}) : super(key: key);

  @override
  _ModuleState createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  bool isLoading = true;
  final bleMeshManager = BleMeshManager();

  @override
  void initState() {
    super.initState();
    bleMeshManager.connect(widget.device);

    _init();
  }

  @override
  void dispose() {
    bleMeshManager.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: CircularProgressIndicator(),
    );
    if (!isLoading) {
      body = Container();
    }
    return Scaffold(
      body: body,
    );
  }

  Future<void> _init() async {
    debugPrint(await widget.meshManagerApi.exportMeshNetwork(), wrapWidth: 180);
    //  TODO: get mesh network data to know if we should setup the board
  }
}
