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

  StreamSubscription _eventChannelSubscription;

  MeshNetwork _lastMeshNetwork;

  MeshManagerApi() {
    _eventChannelSubscription = _eventChannel
        .receiveBroadcastStream()
        .cast<Map>()
        .listen(_onEventChannelReceiveData);
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

  Future<void> dispose() => Future.wait([
        _eventChannelSubscription.cancel(),
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

  void _onEventChannelReceiveData(final Map data) {
    final _data = data.cast<String, Object>();
    if (_data['eventName'] == MeshNetworkApiEvent.loaded.value) {
      _onMeshNetworkLoaded(MeshNetworkEventData.fromJson(_data));
    } else if (_data['eventName'] == MeshNetworkApiEvent.imported.value) {
      _onMeshNetworkImported(MeshNetworkEventData.fromJson(_data));
    } else if (_data['eventName'] == MeshNetworkApiEvent.updated.value) {
      _onMeshUpdated(MeshNetworkEventData.fromJson(_data));
    } else if (_data['eventName'] == MeshNetworkApiEvent.loadFailed.value) {
      _onNetworkLoadFailedController.add(MeshNetworkEventError.fromJson(_data));
    } else if (_data['eventName'] == MeshNetworkApiEvent.importFailed.value) {
      _onNetworkImportFailedController
          .add(MeshNetworkEventError.fromJson(_data));
    }
  }

  void _onMeshNetworkLoaded(final MeshNetworkEventData data) {
    final meshNetwork = MeshNetwork(data.id);
    _lastMeshNetwork = meshNetwork;
    _onNetworkLoadedStreamController.add(meshNetwork);
  }

  void _onMeshNetworkImported(final MeshNetworkEventData data) {
    final meshNetwork = MeshNetwork(data.id);
    _lastMeshNetwork = meshNetwork;
    _onNetworkImportedController.add(meshNetwork);
  }

  void _onMeshUpdated(final MeshNetworkEventData data) {
    if (data.id == _lastMeshNetwork.id) {
      _onNetworkUpdatedController.add(_lastMeshNetwork);
      return;
    }
    final meshNetwork = MeshNetwork(data.id);
    _lastMeshNetwork = meshNetwork;
    _onNetworkUpdatedController.add(_lastMeshNetwork);
  }
}
