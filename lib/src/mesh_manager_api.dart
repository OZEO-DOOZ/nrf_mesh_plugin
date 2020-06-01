import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/mesh_network.dart';

class MeshManagerApi {
  final _methodChannel =
      const MethodChannel('$namespace/mesh_manager_api/methods');
  final _eventChannel =
      const EventChannel('$namespace/mesh_manager_api/events');

  final _onNetworkLoaded = StreamController<MeshNetwork>.broadcast();
  final _onNetworkImported = StreamController<MeshNetwork>.broadcast();
  final _onNetworkUpdated = StreamController<MeshNetwork>.broadcast();

  final _onNetworkLoadFailed = StreamController<String>.broadcast();
  final _onNetworkImportFailed = StreamController<String>.broadcast();

  MeshNetwork _lastMeshNetwork;

  MeshManagerApi() {
    _eventChannel.receiveBroadcastStream().cast<Map>().listen((event) {
      switch (event['eventName']) {
        case 'onNetworkLoaded':
          _lastMeshNetwork = MeshNetwork(event['id'], event['meshName']);
          _onNetworkLoaded.add(_lastMeshNetwork);
          break;
        case 'onNetworkImported':
          _lastMeshNetwork = MeshNetwork(event['id'], event['meshName']);
          _onNetworkImported.add(_lastMeshNetwork);
          break;
        case 'onNetworkUpdated':
          _lastMeshNetwork = MeshNetwork(event['id'], event['meshName']);
          _onNetworkUpdated.add(_lastMeshNetwork);
          break;
        case 'onNetworkLoadFailed':
          _onNetworkLoadFailed.add(event['error']);
          break;
        case 'onNetworkImportFailed':
          _onNetworkImportFailed.add(event['error']);
          break;
      }
    });
  }

  Stream<MeshNetwork> get onNetworkLoaded => _onNetworkLoaded.stream;

  Stream<MeshNetwork> get onNetworkImported => _onNetworkImported.stream;

  Stream<MeshNetwork> get onNetworkUpdated => _onNetworkUpdated.stream;

  Stream<String> get onNetworkLoadFailed => _onNetworkLoadFailed.stream;

  Stream<String> get onNetworkImportFailed => _onNetworkImportFailed.stream;

  MeshNetwork get meshNetwork => _lastMeshNetwork;

  Future<void> dispose() => Future.wait([
        _onNetworkLoaded.close(),
        _onNetworkImported.close(),
        _onNetworkUpdated.close(),
        _onNetworkLoadFailed.close(),
        _onNetworkImportFailed.close(),
      ]);

  Future<MeshNetwork> loadMeshNetwork() async {
    final future = _onNetworkLoaded.stream.first;
    await _methodChannel.invokeMethod('loadMeshNetwork');
    return future;
  }

  Future<MeshNetwork> importMeshNetworkJson(String json) async {
    final future = _onNetworkImported.stream.first;
    await _methodChannel.invokeMethod('importMeshNetworkJson');
    return future;
  }

  Future<String> exportMeshNetwork() =>
      _methodChannel.invokeMethod('exportMeshNetwork');
}
