import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/contants.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_app_key_status/config_app_key_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_composition_data_status/config_composition_data_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_model_app_status/config_model_app_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_model_publication_status/config_model_publication_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_model_subscription_status/config_model_subscription_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_network_transmit_status/config_network_transmit_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_default_ttl_status/config_default_ttl_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/config_node_reset_status/config_node_reset_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/generic_level_status/generic_level_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/generic_on_off_status/generic_on_off_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/light_ctl_status/light_ctl_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/light_hsl_status/light_hsl_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/light_lightness_status/light_lightness_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/magic_level_get_status/magic_level_get_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/magic_level_set_status/magic_level_set_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/mesh_network/mesh_network_event.dart';
import 'package:nordic_nrf_mesh/src/events/data/mesh_provisioning_status/mesh_provisioning_status.dart';
import 'package:nordic_nrf_mesh/src/events/data/send_provisioning_pdu/send_provisioning_pdu.dart';
import 'package:nordic_nrf_mesh/src/events/mesh_manager_api_events.dart';
import 'package:nordic_nrf_mesh/src/mesh_network.dart';
import 'package:nordic_nrf_mesh/src/unprovisioned_mesh_node.dart';
import 'package:rxdart/rxdart.dart';

class MeshManagerApi {
  late final _methodChannel = const MethodChannel('$namespace/mesh_manager_api/methods');
  late final _eventChannel = const EventChannel('$namespace/mesh_manager_api/events');

  late final _onNetworkLoadedStreamController = StreamController<MeshNetwork>.broadcast();
  late final _onNetworkImportedController = StreamController<MeshNetwork>.broadcast();
  late final _onNetworkUpdatedController = StreamController<MeshNetwork>.broadcast();

  late final _onMeshPduCreatedController = StreamController<List<int>>.broadcast();
  late final _sendProvisioningPduController = StreamController<SendProvisioningPduData>.broadcast();

  late final _onProvisioningStateChangedController = StreamController<MeshProvisioningStatusData>.broadcast();
  late final _onProvisioningFailedController = StreamController<MeshProvisioningStatusData>.broadcast();
  late final _onProvisioningCompletedController = StreamController<MeshProvisioningCompletedData>.broadcast();

  late final _onConfigCompositionDataStatusController = StreamController<ConfigCompositionDataStatusData>.broadcast();
  late final _onConfigAppKeyStatusController = StreamController<ConfigAppKeyStatusData>.broadcast();
  late final _onGenericLevelStatusController = StreamController<GenericLevelStatusData>.broadcast();
  late final _onV2MagicLevelSetStatusController = StreamController<MagicLevelSetStatusData>.broadcast();
  late final _onV2MagicLevelGetStatusController = StreamController<MagicLevelGetStatusData>.broadcast();

  late final _onGenericOnOffStatusController = StreamController<GenericOnOffStatusData>.broadcast();
  late final _onConfigModelAppStatusController = StreamController<ConfigModelAppStatusData>.broadcast();
  late final _onConfigModelSubscriptionStatusController = StreamController<ConfigModelSubscriptionStatus>.broadcast();
  late final _onConfigModelPublicationStatusController = StreamController<ConfigModelPublicationStatus>.broadcast();
  late final _onConfigNodeResetStatusController = StreamController<ConfigNodeResetStatus>.broadcast();
  late final _onConfigNetworkTransmitStatusController = StreamController<ConfigNetworkTransmitStatus>.broadcast();
  late final _onConfigDefaultTtlStatusController = StreamController<ConfigDefaultTtlStatus>.broadcast();

  late final _onLightLightnessStatusController = StreamController<LightLightnessStatusData>.broadcast();
  late final _onLightCtlStatusController = StreamController<LightCtlStatusData>.broadcast();
  late final _onLightHslStatusController = StreamController<LightHslStatusData>.broadcast();

  late StreamSubscription<MeshNetwork> _onNetworkLoadedSubscription;
  late StreamSubscription<MeshNetwork> _onNetworkImportedSubscription;
  late StreamSubscription<MeshNetwork> _onNetworkUpdatedSubscription;
  late StreamSubscription<MeshNetworkEventError> _onNetworkLoadFailedSubscription;
  late StreamSubscription<MeshNetworkEventError> _onNetworkImportFailedSubscription;
  late StreamSubscription<List<int>> _onMeshPduCreatedSubscription;
  late StreamSubscription<SendProvisioningPduData> _sendProvisioningPduSubscription;
  late StreamSubscription<MeshProvisioningStatusData> _onProvisioningStateChangedSubscription;
  late StreamSubscription<MeshProvisioningStatusData> _onProvisioningFailedSubscription;
  late StreamSubscription<MeshProvisioningCompletedData> _onProvisioningCompletedSubscription;
  late StreamSubscription<ConfigCompositionDataStatusData> _onConfigCompositionDataStatusSubscription;
  late StreamSubscription<ConfigAppKeyStatusData> _onConfigAppKeyStatusSubscription;
  late StreamSubscription<GenericLevelStatusData> _onGenericLevelStatusSubscription;
  late StreamSubscription<GenericOnOffStatusData> _onGenericOnOffStatusSubscription;
  late StreamSubscription<MagicLevelSetStatusData> _onV2MagicLevelSetStatusSubscription;
  late StreamSubscription<MagicLevelGetStatusData> _onV2MagicLevelGetStatusSubscription;
  late StreamSubscription<ConfigModelAppStatusData> _onConfigModelAppStatusSubscription;
  late StreamSubscription<ConfigModelSubscriptionStatus> _onConfigModelSubscriptionStatusSubscription;
  late StreamSubscription<ConfigModelPublicationStatus> _onConfigModelPublicationStatusSubscription;
  late StreamSubscription<ConfigNodeResetStatus> _onConfigNodeResetStatusSubscription;
  late StreamSubscription<ConfigNetworkTransmitStatus> _onConfigNetworkTransmitStatusSubscription;
  late StreamSubscription<ConfigDefaultTtlStatus> _onConfigDefaultTtlStatusSubscription;

  late StreamSubscription<LightLightnessStatusData> _onLightLightnessStatusSubscription;
  late StreamSubscription<LightCtlStatusData> _onLightCtlStatusSubscription;
  late StreamSubscription<LightHslStatusData> _onLightHslStatusSubscription;

  late Stream<Map<String, dynamic>> _eventChannelStream;
  MeshNetwork? _lastMeshNetwork;

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
        _onMeshNetworkEventFailed(MeshManagerApiEvent.loadFailed).listen(_onNetworkLoadedStreamController.addError);
    _onNetworkImportFailedSubscription =
        _onMeshNetworkEventFailed(MeshManagerApiEvent.importFailed).listen(_onNetworkImportedController.addError);

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
    _onV2MagicLevelSetStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.v2MagicLevelSetStatus.value)
        .map((event) => MagicLevelSetStatusData.fromJson(event))
        .listen(_onV2MagicLevelSetStatusController.add);
    _onV2MagicLevelGetStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.v2MagicLevelGetStatus.value)
        .map((event) => MagicLevelGetStatusData.fromJson(event))
        .listen(_onV2MagicLevelGetStatusController.add);

    _onLightLightnessStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.lightLightnessStatus.value)
        .map((event) => LightLightnessStatusData.fromJson(event))
        .listen(_onLightLightnessStatusController.add);
    _onLightCtlStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.lightCtlStatus.value)
        .map((event) => LightCtlStatusData.fromJson(event))
        .listen(_onLightCtlStatusController.add);
    _onLightHslStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.lightHslStatus.value)
        .map((event) => LightHslStatusData.fromJson(event))
        .listen(_onLightHslStatusController.add);

    _onConfigModelAppStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.configModelAppStatus.value)
        .map((event) => ConfigModelAppStatusData.fromJson(event))
        .listen(_onConfigModelAppStatusController.add);
    _onConfigModelSubscriptionStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.configModelSubscriptionStatus.value)
        .map((event) => ConfigModelSubscriptionStatus.fromJson(event))
        .listen(_onConfigModelSubscriptionStatusController.add);
    _onConfigModelPublicationStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.configModelPublicationStatus.value)
        .map((event) => ConfigModelPublicationStatus.fromJson(event))
        .listen(_onConfigModelPublicationStatusController.add);
    _onConfigNodeResetStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.configNodeResetStatus.value)
        .map((event) => ConfigNodeResetStatus.fromJson(event))
        .listen(_onConfigNodeResetStatusController.add);
    _onConfigNetworkTransmitStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.configNetworkTransmitStatus.value)
        .map((event) => ConfigNetworkTransmitStatus.fromJson(event))
        .listen(_onConfigNetworkTransmitStatusController.add);
    _onConfigDefaultTtlStatusSubscription = _eventChannelStream
        .where((event) => event['eventName'] == MeshManagerApiEvent.configDefaultTtlStatus.value)
        .map((event) => ConfigDefaultTtlStatus.fromJson(event))
        .listen(_onConfigDefaultTtlStatusController.add);
  }

  Stream<ConfigNetworkTransmitStatus> get onConfigNetworkTransmitStatus =>
      _onConfigNetworkTransmitStatusController.stream;

  Stream<ConfigDefaultTtlStatus> get onConfigDefaultTtlStatus => _onConfigDefaultTtlStatusController.stream;

  Stream<ConfigNodeResetStatus> get onConfigNodeResetStatus => _onConfigNodeResetStatusController.stream;

  Stream<ConfigModelPublicationStatus> get onConfigModelPublicationStatus =>
      _onConfigModelPublicationStatusController.stream;

  Stream<ConfigModelSubscriptionStatus> get onConfigModelSubscriptionStatus =>
      _onConfigModelSubscriptionStatusController.stream;

  Stream<IMeshNetwork> get onNetworkLoaded => _onNetworkLoadedStreamController.stream;

  Stream<IMeshNetwork> get onNetworkImported => _onNetworkImportedController.stream;

  Stream<IMeshNetwork> get onNetworkUpdated => _onNetworkUpdatedController.stream;

  Stream<List<int>> get onMeshPduCreated => _onMeshPduCreatedController.stream;

  Stream<SendProvisioningPduData> get sendProvisioningPdu => _sendProvisioningPduController.stream;

  Stream<MeshProvisioningStatusData> get onProvisioningStateChanged => _onProvisioningStateChangedController.stream;

  Stream<MeshProvisioningCompletedData> get onProvisioningCompleted => _onProvisioningCompletedController.stream;

  Stream<MeshProvisioningStatusData> get onProvisioningFailed => _onProvisioningFailedController.stream;

  Stream<ConfigCompositionDataStatusData> get onConfigCompositionDataStatus =>
      _onConfigCompositionDataStatusController.stream;

  Stream<ConfigAppKeyStatusData> get onConfigAppKeyStatus => _onConfigAppKeyStatusController.stream;

  Stream<ConfigModelAppStatusData> get onConfigModelAppStatus => _onConfigModelAppStatusController.stream;

  Stream<GenericLevelStatusData> get onGenericLevelStatus => _onGenericLevelStatusController.stream;

  Stream<GenericOnOffStatusData> get onGenericOnOffStatus => _onGenericOnOffStatusController.stream;

  Stream<MagicLevelSetStatusData> get onV2MagicLevelSetStatus => _onV2MagicLevelSetStatusController.stream;

  Stream<MagicLevelGetStatusData> get onV2MagicLevelGetStatus => _onV2MagicLevelGetStatusController.stream;

  IMeshNetwork? get meshNetwork => _lastMeshNetwork;

  Stream<LightLightnessStatusData> get onLightLightnessStatus => _onLightLightnessStatusController.stream;

  Stream<LightCtlStatusData> get onLightCtlStatus => _onLightCtlStatusController.stream;

  Stream<LightHslStatusData> get onLightHslStatus => _onLightHslStatusController.stream;

  Uuid get meshProvisioningUuidServiceKey => meshProvisioningUuid;

  Future<bool> isAdvertisedWithNodeIdentity(final List<int> serviceData) async {
    final result = await _methodChannel.invokeMethod<bool>(
      'isAdvertisedWithNodeIdentity',
      {'serviceData': serviceData},
    );
    return result!;
  }

  Future<bool> nodeIdentityMatches(List<int> serviceData) async {
    final result = await _methodChannel.invokeMethod<bool>(
      'nodeIdentityMatches',
      {'serviceData': serviceData},
    );
    return result!;
  }

  Future<bool> isAdvertisingWithNetworkIdentity(final List<int> serviceData) async {
    final result = await _methodChannel.invokeMethod<bool>(
      'isAdvertisingWithNetworkIdentity',
      {'serviceData': serviceData},
    );
    return result!;
  }

  Future<bool> networkIdMatches(List<int> serviceData) async {
    final result = await _methodChannel.invokeMethod(
      'networkIdMatches',
      {'serviceData': serviceData},
    );
    return result!;
  }

  void dispose() => Future.wait([
        _onNetworkLoadedSubscription.cancel(),
        _onNetworkImportedSubscription.cancel(),
        _onNetworkUpdatedSubscription.cancel(),
        _onNetworkLoadFailedSubscription.cancel(),
        _onNetworkImportFailedSubscription.cancel(),
        _onMeshPduCreatedSubscription.cancel(),
        _sendProvisioningPduSubscription.cancel(),
        _onProvisioningStateChangedSubscription.cancel(),
        _onProvisioningFailedSubscription.cancel(),
        _onProvisioningCompletedSubscription.cancel(),
        _onConfigCompositionDataStatusSubscription.cancel(),
        _onConfigAppKeyStatusSubscription.cancel(),
        _onGenericLevelStatusSubscription.cancel(),
        _onV2MagicLevelSetStatusSubscription.cancel(),
        _onV2MagicLevelGetStatusSubscription.cancel(),
        _onGenericOnOffStatusSubscription.cancel(),
        _onConfigModelAppStatusSubscription.cancel(),
        _onConfigModelSubscriptionStatusSubscription.cancel(),
        _onConfigModelPublicationStatusSubscription.cancel(),
        _onLightLightnessStatusSubscription.cancel(),
        _onLightCtlStatusSubscription.cancel(),
        _onLightHslStatusSubscription.cancel(),
        _onLightLightnessStatusController.close(),
        _onLightCtlStatusController.close(),
        _onLightHslStatusController.close(),
        _onConfigNodeResetStatusSubscription.cancel(),
        _onConfigNetworkTransmitStatusSubscription.cancel(),
        _onConfigDefaultTtlStatusSubscription.cancel(),
        _onNetworkLoadedStreamController.close(),
        _onNetworkImportedController.close(),
        _onNetworkUpdatedController.close(),
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
        _onConfigModelSubscriptionStatusController.close(),
        _onConfigModelPublicationStatusController.close(),
        _onV2MagicLevelSetStatusController.close(),
        _onV2MagicLevelGetStatusController.close(),
        _onConfigNodeResetStatusController.close(),
        _onConfigNetworkTransmitStatusController.close(),
        _onConfigDefaultTtlStatusController.close()
      ]);

  Future<IMeshNetwork> loadMeshNetwork() async {
    final future = _onNetworkLoadedStreamController.stream.first;
    await _methodChannel.invokeMethod('loadMeshNetwork');
    return future;
  }

  Future<MeshNetwork> importMeshNetworkJson(final String json) async {
    final future = _onNetworkImportedController.stream.first;
    await _methodChannel.invokeMethod('importMeshNetworkJson', {'json': json});
    return future;
  }

  Future<void> setMtu(final int mtuSize) => _methodChannel.invokeMethod<void>('setMtuSize', {'mtuSize': mtuSize});

  Future<String> exportMeshNetwork() async {
    final json = await _methodChannel.invokeMethod<String>('exportMeshNetwork');
    return json!;
  }

  Future<void> resetMeshNetwork() => _methodChannel.invokeMethod<void>('resetMeshNetwork');

  Future<void> handleNotifications(int mtu, List<int> pdu) => _methodChannel.invokeMethod<void>(
        'handleNotifications',
        {'mtu': mtu, 'pdu': pdu},
      );

  Future<void> handleWriteCallbacks(int mtu, List<int> pdu) => _methodChannel.invokeMethod<void>(
        'handleWriteCallbacks',
        {'mtu': mtu, 'pdu': pdu},
      );

  Future<void> identifyNode(String serviceUuid) => _methodChannel.invokeMethod<void>(
        'identifyNode',
        {'serviceUuid': serviceUuid},
      );

  Future<void> cleanProvisioningData() => _methodChannel.invokeMethod<void>('cleanProvisioningData');

  Future<GenericLevelStatusData> sendGenericLevelSet(
    int address,
    int level, {
    int keyIndex = 0,
    int transitionStep = 0,
    int transitionResolution = 0,
    int delay = 0,
  }) async {
    final status = _onGenericLevelStatusController.stream.firstWhere(
      (element) => element.source == address,
      orElse: () => GenericLevelStatusData(-1, -1, -1, -1, -1, -1),
    );
    await _methodChannel.invokeMethod('sendGenericLevelSet', {
      'address': address,
      'level': level,
      'keyIndex': keyIndex,
      'transitionStep': transitionStep,
      'transitionResolution': transitionResolution,
      'delay': delay,
    });
    return status;
  }

  Future<GenericLevelStatusData> sendGenericLevelGet(
    int address, {
    int keyIndex = 0,
  }) async {
    final status = _onGenericLevelStatusController.stream.firstWhere(
      (element) => element.source == address,
      orElse: () => GenericLevelStatusData(-1, -1, -1, -1, -1, -1),
    );
    await _methodChannel.invokeMethod('sendGenericLevelGet', {
      'address': address,
      'keyIndex': keyIndex,
    });
    return status;
  }

  Future<GenericOnOffStatusData> sendGenericOnOffSet(
    int address,
    bool value,
    int sequenceNumber, {
    int keyIndex = 0,
    int transitionStep = 0,
    int transitionResolution = 0,
    int delay = 0,
  }) async {
    final status = _onGenericOnOffStatusController.stream.firstWhere(
      (element) => element.source == address && element.presentState == value,
      orElse: () => GenericOnOffStatusData(-1, false, false, -1, -1),
    );
    await _methodChannel.invokeMethod('sendGenericOnOffSet', {
      'address': address,
      'value': value,
      'sequenceNumber': sequenceNumber,
      'keyIndex': keyIndex,
      'transitionStep': transitionStep,
      'transitionResolution': transitionResolution,
      'delay': delay,
    });
    return status;
  }

  Future<MagicLevelSetStatusData> sendV2MagicLevelSet(
    int address,
    int io,
    int index,
    int value,
    int correlation, {
    int keyIndex = 0,
  }) async {
    if (Platform.isAndroid) {
      final status = _onV2MagicLevelSetStatusController.stream.firstWhere(
        (element) => element.source == address,
        orElse: () => MagicLevelSetStatusData(-1, -1, -1, -1, -1, -1),
      );
      await _methodChannel.invokeMethod('sendV2MagicLevel', {
        'io': io,
        'index': index,
        'value': value,
        'correlation': correlation,
        'address': address,
        'keyIndex': keyIndex,
      });
      return status;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  Future<MagicLevelGetStatusData> sendV2MagicLevelGet(
    int address,
    int io,
    int index,
    int correlation, {
    int keyIndex = 0,
  }) async {
    if (Platform.isAndroid) {
      final status = _onV2MagicLevelGetStatusController.stream.firstWhere(
        (element) => element.source == address,
        orElse: () => MagicLevelGetStatusData(-1, -1, -1, -1, -1, -1),
      );
      await _methodChannel.invokeMethod('getV2MagicLevel', {
        'io': io,
        'index': index,
        'correlation': correlation,
        'address': address,
        'keyIndex': keyIndex,
      });
      return status;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  Future<void> sendConfigCompositionDataGet(int dest) =>
      _methodChannel.invokeMethod('sendConfigCompositionDataGet', {'dest': dest});

  Future<void> sendConfigAppKeyAdd(int dest) => _methodChannel.invokeMethod('sendConfigAppKeyAdd', {'dest': dest});

  Future<ConfigModelAppStatusData> sendConfigModelAppBind(int nodeId, int elementId, int modelId,
      {int appKeyIndex = 0}) async {
    final status = _onConfigModelAppStatusController.stream.firstWhere(
      (element) =>
          element.elementAddress == elementId && element.modelId == modelId && element.appKeyIndex == appKeyIndex,
      orElse: () => ConfigModelAppStatusData(-1, -1, -1),
    );
    await _methodChannel.invokeMethod('sendConfigModelAppBind', {
      'nodeId': nodeId,
      'elementId': elementId,
      'modelId': modelId,
      'appKeyIndex': appKeyIndex,
    });
    return status;
  }

  Future<ConfigModelSubscriptionStatus> sendConfigModelSubscriptionAdd(
      int elementAddress, int subscriptionAddress, int modelIdentifier) async {
    final status = _onConfigModelSubscriptionStatusController.stream.firstWhere(
      (element) =>
          element.elementAddress == elementAddress &&
          element.modelIdentifier == modelIdentifier &&
          element.subscriptionAddress == subscriptionAddress,
      orElse: () => ConfigModelSubscriptionStatus(-1, -1, -1, -1, -1, false),
    );
    await _methodChannel.invokeMethod('sendConfigModelSubscriptionAdd', {
      'elementAddress': elementAddress,
      'subscriptionAddress': subscriptionAddress,
      'modelIdentifier': modelIdentifier,
    });
    return status;
  }

  Future<ConfigModelSubscriptionStatus> sendConfigModelSubscriptionDelete(
      int elementAddress, int subscriptionAddress, int modelIdentifier) async {
    final status = _onConfigModelSubscriptionStatusController.stream.firstWhere(
      (element) =>
          element.elementAddress == elementAddress &&
          element.modelIdentifier == modelIdentifier &&
          element.subscriptionAddress == subscriptionAddress,
      orElse: () => ConfigModelSubscriptionStatus(-1, -1, -1, -1, -1, false),
    );
    await _methodChannel.invokeMethod('sendConfigModelSubscriptionDelete', {
      'elementAddress': elementAddress,
      'subscriptionAddress': subscriptionAddress,
      'modelIdentifier': modelIdentifier,
    });
    return status;
  }

  Future<void> sendConfigModelSubscriptionDeleteAll(int elementAddress, int modelIdentifier) =>
      _methodChannel.invokeMethod(
        'sendConfigModelSubscriptionDeleteAll',
        {
          'elementAddress': elementAddress,
          'modelIdentifier': modelIdentifier,
        },
      );

  Future<ConfigModelPublicationStatus> sendConfigModelPublicationSet(
    int elementAddress,
    int publishAddress,
    int modelIdentifier, {
    int appKeyIndex = 0,
    bool credentialFlag = false,
    int publishTtl = 15,
    int publicationSteps = 0,
    int publicationResolution = 100,
    int retransmitCount = 0,
    int retransmitIntervalSteps = 0,
  }) async {
    final status = _onConfigModelPublicationStatusController.stream.firstWhere(
      (element) =>
          element.elementAddress == elementAddress &&
          element.publishAddress == publishAddress &&
          element.appKeyIndex == appKeyIndex &&
          element.credentialFlag == credentialFlag &&
          element.publishTtl == publishTtl &&
          element.publicationSteps == publicationSteps &&
          element.publicationResolution == publicationResolution &&
          element.retransmitCount == retransmitCount &&
          element.retransmitIntervalSteps == retransmitIntervalSteps &&
          element.modelIdentifier == modelIdentifier,
      orElse: () => ConfigModelPublicationStatus(-1, -1, -1, false, -1, -1, -1, -1, -1, -1, false),
    );
    await _methodChannel.invokeMethod('sendConfigModelPublicationSet', {
      'elementAddress': elementAddress,
      'publishAddress': publishAddress,
      'appKeyIndex': appKeyIndex,
      'credentialFlag': credentialFlag,
      'publishTtl': publishTtl,
      'publicationSteps': publicationSteps,
      'publicationResolution': publicationResolution,
      'retransmitCount': retransmitCount,
      'retransmitIntervalSteps': retransmitIntervalSteps,
      'modelIdentifier': modelIdentifier,
    });
    return status;
  }

  Future<LightLightnessStatusData> sendLightLightness(
    int address,
    int lightness,
    int sequenceNumber, {
    int keyIndex = 0,
  }) async {
    if (Platform.isAndroid) {
      final status = _onLightLightnessStatusController.stream.firstWhere(
        (element) => element.source == address,
        orElse: () => LightLightnessStatusData(-1, -1, -1, -1, -1, -1),
      );
      await _methodChannel.invokeMethod('sendLightLightness', {
        'address': address,
        'lightness': lightness,
        'sequenceNumber': sequenceNumber,
        'keyIndex': keyIndex,
      });
      return status;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  Future<LightCtlStatusData> sendLightCtl(
    int address,
    int lightness,
    int temperature,
    int lightDeltaUV,
    int sequenceNumber, {
    int keyIndex = 0,
  }) async {
    if (Platform.isAndroid) {
      final status = _onLightCtlStatusController.stream.firstWhere(
        (element) => element.source == address,
        orElse: () => LightCtlStatusData(-1, -1, -1, -1, -1, -1, -1, -1),
      );
      await _methodChannel.invokeMethod('sendLightCtl', {
        'address': address,
        'lightness': lightness,
        'temperature': temperature,
        'lightDeltaUV': lightDeltaUV,
        'sequenceNumber': sequenceNumber,
        'keyIndex': keyIndex,
      });
      return status;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  Future<LightHslStatusData> sendLightHsl(
    int address,
    int lightness,
    int hue,
    int saturation,
    int sequenceNumber, {
    int keyIndex = 0,
  }) async {
    if (Platform.isAndroid) {
      final status = _onLightHslStatusController.stream.firstWhere(
        (element) => element.source == address,
        orElse: () => LightHslStatusData(-1, -1, -1, -1, -1, -1, -1),
      );
      await _methodChannel.invokeMethod('sendLightHsl', {
        'address': address,
        'lightness': lightness,
        'hue': hue,
        'saturation': saturation,
        'sequenceNumber': sequenceNumber,
        'keyIndex': keyIndex,
      });
      return status;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  Future<ConfigDefaultTtlStatus> getDefaultTtl(int address) async {
    final status = _onConfigDefaultTtlStatusController.stream.firstWhere(
      (element) => element.source == address,
      orElse: () => ConfigDefaultTtlStatus(-1, -1, -1),
    );
    await _methodChannel.invokeMethod('getDefaultTtl', {'address': address});
    return status;
  }

  Future<ConfigDefaultTtlStatus> setDefaultTtl(int address, int ttl) async {
    final status = _onConfigDefaultTtlStatusController.stream.firstWhere(
      (element) => element.source == address,
      orElse: () => ConfigDefaultTtlStatus(-1, -1, -1),
    );
    await _methodChannel.invokeMethod('setDefaultTtl', {
      'address': address,
      'ttl': ttl,
    });
    return status;
  }

  Future<ConfigNetworkTransmitStatus> setNetworkTransmitSettings(
    int address,
    int transmitCount,
    int transmitIntervalSteps,
  ) async {
    final status = _onConfigNetworkTransmitStatusController.stream.firstWhere(
      (element) => element.source == address,
      orElse: () => ConfigNetworkTransmitStatus(-1, -1, -1, -1),
    );
    await _methodChannel.invokeMethod('setNetworkTransmitSettings', {
      'address': address,
      'transmitCount': transmitCount,
      'transmitIntervalSteps': transmitIntervalSteps,
    });
    return status;
  }

  Future<ConfigNetworkTransmitStatus> getNetworkTransmitSettings(int address) async {
    final status = _onConfigNetworkTransmitStatusController.stream.firstWhere(
      (element) => element.source == address,
      orElse: () => ConfigNetworkTransmitStatus(-1, -1, -1, -1),
    );
    await _methodChannel.invokeMethod('getNetworkTransmitSettings', {'address': address});
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

  Future<ConfigNodeResetStatus> deprovision(ProvisionedMeshNode meshNode) async {
    if (Platform.isAndroid) {
      final unicastAddress = await meshNode.unicastAddress;
      final status = _onConfigNodeResetStatusController.stream
          .where((element) => element.source == unicastAddress)
          .timeout(const Duration(seconds: 3),
              onTimeout: (sink) => sink.add(
                    ConfigNodeResetStatus(-1, -1, false),
                  ))
          .first;
      await _methodChannel.invokeMethod('deprovision', {'unicastAddress': unicastAddress});
      return status;
    } else {
      throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
    }
  }

  Future<String?> cachedProvisionedMeshNodeUuid() => _methodChannel.invokeMethod('cachedProvisionedMeshNodeUuid');

  Future<int> getSequenceNumber(ProvisionedMeshNode node) async {
    if (Platform.isIOS || Platform.isAndroid) {
      final result = await _methodChannel.invokeMethod<int>(
        'getSequenceNumberForAddress',
        {'address': await node.unicastAddress},
      );
      return result!;
    }
    throw Exception('Platform not supported');
  }

  Future<void> setSequenceNumber(ProvisionedMeshNode node, int seqNum) async => _methodChannel.invokeMethod<void>(
        'setSequenceNumberForAddress',
        {'address': await node.unicastAddress, 'sequenceNumber': seqNum},
      );

  String _digits(int val, int digits) {
    var hi = 1 << (digits * 4);
    return (hi | (val & (hi - 1))).toRadixString(16).substring(1);
  }

  Stream<Map<String, dynamic>> _filterEventChannel(final MeshManagerApiEvent eventType) =>
      _eventChannelStream.where((event) => event['eventName'] == eventType.value);

  Stream<MeshNetwork> _onMeshNetworkEventSucceed(final MeshManagerApiEvent eventType) =>
      _filterEventChannel(eventType).map((event) => MeshNetworkEventData.fromJson(event)).map((event) {
        if (eventType == MeshManagerApiEvent.updated) {
          return _lastMeshNetwork!;
        }
        return MeshNetwork(event.id);
      }).doOnData((event) => _lastMeshNetwork = event);

  Stream<MeshNetworkEventError> _onMeshNetworkEventFailed(final MeshManagerApiEvent eventType) =>
      _filterEventChannel(eventType).map((event) => MeshNetworkEventError.fromJson(event));
}
