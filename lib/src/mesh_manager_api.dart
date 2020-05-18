import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/mesh_network.dart';

class MeshManagerApi {
  final _methodChannel =
      const MethodChannel('$namespace/mesh_manager_api/methods');
  final _eventChannel =
      const EventChannel('$namespace/mesh_manager_api/events');

  final _onNetworkLoaded = StreamController<MeshNetwork>();

  MeshManagerApi() {
    _eventChannel.receiveBroadcastStream().cast<Map>().listen((event) {
      switch (event['eventName']) {
        case 'onNetworkLoaded':
          _onNetworkLoaded.add(MeshNetwork(event['meshName']));
          break;
      }
    });
  }

  Stream<MeshNetwork> get onNetworkLoaded => _onNetworkLoaded.stream;
}
