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
  final _onNetworkImportedController =
      StreamController<MeshNetwork>.broadcast();
  final _onNetworkUpdatedController = StreamController<MeshNetwork>.broadcast();

  final _onNetworkLoadFailedController =
      StreamController<MeshNetworkEventError>.broadcast();
  final _onNetworkImportFailedController =
      StreamController<MeshNetworkEventError>.broadcast();

  Stream _eventChannelStream;

  StreamSubscription _onNetworkLoadedSubscripiton;
  StreamSubscription _onNetworkImportedSubscripiton;
  StreamSubscription _onNetworkUpdatedSubscripiton;
  StreamSubscription _onNetworkLoadFailedSubscripiton;
  StreamSubscription _onNetworkImportFailedSubscripiton;

  MeshNetwork _lastMeshNetwork;

  MeshManagerApi() {
    _eventChannelStream = _eventChannel.receiveBroadcastStream();

    _onNetworkLoadedSubscripiton =
        _onMeshNetworkEventSucceed(MeshNetworkApiEvent.loaded)
            .listen(_onNetworkLoadedStreamController.add);
    _onNetworkImportedSubscripiton =
        _onMeshNetworkEventSucceed(MeshNetworkApiEvent.imported)
            .listen(_onNetworkImportedController.add);
    _onNetworkUpdatedSubscripiton =
        _onMeshNetworkEventSucceed(MeshNetworkApiEvent.updated)
            .listen(_onNetworkUpdatedController.add);

    _onNetworkLoadFailedSubscripiton =
        _onMeshNetworkEventFailed(MeshNetworkApiEvent.loadFailed)
            .listen(_onNetworkLoadFailedController.add);
    _onNetworkImportFailedSubscripiton =
        _onMeshNetworkEventFailed(MeshNetworkApiEvent.importFailed)
            .listen(_onNetworkImportFailedController.add);
  }

  Stream<MeshNetwork> get onNetworkLoaded =>
      _onNetworkLoadedStreamController.stream;

  Stream<MeshNetwork> get onNetworkImported =>
      _onNetworkImportedController.stream;

  Stream<MeshNetwork> get onNetworkUpdated =>
      _onNetworkUpdatedController.stream;

  Stream<MeshNetworkEventError> get onNetworkLoadFailed =>
      _onNetworkLoadFailedController.stream;

  Stream<MeshNetworkEventError> get onNetworkImportFailed =>
      _onNetworkImportFailedController.stream;

  MeshNetwork get meshNetwork => _lastMeshNetwork;

  void dispose() => Future.wait([
        _onNetworkLoadedSubscripiton.cancel(),
        _onNetworkImportedSubscripiton.cancel(),
        _onNetworkUpdatedSubscripiton.cancel(),
        _onNetworkLoadFailedSubscripiton.cancel(),
        _onNetworkImportFailedSubscripiton.cancel(),
        _onNetworkLoadedStreamController.close(),
        _onNetworkImportedController.close(),
        _onNetworkUpdatedController.close(),
        _onNetworkLoadFailedController.close(),
        _onNetworkImportFailedController.close(),
      ]);

  Future<MeshNetwork> loadMeshNetwork() async {
    final future = _onNetworkLoadedStreamController.stream.first;
    await _methodChannel.invokeMethod('loadMeshNetwork');
    return future;
  }

  Future<MeshNetwork> importMeshNetworkJson(final String json) async {
    final future = _onNetworkImportedController.stream.first;
    await _methodChannel.invokeMethod('importMeshNetworkJson');
    return future;
  }

  Future<void> setMtu(final int mtuSize) =>
      _methodChannel.invokeMethod('setMtuSize', {'mtuSize': mtuSize});

  Future<String> exportMeshNetwork() =>
      _methodChannel.invokeMethod('exportMeshNetwork');

  Stream<Map<String, Object>> _filterEventChannel(
          final MeshNetworkApiEvent eventType) =>
      _eventChannelStream
          .cast<Map>()
          .map((event) => event.cast<String, Object>())
          .where((event) => event['eventName'] == eventType.value);

  Stream<MeshNetwork> _onMeshNetworkEventSucceed(
          final MeshNetworkApiEvent eventType) =>
      _filterEventChannel(eventType)
          .map((event) => MeshNetworkEventData.fromJson(event))
          .map((event) {
        if (eventType == MeshNetworkApiEvent.updated) {
          return _lastMeshNetwork;
        }
        return MeshNetwork(event.id);
      }).doOnData((event) => _lastMeshNetwork = event);

  Stream<MeshNetworkEventError> _onMeshNetworkEventFailed(
          final MeshNetworkApiEvent eventType) =>
      _filterEventChannel(eventType)
          .map((event) => MeshNetworkEventError.fromJson(event));
}
