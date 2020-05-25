import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/mesh_manager_api.dart';

class NordicNrfMesh {
  final _methodChannel = const MethodChannel('$namespace/methods');

  NordicNrfMesh();

  Future<String> get platformVersion async {
    final String version =
        await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<MeshManagerApi> createMeshManagerApi() async {
    await _methodChannel.invokeMethod('createMeshManagerApi');
    return MeshManagerApi();
  }
}
