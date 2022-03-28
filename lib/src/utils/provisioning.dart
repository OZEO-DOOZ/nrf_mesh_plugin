import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_scanner.dart';

/// {@template provisioning_events}
/// A class that may be used to listen to provisioning progress.
///
/// When the provisioning method is running, if the caller passed a [ProvisioningEvent] instance, events will be streamed to notify about the current state.
/// {@endtemplate}
class ProvisioningEvent {
  /// A [Stream] that will contain the [DiscoveredDevice] when the main part of the provisioning is about to begin
  Stream<DiscoveredDevice> get onProvisioning => _provisioningController.stream;
  final _provisioningController = StreamController<DiscoveredDevice>();

  /// A [Stream] that will contain the [DiscoveredDevice] when the provisioning capabilities have been received
  Stream<DiscoveredDevice> get onProvisioningCapabilities => _provisioningCapabilitiesController.stream;
  final _provisioningCapabilitiesController = StreamController<DiscoveredDevice>();

  /// A [Stream] that will contain the [DiscoveredDevice] when the provisioning invite has been sent
  Stream<DiscoveredDevice> get onProvisioningInvitation => _provisioningInvitationController.stream;
  final _provisioningInvitationController = StreamController<DiscoveredDevice>();

  /// A [Stream] that will contain the [DiscoveredDevice] when provisioning is completed and we try to reconnect to the new node
  Stream<DiscoveredDevice> get onProvisioningReconnect => _provisioningReconnectController.stream;
  final _provisioningReconnectController = StreamController<DiscoveredDevice>();

  /// A [Stream] that will contain the [DiscoveredDevice] when the mesh composition data has been received
  Stream<DiscoveredDevice> get onConfigCompositionDataStatus => _onConfigCompositionDataStatusController.stream;
  final _onConfigCompositionDataStatusController = StreamController<DiscoveredDevice>();

  /// A [Stream] that will contain the [DiscoveredDevice] when the app key has been received by the new node
  Stream<DiscoveredDevice> get onConfigAppKeyStatus => _onConfigAppKeyStatusController.stream;
  final _onConfigAppKeyStatusController = StreamController<DiscoveredDevice>();

  /// A [Stream] that will contain a [BleManagerCallbacksError] (unexpected error that should be handled by plugin user)
  Stream<BleManagerCallbacksError> get onProvisioningGattError => _provisioningGattErrorController.stream;
  final _provisioningGattErrorController = StreamController<BleManagerCallbacksError>();

  /// Will clear used resources
  Future<void> dispose() => Future.wait([
        _provisioningController.close(),
        _provisioningCapabilitiesController.close(),
        _provisioningInvitationController.close(),
        _provisioningReconnectController.close(),
        _onConfigCompositionDataStatusController.close(),
        _onConfigAppKeyStatusController.close(),
        _provisioningGattErrorController.close(),
      ]);
}

// necessary subcriptions to handle the whole provisioning process
StreamSubscription? _onBleScannerError;
StreamSubscription? _onProvisioningCompletedSubscription;
StreamSubscription? _onProvisioningStateChangedSubscription;
StreamSubscription? _onProvisioningFailedSubscription;
StreamSubscription? _sendProvisioningPduSubscription;
StreamSubscription? _onConfigCompositionDataStatusSubscription;
StreamSubscription? _onConfigAppKeyStatusSubscription;
StreamSubscription? _onDeviceReadySubscription;
StreamSubscription? _onDataReceivedSubscription;
StreamSubscription? _onMeshPduCreatedSubscription;
StreamSubscription? _onGattErrorSubscription;
StreamSubscription? _onDataSentSubscription;

/// {@macro provisioning}
Future<ProvisionedMeshNode> provisioning(MeshManagerApi meshManagerApi, BleMeshManager bleMeshManager,
    BleScanner bleScanner, DiscoveredDevice device, String serviceDataUuid,
    {ProvisioningEvent? events}) async {
  if (Platform.isIOS || Platform.isAndroid) {
    return _provisioning(meshManagerApi, bleMeshManager, bleScanner, device, serviceDataUuid, events);
  } else {
    throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
  }
}

/// {@macro provisioning}
Future<ProvisionedMeshNode> _provisioning(
    MeshManagerApi meshManagerApi,
    BleMeshManager bleMeshManager,
    BleScanner bleScanner,
    DiscoveredDevice deviceToProvision,
    String serviceDataUuid,
    ProvisioningEvent? events) async {
  if (meshManagerApi.meshNetwork == null) {
    throw NrfMeshProvisioningException(ProvisioningFailureCode.meshConfiguration,
        'You need to load a meshNetwork before being able to provision a device');
  }
  // this completer will help providing a Future that corresponds to the process ending
  final completer = Completer();
  // when this boll is false, it will notify errors via _onGattErrorSubscription
  late bool isHandlingConnectErrors;
  // the node that will be returned after the provisioning process ends
  late final ProvisionedMeshNode provisionedMeshNode;
  //'Undocumented scan throttle' error caught here
  _onBleScannerError = bleScanner.onScanErrorStream.listen((event) {
    _log('Scanner Error : ${event.error}');
  });
  // override callbacks so we can react to BLE events
  final provisioningCallbacks = BleMeshManagerProvisioningCallbacks(meshManagerApi);
  bleMeshManager.callbacks = provisioningCallbacks;
  // define listeners to handle the provisioning process asynchronously
  _onProvisioningCompletedSubscription = meshManagerApi.onProvisioningCompleted.listen((event) async {
    // upon provisioning completion, we disconnect from the device,
    // scan to check whether it advertises the proper services,
    // and then reconnect to it
    try {
      await bleMeshManager.refreshDeviceCache();
      await bleMeshManager.disconnect();
      DiscoveredDevice? device;
      var scanTries = 0;
      while (device == null && scanTries < 6) {
        scanTries++;
        _log('attempt #$scanTries to scan for ${deviceToProvision.id}');
        final scanResults = await bleScanner.provisionedNodesInRange(
          // increase in time between two scans reduces 'Undocumented scan throttle' error (on Android)
          timeoutDuration: const Duration(seconds: 5),
        );
        try {
          device = scanResults.firstWhere((device) => device.id == deviceToProvision.id);
        } on StateError catch (e) {
          _log('not found in scan results\n$e');
        }
        if (device != null) break;
        await Future.delayed(const Duration(milliseconds: 1500));
      }
      if (device == null) {
        completer.completeError(NrfMeshProvisioningException(ProvisioningFailureCode.notFound, 'Didn\'t find module'));
      }
      events?._provisioningReconnectController.add(deviceToProvision);
      try {
        _connectRetryCount = 0;
        isHandlingConnectErrors = true;
        await _connect(bleMeshManager, device!);
        isHandlingConnectErrors = false;
        provisionedMeshNode = ProvisionedMeshNode(event.meshNode!.uuid);
      } catch (e) {
        const _msg = 'Error in connection during provisioning process';
        _log('$_msg $e');
        completer.completeError(NrfMeshProvisioningException(ProvisioningFailureCode.reconnection, _msg));
      }
    } catch (e) {
      const _msg = 'unexpected error during provisioning completed listener';
      _log('$_msg $e');
      completer.completeError(NrfMeshProvisioningException(ProvisioningFailureCode.provisioningCompleted, _msg));
    }
  });
  // If provisioning failed, stop process and notify caller by throwing an error
  _onProvisioningFailedSubscription = meshManagerApi.onProvisioningFailed.listen((event) async {
    completer.completeError(NrfMeshProvisioningException(
        ProvisioningFailureCode.provisioningFailed, 'Failed to provision device ${deviceToProvision.id}'));
  });
  // define what should be done when receiving some events from the native side
  _onProvisioningStateChangedSubscription = meshManagerApi.onProvisioningStateChanged.listen((event) async {
    if (event.state == 'PROVISIONING_CAPABILITIES') {
      events?._provisioningCapabilitiesController.add(deviceToProvision);
      final unprovisionedMeshNode =
          UnprovisionedMeshNode(event.meshNode!.uuid, event.meshNode!.provisionerPublicKeyXY!);
      final elementSize = await unprovisionedMeshNode.getNumberOfElements();
      if (elementSize == 0) {
        completer.completeError(NrfMeshProvisioningException(
            ProvisioningFailureCode.nodeComposition, 'Provisioning is failed. Module does not have any elements.'));
        return;
      }
      if (Platform.isAndroid) {
        var assigned = false;
        final meshnw = meshManagerApi.meshNetwork!;
        final maxAddress = await meshnw.highestAllocatableAddress;
        var unicast = await meshnw.nextAvailableUnicastAddress(elementSize);
        while (!assigned && unicast < maxAddress && unicast > 0) {
          try {
            await meshnw.assignUnicastAddress(unicast);
            assigned = true;
          } catch (e) {
            unicast += 1;
            _log('error, incrementing unicast to $unicast');
            _log('$e');
          }
        }
        _log('successfully assigned $unicast to node !');
      }
      events?._provisioningController.add(deviceToProvision);
      await meshManagerApi.provisioning(unprovisionedMeshNode);
    } else if (event.state == 'PROVISIONING_INVITE') {
      if (!bleMeshManager.isProvisioningCompleted) {
        events?._provisioningInvitationController.add(deviceToProvision);
      } else if (bleMeshManager.isProvisioningCompleted) {
        final unicast = await provisionedMeshNode.unicastAddress;
        await meshManagerApi.sendConfigCompositionDataGet(unicast);
      }
    }
  });
  // when connected to device, need to identify it in order to start the provisioning process
  _onDeviceReadySubscription = bleMeshManager.callbacks!.onDeviceReady.listen((event) async {
    if (Platform.isIOS && bleMeshManager.isProvisioningCompleted) {
      // this case is here because the 'PROVISIONING_INVITE' is not on iOS native code (for now?)
      final unicast = await provisionedMeshNode.unicastAddress;
      await meshManagerApi.sendConfigCompositionDataGet(unicast);
    } else {
      await meshManagerApi.identifyNode(serviceDataUuid);
    }
  });
  // handle sending PDUs
  _sendProvisioningPduSubscription = meshManagerApi.sendProvisioningPdu.listen((event) async {
    await bleMeshManager.sendPdu(event.pdu);
  });
  _onMeshPduCreatedSubscription = meshManagerApi.onMeshPduCreated.listen((event) async {
    await bleMeshManager.sendPdu(event);
  });
  if (Platform.isAndroid) {
    // on Android need to call Nordic Semiconductor's library to handle sent data parsing
    _onDataSentSubscription = bleMeshManager.callbacks!.onDataSent.listen((event) async {
      await meshManagerApi.handleWriteCallbacks(event.mtu, event.pdu);
    });
  }
  // handle received data parsing
  _onDataReceivedSubscription = bleMeshManager.callbacks!.onDataReceived.listen((event) async {
    await meshManagerApi.handleNotifications(event.mtu, event.pdu);
  });
  // will notify call and stop process in case of unexpected GATT error
  _onGattErrorSubscription = bleMeshManager.callbacks!.onError.listen((event) {
    _log('received error event : $event');
    if (!isHandlingConnectErrors) {
      // if not in a connection phase where auto retry are implemented, we should notify gatt errors
      events?._provisioningGattErrorController.add(event);
      if (!completer.isCompleted) {
        completer.completeError(
          NrfMeshProvisioningException(
            ProvisioningFailureCode.unexpectedGattError,
            'received a gatt error event outside connection phases',
          ),
        );
      }
    }
  });
  // when we received the mesh composition data from the newly provisioned node, we should bind to the network using ConfigAppKey msg
  _onConfigCompositionDataStatusSubscription = meshManagerApi.onConfigCompositionDataStatus.listen((event) async {
    events?._onConfigCompositionDataStatusController.add(deviceToProvision);
    await meshManagerApi.sendConfigAppKeyAdd(await provisionedMeshNode.unicastAddress);
  });
  // when ConfigAppKey has been received, the provisioning is successful !
  _onConfigAppKeyStatusSubscription = meshManagerApi.onConfigAppKeyStatus.listen((event) async {
    events?._onConfigAppKeyStatusController.add(deviceToProvision);
    completer.complete(provisionedMeshNode);
  });
  try {
    // disconnect from device if any
    await bleMeshManager.refreshDeviceCache();
    await bleMeshManager.disconnect();
    // auto retry connect to the target device
    _connectRetryCount = 0;
    isHandlingConnectErrors = true;
    await _connect(bleMeshManager, deviceToProvision);
    isHandlingConnectErrors = false;
    // wait for listeners to do their job
    await completer.future;
    // cleanup resources
    await meshManagerApi.cleanProvisioningData();
    await bleMeshManager.refreshDeviceCache();
    await bleMeshManager.disconnect();
    _cancelProvisioningCallbackSubscription(bleMeshManager);
    _log('provisioning success !');
    return provisionedMeshNode;
  } catch (e) {
    _log('caught error during provisioning... $e');
    // need to clean up data/resources and properly cancel the provisioning process
    await cancelProvisioning(meshManagerApi, bleScanner, bleMeshManager);
    // depending on the error, always try to throw a NrfMeshProvisioningException to ease downstream error handling
    if (e is NrfMeshProvisioningException) {
      rethrow;
    } else if (e is GenericFailure || e is BleManagerException || e is TimeoutException) {
      String? message;
      if (e is GenericFailure) {
        message = e.message;
      } else if (e is BleManagerException) {
        message = e.message;
      } else if (e is TimeoutException) {
        message = e.message;
      }
      throw NrfMeshProvisioningException(ProvisioningFailureCode.initialConnection, message);
    } else {
      // unknown error that should be diagnosed (please file an issue)
      throw NrfMeshProvisioningException(ProvisioningFailureCode.unknown, '$e');
    }
  }
}

late int _connectRetryCount;

/// A method to handle the connections.
/// It may auto retry depending on the failures that could occur.
Future<void> _connect(BleMeshManager bleMeshManager, DiscoveredDevice deviceToConnect) async {
  _connectRetryCount++;
  await bleMeshManager
      .connect(deviceToConnect, connectionTimeout: const Duration(seconds: 10))
      .catchError((e) async => await _onConnectError(e, bleMeshManager, deviceToConnect));
}

/// The method that implements the error handling for BLE connection.
///
/// Some errors can be overcome by a simple retry,
/// others are considered unhandled and this method will rethrow them.
Future<void> _onConnectError(Object e, BleMeshManager bleMeshManager, DiscoveredDevice deviceToConnect) async {
  _log('caught error during connect $e');
  if (e is GenericFailure) {
    if (_connectRetryCount < 3 &&
        e.code == ConnectionError.failedToConnect &&
        e.message.contains('status') &&
        e.message.contains('133')) {
      _log('will retry to connect after $_connectRetryCount tries');
      await Future.delayed(const Duration(milliseconds: 500));
      await _connect(bleMeshManager, deviceToConnect);
    } else {
      _log(_connectRetryCount >= 3
          ? 'connect to ${deviceToConnect.id} failed after $_connectRetryCount tries'
          : 'unhandled GenericFailure $e');
      throw e;
    }
  } else if (e is BleManagerException) {
    if (_connectRetryCount < 3 &&
        e.code != BleManagerFailureCode.callbacks &&
        e.code != BleManagerFailureCode.proxyWhitelist &&
        e.code != BleManagerFailureCode.doozServiceNotFound) {
      _log('will retry to connect after $_connectRetryCount tries');
      await Future.delayed(const Duration(milliseconds: 500));
      await _connect(bleMeshManager, deviceToConnect);
    } else {
      _log(_connectRetryCount >= 3
          ? 'connect to ${deviceToConnect.id} failed after $_connectRetryCount tries'
          : 'unhandled BleManagerException $e');
      throw e;
    }
  } else if (e is TimeoutException) {
    if (_connectRetryCount < 2) {
      _log('timeout ! will retry to connect after $_connectRetryCount tries');
      await _connect(bleMeshManager, deviceToConnect);
    } else {
      _log('connect to ${deviceToConnect.id} failed after $_connectRetryCount tries');
      throw e;
    }
  } else if (e is Exception && e.toString().contains('GenericFailure<CharacteristicValueUpdateError>')) {
    if (_connectRetryCount < 3) {
      _log('will retry to connect after $_connectRetryCount tries');
      await Future.delayed(const Duration(milliseconds: 500));
      await _connect(bleMeshManager, deviceToConnect);
    } else {
      _log('connect to ${deviceToConnect.id} failed after $_connectRetryCount tries');
      throw e;
    }
  } else {
    _log('unhandled error $e');
    throw e;
  }
}

/// Will clear stream subscriptions used for the provisioning process
void _cancelProvisioningCallbackSubscription(BleMeshManager bleMeshManager) {
  _onProvisioningCompletedSubscription?.cancel();
  _onProvisioningStateChangedSubscription?.cancel();
  _onProvisioningFailedSubscription?.cancel();
  _sendProvisioningPduSubscription?.cancel();
  _onConfigCompositionDataStatusSubscription?.cancel();
  _onConfigAppKeyStatusSubscription?.cancel();
  _onDeviceReadySubscription?.cancel();
  _onDataReceivedSubscription?.cancel();
  _onMeshPduCreatedSubscription?.cancel();
  _onGattErrorSubscription?.cancel();
  _onBleScannerError?.cancel();
  if (Platform.isAndroid) _onDataSentSubscription?.cancel();
  if (bleMeshManager.callbacks != null) bleMeshManager.callbacks!.dispose();
}

/// {@macro cancel_provisioning}
Future<bool> cancelProvisioning(
    MeshManagerApi meshManagerApi, BleScanner bleScanner, BleMeshManager bleMeshManager) async {
  if (Platform.isIOS || Platform.isAndroid) {
    _log('should cancel provisioning');
    // try to dispose any resources used by provisioning process
    try {
      bleScanner.dispose();
      final cachedProvisionedMeshNodeUuid = await meshManagerApi.cachedProvisionedMeshNodeUuid();
      if (bleMeshManager.isProvisioningCompleted && cachedProvisionedMeshNodeUuid != null) {
        // a node has been added to the network, but we want to cancel

        // get the unwanted node
        final nodes = await meshManagerApi.meshNetwork!.nodes;
        ProvisionedMeshNode? nodeToDelete;
        try {
          nodeToDelete = nodes.firstWhere((element) => element.uuid == cachedProvisionedMeshNodeUuid);
        } on StateError catch (e) {
          _log('node not found in network\n$e');
        }
        // if found, try first to send a ConfigNodeReset
        if (nodeToDelete != null) {
          final status = await meshManagerApi.deprovision(nodeToDelete);
          if (status.success == false) {
            // manually delete node from network (WARNING: the device may still be in provisioned state)
            await meshManagerApi.meshNetwork!.deleteNode(cachedProvisionedMeshNodeUuid);
          }
        }
      }
      // remove any data in native side
      await meshManagerApi.cleanProvisioningData();
      // disconnect
      await bleMeshManager.refreshDeviceCache();
      await bleMeshManager.disconnect();
      _cancelProvisioningCallbackSubscription(bleMeshManager);
      return true;
    } catch (e) {
      _log('ERROR - $e');
      return false;
    }
  } else {
    throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
  }
}

/// {@template prov_ble_manager}
/// A minimal implementation of [BleMeshManagerCallbacks]
/// {@endtemplate}
class BleMeshManagerProvisioningCallbacks extends BleMeshManagerCallbacks {
  final MeshManagerApi meshManagerApi;

  /// {@macro prov_ble_manager}
  BleMeshManagerProvisioningCallbacks(this.meshManagerApi);

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) => meshManagerApi.setMtu(mtu);
}

void _log(String msg) => debugPrint('[NordicNrfMesh] $msg');
