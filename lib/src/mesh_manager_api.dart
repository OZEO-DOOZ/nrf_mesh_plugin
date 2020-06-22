import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/events/data/mesh_network/mesh_network_event.dart';
import 'package:nordic_nrf_mesh/src/events/data/mesh_provisioning_status/mesh_provisioning_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/send_provisioning_pdu/send_provisioning_pdu.dart';
import 'package:nordic_nrf_mesh/src/events/mesh_manager_api_events.dart';
import 'package:nordic_nrf_mesh/src/unprovisioned_mesh_node.dart';
import 'package:rxdart/rxdart.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/mesh_network.dart';

class MeshManagerApi {
  final _methodChannel = const MethodChannel('$namespace/mesh_manager_api/methods');
  final _eventChannel = const EventChannel('$namespace/mesh_manager_api/events');

  final _onNetworkLoadedStreamController = StreamController<MeshNetwork>.broadcast();
  final _onNetworkImportedController = StreamController<MeshNetwork>.broadcast();
  final _onNetworkUpdatedController = StreamController<MeshNetwork>.broadcast();

  final _onNetworkLoadFailedController = StreamController<MeshNetworkEventError>.broadcast();
  final _onNetworkImportFailedController = StreamController<MeshNetworkEventError>.broadcast();

  final _onMeshPduCreatedController = StreamController<List<int>>.broadcast();
  final _sendProvisioningPduController = StreamController<SendProvisioningPduData>.broadcast();

  final _onProvisioningStateChangedController = StreamController<MeshProvisioningStatusData>.broadcast();
  final _onProvisioningFailedController = StreamController<MeshProvisioningStatusData>.broadcast();
  final _onProvisioningCompletedController = StreamController<MeshProvisioningStatusData>.broadcast();

  StreamSubscription<MeshNetwork> _onNetworkLoadedSubscripiton;
  StreamSubscription<MeshNetwork> _onNetworkImportedSubscripiton;
  StreamSubscription<MeshNetwork> _onNetworkUpdatedSubscripiton;
  StreamSubscription<MeshNetworkEventError> _onNetworkLoadFailedSubscripiton;
  StreamSubscription<MeshNetworkEventError> _onNetworkImportFailedSubscripiton;
  StreamSubscription<List<int>> _onMeshPduCreatedSubscripiton;
  StreamSubscription<SendProvisioningPduData> _sendProvisioningPduSubscription;
  StreamSubscription<MeshProvisioningStatusData> _onProvisioningStateChangedSubscription;
  StreamSubscription<MeshProvisioningStatusData> _onProvisioningFailedSubscription;
  StreamSubscription<MeshProvisioningStatusData> _onProvisioningCompletedSubscription;

  Stream<Map<String, dynamic>> _eventChannelStream;
  MeshNetwork _lastMeshNetwork;

  MeshManagerApi() {
    _eventChannelStream =
        _eventChannel.receiveBroadcastStream().cast<Map>().map((event) => event.cast<String, dynamic>());

    _onNetworkLoadedSubscripiton =
        _onMeshNetworkEventSucceed(MeshManagerApiEvent.loaded).listen(_onNetworkLoadedStreamController.add);
    _onNetworkImportedSubscripiton =
        _onMeshNetworkEventSucceed(MeshManagerApiEvent.imported).listen(_onNetworkImportedController.add);
    _onNetworkUpdatedSubscripiton =
        _onMeshNetworkEventSucceed(MeshManagerApiEvent.updated).listen(_onNetworkUpdatedController.add);

    _onNetworkLoadFailedSubscripiton =
        _onMeshNetworkEventFailed(MeshManagerApiEvent.loadFailed).listen(_onNetworkLoadFailedController.add);
    _onNetworkImportFailedSubscripiton =
        _onMeshNetworkEventFailed(MeshManagerApiEvent.importFailed).listen(_onNetworkImportFailedController.add);

    _onMeshPduCreatedSubscripiton = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.meshPduCreated.value)
        .map((event) => event['pdu'] as List)
        .map((event) => event.cast<int>())
        .listen(_onMeshPduCreatedController.add);

    _sendProvisioningPduSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.sendProvisioningPdu.value)
        .map((event) => SendProvisioningPduData.fromJson(event))
        .listen(_sendProvisioningPduController.add);

    _onProvisioningStateChangedSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.provisioningStateChanged.value)
        .map((event) => MeshProvisioningStatusData.fromJson(event))
        .listen(_onProvisioningStateChangedController.add);

    _onProvisioningStateChangedSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.provisioningCompleted.value)
        .map((event) => MeshProvisioningStatusData.fromJson(event))
        .listen(_onProvisioningCompletedController.add);

    _onProvisioningStateChangedSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.provisioningFailed.value)
        .map((event) => MeshProvisioningStatusData.fromJson(event))
        .listen(_onProvisioningFailedController.add);
  }

  Stream<MeshNetwork> get onNetworkLoaded => _onNetworkLoadedStreamController.stream;

  Stream<MeshNetwork> get onNetworkImported => _onNetworkImportedController.stream;

  Stream<MeshNetwork> get onNetworkUpdated => _onNetworkUpdatedController.stream;

  Stream<MeshNetworkEventError> get onNetworkLoadFailed => _onNetworkLoadFailedController.stream;

  Stream<MeshNetworkEventError> get onNetworkImportFailed => _onNetworkImportFailedController.stream;

  Stream<List<int>> get onMeshPduCreated => _onMeshPduCreatedController.stream;

  Stream<SendProvisioningPduData> get sendProvisioningPdu => _sendProvisioningPduController.stream;

  Stream<MeshProvisioningStatusData> get onProvisioningStateChanged => _onProvisioningStateChangedController.stream;

  Stream<MeshProvisioningStatusData> get onProvisioningCompleted => _onProvisioningCompletedController.stream;

  Stream<MeshProvisioningStatusData> get onProvisioningFailed => _onProvisioningFailedController.stream;

  MeshNetwork get meshNetwork => _lastMeshNetwork;

  String get meshProvisioningUuidServiceKey {
    if (Platform.isAndroid) {
      return meshProvisioningUuid.toString();
    } else if (Platform.isIOS) {
      return '1827';
    }
    return null;
  }

  void dispose() => Future.wait([
        _onNetworkLoadedSubscripiton.cancel(),
        _onNetworkImportedSubscripiton.cancel(),
        _onNetworkUpdatedSubscripiton.cancel(),
        _onNetworkLoadFailedSubscripiton.cancel(),
        _onNetworkImportFailedSubscripiton.cancel(),
        _onMeshPduCreatedSubscripiton.cancel(),
        _sendProvisioningPduSubscription.cancel(),
        _onProvisioningStateChangedSubscription.cancel(),
        _onProvisioningFailedSubscription.cancel(),
        _onProvisioningCompletedSubscription.cancel(),
        _onNetworkLoadedStreamController.close(),
        _onNetworkImportedController.close(),
        _onNetworkUpdatedController.close(),
        _onNetworkLoadFailedController.close(),
        _onNetworkImportFailedController.close(),
        _sendProvisioningPduController.close(),
        _onMeshPduCreatedController.close(),
        _onProvisioningStateChangedController.close(),
        _onProvisioningFailedController.close(),
        _onProvisioningCompletedController.close(),
      ]);

  Future<MeshNetwork> loadMeshNetwork() async {
    final future = _onNetworkLoadedStreamController.stream.first;
    await _methodChannel.invokeMethod('loadMeshNetwork');
    return future;
  }

  Future<MeshNetwork> importMeshNetworkJson(final String json) async {
    final future = _onNetworkImportedController.stream.first;
    await _methodChannel.invokeMethod('importMeshNetworkJson', {'json': json});
    return future;
  }

  Future<void> setMtu(final int mtuSize) => _methodChannel.invokeMethod('setMtuSize', {'mtuSize': mtuSize});

  Future<String> exportMeshNetwork() => _methodChannel.invokeMethod('exportMeshNetwork');

  Future<void> resetMeshNetwork() => _methodChannel.invokeMethod('resetMeshNetwork');

  Future<void> handleNotifications(int mtu, List<int> pdu) =>
      _methodChannel.invokeMethod('handleNotifications', {'mtu': mtu, 'pdu': pdu});

  Future<void> handleWriteCallbacks(int mtu, List<int> pdu) =>
      _methodChannel.invokeMethod('handleWriteCallbacks', {'mtu': mtu, 'pdu': pdu});

  Future<void> identifyNode(String serviceUuid) =>
      _methodChannel.invokeMethod('identifyNode', {'serviceUuid': serviceUuid});

  Future<void> cleanProvisioningData() => _methodChannel.invokeMethod('cleanProvisioningData');

  String getDeviceUuid(List<int> serviceData) {
    var msb = 0;
    var lsb = 0;
    for (var i = 0; i < 8; i++) {
      msb = (msb << 8) | (serviceData[i] & 0xff);
    }
    for (var i = 8; i < 16; i++) {
      lsb = (lsb << 8) | (serviceData[i] & 0xff);
    }
    return '${_digits(msb >> 32, 8)}-${_digits(msb >> 16, 4)}-${_digits(msb, 4)}-${_digits(lsb >> 48, 4)}-${_digits(lsb, 12)}';
  }

  Future<void> provisioningIos(String uuid) => _methodChannel.invokeMethod('provisioning', {'uuid': uuid});

  Future<void> provisioning(UnprovisionedMeshNode meshNode) =>
      _methodChannel.invokeMethod('provisioning', meshNode.toJson());

  String _digits(int val, int digits) {
    var hi = 1 << (digits * 4);
    return (hi | (val & (hi - 1))).toRadixString(16).substring(1);
  }

  Stream<Map<String, Object>> _filterEventChannel(final MeshManagerApiEvent eventType) =>
      _eventChannelStream.where((event) => event['eventName'] == eventType.value);

  Stream<MeshNetwork> _onMeshNetworkEventSucceed(final MeshManagerApiEvent eventType) =>
      _filterEventChannel(eventType).map((event) => MeshNetworkEventData.fromJson(event)).map((event) {
        if (eventType == MeshManagerApiEvent.updated) {
          return _lastMeshNetwork;
        }
        return MeshNetwork(event.id);
      }).doOnData((event) => _lastMeshNetwork = event);

  Stream<MeshNetworkEventError> _onMeshNetworkEventFailed(final MeshManagerApiEvent eventType) =>
      _filterEventChannel(eventType).map((event) => MeshNetworkEventError.fromJson(event));
}
