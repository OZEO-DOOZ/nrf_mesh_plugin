import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_app_key_status/config_app_key_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_composition_data_status/config_composition_data_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_model_app_status/config_model_app_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/generic_level_status/generic_level_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/generic_on_off_status/generic_on_off_status.dart';
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
  final _onProvisioningCompletedController = StreamController<MeshProvisioningCompletedData>.broadcast();

  final _onConfigCompositionDataStatusController = StreamController<ConfigCompositionDataStatusData>.broadcast();
  final _onConfigAppKeyStatusController = StreamController<ConfigAppKeyStatusData>.broadcast();
  final _onGenericLevelStatusController = StreamController<GenericLevelStatusData>.broadcast();
  final _onGenericOnOffStatusController = StreamController<GenericOnOffStatusData>.broadcast();
  final _onConfigModelAppStatusController = StreamController<ConfigModelAppStatusData>.broadcast();

  StreamSubscription<MeshNetwork> _onNetworkLoadedSubscription;
  StreamSubscription<MeshNetwork> _onNetworkImportedSubscription;
  StreamSubscription<MeshNetwork> _onNetworkUpdatedSubscription;
  StreamSubscription<MeshNetworkEventError> _onNetworkLoadFailedSubscription;
  StreamSubscription<MeshNetworkEventError> _onNetworkImportFailedSubscripiton;
  StreamSubscription<List<int>> _onMeshPduCreatedSubscription;
  StreamSubscription<SendProvisioningPduData> _sendProvisioningPduSubscription;
  StreamSubscription<MeshProvisioningStatusData> _onProvisioningStateChangedSubscription;
  StreamSubscription<MeshProvisioningStatusData> _onProvisioningFailedSubscription;
  StreamSubscription<MeshProvisioningCompletedData> _onProvisioningCompletedSubscription;
  StreamSubscription<ConfigCompositionDataStatusData> _onConfigCompositionDataStatusSubscription;
  StreamSubscription<ConfigAppKeyStatusData> _onConfigAppKeyStatusSubscription;
  StreamSubscription<GenericLevelStatusData> _onGenericLevelStatusSubscription;
  StreamSubscription<GenericOnOffStatusData> _onGenericOnOffStatusSubscription;
  StreamSubscription<ConfigModelAppStatusData> _onConfigModelAppStatusSubscription;

  Stream<Map<String, dynamic>> _eventChannelStream;
  MeshNetwork _lastMeshNetwork;

  MeshManagerApi() {
    //  this is for debug purpose
    _eventChannelStream = _eventChannel
        .receiveBroadcastStream()
        .cast<Map>()
        .map((event) => event.cast<String, dynamic>())
        .doOnData(print);

    _onNetworkLoadedSubscription =
        _onMeshNetworkEventSucceed(MeshManagerApiEvent.loaded).listen(_onNetworkLoadedStreamController.add);
    _onNetworkImportedSubscription =
        _onMeshNetworkEventSucceed(MeshManagerApiEvent.imported).listen(_onNetworkImportedController.add);
    _onNetworkUpdatedSubscription =
        _onMeshNetworkEventSucceed(MeshManagerApiEvent.updated).listen(_onNetworkUpdatedController.add);

    _onNetworkLoadFailedSubscription =
        _onMeshNetworkEventFailed(MeshManagerApiEvent.loadFailed).listen(_onNetworkLoadFailedController.add);
    _onNetworkImportFailedSubscripiton =
        _onMeshNetworkEventFailed(MeshManagerApiEvent.importFailed).listen(_onNetworkImportFailedController.add);

    _onMeshPduCreatedSubscription = _eventChannelStream
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

    _onProvisioningCompletedSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.provisioningCompleted.value)
        .map((event) => MeshProvisioningCompletedData.fromJson(event))
        .listen(_onProvisioningCompletedController.add);

    _onProvisioningFailedSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.provisioningFailed.value)
        .map((event) => MeshProvisioningStatusData.fromJson(event))
        .listen(_onProvisioningFailedController.add);

    _onConfigCompositionDataStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.configCompositionDataStatus.value)
        .map((event) => ConfigCompositionDataStatusData.fromJson(event))
        .listen(_onConfigCompositionDataStatusController.add);
    _onConfigAppKeyStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.configAppKeyStatus.value)
        .map((event) => ConfigAppKeyStatusData.fromJson(event))
        .listen(_onConfigAppKeyStatusController.add);
    _onGenericLevelStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.genericLevelStatus.value)
        .map((event) => GenericLevelStatusData.fromJson(event))
        .listen(_onGenericLevelStatusController.add);
    _onGenericOnOffStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.genericOnOffStatus.value)
        .map((event) => GenericOnOffStatusData.fromJson(event))
        .listen(_onGenericOnOffStatusController.add);

    _onConfigModelAppStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.configModelAppStatus.value)
        .map((event) => ConfigModelAppStatusData.fromJson(event))
        .listen(_onConfigModelAppStatusController.add);
  }

  Stream<MeshNetwork> get onNetworkLoaded => _onNetworkLoadedStreamController.stream;

  Stream<MeshNetwork> get onNetworkImported => _onNetworkImportedController.stream;

  Stream<MeshNetwork> get onNetworkUpdated => _onNetworkUpdatedController.stream;

  Stream<MeshNetworkEventError> get onNetworkLoadFailed => _onNetworkLoadFailedController.stream;

  Stream<MeshNetworkEventError> get onNetworkImportFailed => _onNetworkImportFailedController.stream;

  Stream<List<int>> get onMeshPduCreated => _onMeshPduCreatedController.stream;

  Stream<SendProvisioningPduData> get sendProvisioningPdu => _sendProvisioningPduController.stream;

  Stream<MeshProvisioningStatusData> get onProvisioningStateChanged => _onProvisioningStateChangedController.stream;

  Stream<MeshProvisioningCompletedData> get onProvisioningCompleted => _onProvisioningCompletedController.stream;

  Stream<MeshProvisioningStatusData> get onProvisioningFailed => _onProvisioningFailedController.stream;

  Stream<ConfigCompositionDataStatusData> get onConfigCompositionDataStatus =>
      _onConfigCompositionDataStatusController.stream;

  Stream<ConfigAppKeyStatusData> get onConfigAppKeyStatus => _onConfigAppKeyStatusController.stream;

  Stream<GenericLevelStatusData> get onGenericLevelStatus => _onGenericLevelStatusController.stream;

  Stream<GenericOnOffStatusData> get onGenericOnOffStatus => _onGenericOnOffStatusController.stream;

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
        _onNetworkLoadedSubscription.cancel(),
        _onNetworkImportedSubscription.cancel(),
        _onNetworkUpdatedSubscription.cancel(),
        _onNetworkLoadFailedSubscription.cancel(),
        _onNetworkImportFailedSubscripiton.cancel(),
        _onMeshPduCreatedSubscription.cancel(),
        _sendProvisioningPduSubscription.cancel(),
        _onProvisioningStateChangedSubscription.cancel(),
        _onProvisioningFailedSubscription.cancel(),
        _onProvisioningCompletedSubscription.cancel(),
        _onConfigCompositionDataStatusSubscription.cancel(),
        _onConfigAppKeyStatusSubscription.cancel(),
        _onGenericLevelStatusSubscription.cancel(),
        _onGenericOnOffStatusSubscription.cancel(),
        _onConfigModelAppStatusSubscription.cancel(),
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
        _onConfigCompositionDataStatusController.close(),
        _onConfigAppKeyStatusController.close(),
        _onGenericLevelStatusController.close(),
        _onGenericOnOffStatusController.close(),
        _onConfigModelAppStatusController.close(),
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

  Future<GenericLevelStatusData> sendGenericLevelSet(
    int address,
    int level,
    int sequenceNumber, {
    int keyIndex = 0,
    int transitionStep,
    int transitionResolution,
    int delay,
  }) async {
    final status =
        _onGenericLevelStatusController.stream.firstWhere((element) => element.source == address, orElse: () => null);
    await _methodChannel.invokeMethod('sendGenericLevelSet', {
      'address': address,
      'level': level,
      'sequenceNumber': sequenceNumber,
      'keyIndex': keyIndex,
      'transitionStep': transitionStep,
      'transitionResolution': transitionResolution,
      'delay': delay,
    });
    return status;
  }

  Future<GenericOnOffStatusData> sendGenericOnOffSet(int address, bool value) async {
    final status = _onGenericOnOffStatusController.stream
        .firstWhere((element) => element.source == address && element.presentState == value, orElse: () => null);
    await _methodChannel.invokeMethod('sendGenericOnOffSet', {'address': address, 'value': value});
    return status;
  }

  Future<void> createMeshPduForConfigCompositionDataGet(int dest) =>
      _methodChannel.invokeMethod('createMeshPduForConfigCompositionDataGet', {'dest': dest});

  Future<void> createMeshPduForConfigAppKeyAdd(int dest) =>
      _methodChannel.invokeMethod('createMeshPduForConfigAppKeyAdd', {'dest': dest});

  Future<void> sendConfigModelAppBind(int nodeId, int elementId, int modelId, {int appKeyIndex = 0}) async {
    final status = _onConfigModelAppStatusController.stream.firstWhere(
        (element) =>
            element.elementAddress == elementId && element.modelId == modelId && element.appKeyIndex == appKeyIndex,
        orElse: () => null);
    await _methodChannel.invokeMethod('sendConfigModelAppBind', {
      'nodeId': nodeId,
      'elementId': elementId,
      'modelId': modelId,
      'appKeyIndex': appKeyIndex,
    });
    return status;
  }

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

  Future<int> getSequenceNumber(int address) =>
      _methodChannel.invokeMethod('getSequenceNumberForAddress', {'address': address});

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
