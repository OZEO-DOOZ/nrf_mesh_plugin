import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/events/mesh_manager_api_events.dart';
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
        _streamOfMeshNetworkSuccessEvent(MeshNetworkApiEvent.loaded)
            .listen(_onNetworkLoadedStreamController.add);
    _onMeshNetworkImportedSubscription =
        _streamOfMeshNetworkSuccessEvent(MeshNetworkApiEvent.imported)
            .listen(_onNetworkImported.add);
    _onMeshNetworkUpdatedSubscription =
        _streamOfMeshNetworkSuccessEvent(MeshNetworkApiEvent.updated)
            .listen(_onNetworkUpdated.add);

    _onMeshNetworkLoadFailedSubscription =
        _streamOfMeshNetworkErrorEvent(MeshNetworkApiEvent.loadFailed)
            .listen(_onNetworkLoadFailed.add);
    _onMeshNetworkImportFaildSubscription =
        _streamOfMeshNetworkErrorEvent(MeshNetworkApiEvent.importFailed)
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

  Future<void> setMtu(int mtuSize) =>
      _methodChannel.invokeMethod('setMtuSize', {'mtuSize': mtuSize});

  Future<String> exportMeshNetwork() =>
      _methodChannel.invokeMethod('exportMeshNetwork');

  Stream<Map> _filterEventChannelBy(MeshNetworkApiEvent eventType) =>
      _eventChannel
          .receiveBroadcastStream()
          .cast<Map>()
          .where((event) => event['eventName'] == eventType.value);

  Stream<MeshNetwork> _streamOfMeshNetworkSuccessEvent(
          MeshNetworkApiEvent eventType) =>
      _filterEventChannelBy(eventType)
          .map((event) => MeshNetworkEventData.fromJson(event))
          .map((event) {
        if (eventType == MeshNetworkApiEvent.updated) {
          if (_lastMeshNetwork.id == event.id) {
            return _lastMeshNetwork;
          }
        }
        return MeshNetwork(event.id);
      }).doOnData((event) => _lastMeshNetwork = event);

  Stream<MeshNetworkEventError> _streamOfMeshNetworkErrorEvent(
          MeshNetworkApiEvent eventType) =>
      _filterEventChannelBy(eventType)
          .map((event) => MeshNetworkEventError.fromJson(event));
}
