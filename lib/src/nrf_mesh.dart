import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/mesh_manager_api.dart';

class NordicNrfMesh {
  final _methodChannel = const MethodChannel('$namespace/methods');

  Future<MeshManagerApi> _meshManagerApi;

  NordicNrfMesh();

  Future<String> get platformVersion async {
    final version = await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<MeshManagerApi> get meshManagerApi => _meshManagerApi ??= _createMeshManagerApi();

  Future<MeshManagerApi> _createMeshManagerApi() async {
    await _methodChannel.invokeMethod('createMeshManagerApi');
    return MeshManagerApi();
  }
}
