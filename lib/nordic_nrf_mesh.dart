import 'dart:async';

import 'package:flutter/services.dart';

const _namespace = 'fr.dooz.nordic_nrf_mesh';

class NordicNrfMesh {
  final _methodChannel = const MethodChannel('$_namespace/methods');

  NordicNrfMesh();

  Future<String> get platformVersion async {
    final String version =
        await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<NrfMeshNetwork> loadMeshNetwork() async {
    await _methodChannel.invokeMethod('loadMeshNetwork');
    return NrfMeshNetwork();
  }
}

class NrfMeshNetwork {
  final _methodChannel = const MethodChannel('$_namespace/meshnetwork/methods');
  final _eventChannel = const EventChannel('$_namespace/meshnetwork/events');

  final _onNetworkLoaded = StreamController<String>();

  NrfMeshNetwork() {
    _eventChannel.receiveBroadcastStream().cast<Map>().listen((event) {
      switch (event['eventName']) {
        case 'onNetworkLoaded':
          _onNetworkLoaded.add(event['meshName'] as String);
          break;
      }
    });
  }

  Stream<String> get onNetworkLoaded => _onNetworkLoaded.stream;
}
