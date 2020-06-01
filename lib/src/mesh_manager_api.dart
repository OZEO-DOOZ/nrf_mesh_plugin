import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/mesh_network.dart';
import 'package:nordic_nrf_mesh/src/models/network_loaded/mesh_network_event.dart';

class MeshManagerApi {
  final _methodChannel =
      const MethodChannel('$namespace/mesh_manager_api/methods');
  final _eventChannel =
      const EventChannel('$namespace/mesh_manager_api/events');

  final _onNetworkLoadedStreamController =
      StreamController<MeshNetwork>.broadcast();
  final _onNetworkImported = StreamController<MeshNetwork>.broadcast();
  final _onNetworkUpdated = StreamController<MeshNetwork>.broadcast();

  final _onNetworkLoadFailed =
      StreamController<MeshNetworkEventError>.broadcast();
  final _onNetworkImportFailed =
      StreamController<MeshNetworkEventError>.broadcast();

  StreamSubscription<MeshNetwork> _onMeshNetworkLoadedSubscription;
  StreamSubscription<MeshNetwork> _onMeshNetworkImportedSubscription;
  StreamSubscription<MeshNetwork> _onMeshNetworkUpdatedSubscription;

  StreamSubscription<MeshNetworkEventError>
      _onMeshNetworkLoadFailedSubscription;
  StreamSubscription<MeshNetworkEventError>
      _onMeshNetworkImportFaildSubscription;

  MeshNetwork _lastMeshNetwork;

  MeshManagerApi() {
    _onMeshNetworkLoadedSubscription =
        _streamOfMeshNetworkForSuccessEvent(MeshNetworkEventType.loaded)
            .listen(_onNetworkLoadedStreamController.add);
    _onMeshNetworkImportedSubscription =
        _streamOfMeshNetworkForSuccessEvent(MeshNetworkEventType.imported)
            .listen(_onNetworkImported.add);
    _onMeshNetworkUpdatedSubscription =
        _streamOfMeshNetworkForSuccessEvent(MeshNetworkEventType.updated)
            .listen(_onNetworkUpdated.add);

    _onMeshNetworkLoadFailedSubscription =
        _streamOfMeshNetworkForErrorEvent(MeshNetworkEventType.loadFailed)
            .listen(_onNetworkLoadFailed.add);
    _onMeshNetworkImportFaildSubscription =
        _streamOfMeshNetworkForErrorEvent(MeshNetworkEventType.importFailed)
            .listen(_onNetworkImportFailed.add);
  }

  Stream<MeshNetwork> get onNetworkLoaded =>
      _onNetworkLoadedStreamController.stream;

  Stream<MeshNetwork> get onNetworkImported => _onNetworkImported.stream;

  Stream<MeshNetwork> get onNetworkUpdated => _onNetworkUpdated.stream;

  Stream<MeshNetworkEventError> get onNetworkLoadFailed =>
      _onNetworkLoadFailed.stream;

  Stream<MeshNetworkEventError> get onNetworkImportFailed =>
      _onNetworkImportFailed.stream;

  MeshNetwork get meshNetwork => _lastMeshNetwork;

  Future<void> dispose() => Future.wait([
        _onMeshNetworkLoadedSubscription.cancel(),
        _onMeshNetworkImportedSubscription.cancel(),
        _onMeshNetworkUpdatedSubscription.cancel(),
        _onMeshNetworkLoadFailedSubscription.cancel(),
        _onMeshNetworkImportFaildSubscription.cancel(),
        _onNetworkLoadedStreamController.close(),
        _onNetworkImported.close(),
        _onNetworkUpdated.close(),
        _onNetworkLoadFailed.close(),
        _onNetworkImportFailed.close(),
      ]);

  Future<MeshNetwork> loadMeshNetwork() async {
    final future = _onNetworkLoadedStreamController.stream.first;
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

  Stream<MeshNetwork> _streamOfMeshNetworkForSuccessEvent(
          MeshNetworkEventType eventType) =>
      _eventChannel
          .receiveBroadcastStream()
          .cast<Map>()
          .where((event) => event['eventName'] == eventType.value)
          .map((event) => MeshNetworkEventData.fromJson(event))
          .map((event) {
        if (eventType == MeshNetworkEventType.updated) {
          if (_lastMeshNetwork.id == event.id) {
            return _lastMeshNetwork;
          }
        }
        return MeshNetwork(event.id);
      }).doOnData((event) => _lastMeshNetwork = event);

  Stream<MeshNetworkEventError> _streamOfMeshNetworkForErrorEvent(
          MeshNetworkEventType eventType) =>
      _eventChannel
          .receiveBroadcastStream()
          .cast<Map>()
          .where((event) => event['eventName'] == eventType.value)
          .map((event) => MeshNetworkEventError.fromJson(event));
}
