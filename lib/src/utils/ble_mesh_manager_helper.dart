import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager_callbacks.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager_callbacks.dart';
import 'package:nordic_nrf_mesh/src/mesh_manager_api.dart';
import 'package:nordic_nrf_mesh/src/provisioned_mesh_node.dart';
import 'package:nordic_nrf_mesh/src/unprovisioned_mesh_node.dart';

class _ProvisioningEvent {
  final _provisioningController = StreamController<void>();
  final _provisioningCapabilitiesController = StreamController<void>();
  final _provisioningInvitationController = StreamController<void>();
  final _provisioningReconnectController = StreamController<void>();
  final _onConfigCompositionDataStatusController = StreamController<void>();
  final _onConfigAppKeyStatusController = StreamController<void>();
}

class ProvisioningEvent extends _ProvisioningEvent {
  Stream<void> get onProvisioning => _provisioningController.stream;
  Stream<void> get onProvisioningCapabilities => _provisioningCapabilitiesController.stream;
  Stream<void> get onProvisioningInvitation => _provisioningInvitationController.stream;
  Stream<void> get onProvisioningReconnect => _provisioningReconnectController.stream;
  Stream<void> get onConfigCompositionDataStatus => _onConfigCompositionDataStatusController.stream;
  Stream<void> get onConfigAppKeyStatus => _onConfigAppKeyStatusController.stream;

  Future<void> dispose() => Future.wait([
        _provisioningController.close(),
        _provisioningCapabilitiesController.close(),
        _provisioningInvitationController.close(),
        _provisioningReconnectController.close(),
        _onConfigCompositionDataStatusController.close(),
        _onConfigAppKeyStatusController.close(),
      ]);
}

class BleMeshManagerHelper {
  static BleMeshManagerHelper _bleMeshManagerHelper;

  final bleMeshManager = BleMeshManager();

  MeshManagerApi _meshManagerApi;

  StreamSubscription<BluetoothDevice> _onDeviceConnectingSubscription;
  StreamSubscription<BluetoothDevice> _onDeviceConnectedSubscription;
  StreamSubscription<BleManagerCallbacksDiscoveredServices> _onServicesDiscoveredSubscription;
  StreamSubscription<BluetoothDevice> _onDeviceReadySubscription;
  StreamSubscription<BleMeshManagerCallbacksDataReceived> _onDataReceivedSubscription;
  StreamSubscription<BleMeshManagerCallbacksDataSent> _onDataSentSubscription;
  StreamSubscription<BluetoothDevice> _onDeviceDisconnectingSubscription;
  StreamSubscription<BluetoothDevice> _onDeviceDisconnectedSubscription;
  StreamSubscription<List<int>> _onMeshPduCreatedSubscription;

  bool isProvisioning = true;
  String serviceDataUuid;

  factory BleMeshManagerHelper(MeshManagerApi meshManagerApi) {
    return _bleMeshManagerHelper ??= BleMeshManagerHelper._(meshManagerApi);
  }

  BleMeshManagerHelper._(this._meshManagerApi) {
    bleMeshManager.callbacks = _DoozBleMeshManagerCallbacks(_meshManagerApi);
    _onDeviceConnectingSubscription = bleMeshManager.callbacks.onDeviceConnecting.listen((event) {
      print('onDeviceConnecting $event');
    });
    _onDeviceConnectedSubscription = bleMeshManager.callbacks.onDeviceConnected.listen((event) {
      print('onDeviceConnected $event');
    });

    _onServicesDiscoveredSubscription = bleMeshManager.callbacks.onServicesDiscovered.listen((event) {
      print('onServicesDiscovered');
    });

    _onDeviceReadySubscription =
        bleMeshManager.callbacks.onDeviceReady.where((event) => isProvisioning).listen((event) async {
      print('onDeviceReady ${event.id.id} ${serviceDataUuid}');
      await _meshManagerApi.identifyNode(serviceDataUuid);
    });

    _onDataReceivedSubscription = bleMeshManager.callbacks.onDataReceived.listen((event) async {
      print('onDataReceived ${event.device.id} ${event.pdu} ${event.mtu}');
      await _meshManagerApi.handleNotifications(event.mtu, event.pdu);
    });
    _onDataSentSubscription = bleMeshManager.callbacks.onDataSent.listen((event) async {
      print('onDataSent ${event.device.id} ${event.pdu} ${event.mtu}');
      await _meshManagerApi.handleWriteCallbacks(event.mtu, event.pdu);
    });

    _onDeviceDisconnectingSubscription = bleMeshManager.callbacks.onDeviceDisconnecting.listen((event) {
      print('onDeviceDisconnecting $event');
    });
    _onDeviceDisconnectedSubscription = bleMeshManager.callbacks.onDeviceDisconnected.listen((event) {
      print('onDeviceDisconnected $event');
    });

    _onMeshPduCreatedSubscription = _meshManagerApi.onMeshPduCreated.listen((event) async {
      print('onMeshPduCreated $event');
      await bleMeshManager.sendPdu(event);
    });
  }

  Future<void> dispose() => Future.wait([
        _onDeviceConnectingSubscription.cancel(),
        _onDeviceConnectedSubscription.cancel(),
        _onServicesDiscoveredSubscription.cancel(),
        _onDeviceReadySubscription.cancel(),
        _onDataReceivedSubscription.cancel(),
        _onDataSentSubscription.cancel(),
        _onDeviceDisconnectingSubscription.cancel(),
        _onDeviceDisconnectedSubscription.cancel(),
        _onMeshPduCreatedSubscription.cancel(),
      ]);

  Future<ProvisionedMeshNode> provisioning(BluetoothDevice device, String serviceDataUuid,
      {ProvisioningEvent events}) async {
    print('serviceDataUuid $serviceDataUuid');
    if (Platform.isIOS) {
      await _meshManagerApi.provisioningIos(serviceDataUuid);
    } else if (Platform.isAndroid) {
      this.serviceDataUuid = serviceDataUuid;
      final meshNode = await _provisioningAndroid(_meshManagerApi, device, events);
      print(await device.discoverServices());
      return meshNode;
    }
    return null;
  }

  Future<ProvisionedMeshNode> _provisioningAndroid(
      MeshManagerApi meshManagerApi, BluetoothDevice device, ProvisioningEvent events) async {
    assert(
        meshManagerApi.meshNetwork != null, 'You need to load a meshNetwork before being able to provision a device');
    final completer = Completer();
    ProvisionedMeshNode provisionedMeshNode;

    final onProvisioningCompletedSubscription = meshManagerApi.onProvisioningCompleted.listen((event) async {
      print('onProvisioningCompleted $event');
      await bleMeshManager.disconnect();

      ScanResult scanResult;
      while (scanResult == null) {
        final scanResults = (await FlutterBlue.instance.startScan(withServices: [meshProxyUuid]) as List<ScanResult>);
        scanResult = scanResults.firstWhere((element) => element.device.id.id == device.id.id, orElse: () => null);
        await Future.delayed(Duration(milliseconds: 500));
      }
      if (scanResult == null) {
        completer.completeError(Exception('Didn\'t find module'));
        return;
      }

      await bleMeshManager.connect(scanResult.device);

      provisionedMeshNode = ProvisionedMeshNode(event.meshNode.uuid);
    });
    final onProvisioningStateChangedSubscription = meshManagerApi.onProvisioningStateChanged.listen((event) async {
      print('onProvisioningStateChanged $event');
      if (event.state == 'PROVISIONING_CAPABILITIES') {
        events?._provisioningCapabilitiesController?.add(null);
        var assigned = false;
        final unprovisionedMeshNode = UnprovisionedMeshNode(event.meshNode.uuid, event.meshNode.provisionerPublicKeyXY);
        final elementSize = await unprovisionedMeshNode.getNumberOfElements();
        final maxAddress = await meshManagerApi.meshNetwork.highestAllocatableAddress;

        if (elementSize == 0) {
          await meshManagerApi.cleanProvisioningData();
          completer.completeError(Exception('Provisioning is failed. Module does not have any elements.'));
          return;
        }

        var unicast = await meshManagerApi.meshNetwork.nextAvailableUnicastAddress(elementSize);
        while (!assigned && unicast < maxAddress && unicast > 0) {
          try {
            await meshManagerApi.meshNetwork.assignUnicastAddress(unicast);
            assigned = true;
          } catch (e) {
            print('Failed to assign $unicast to meshNetwork retry with ${unicast + 1}');
            unicast += 1;
          }
        }
        await unprovisionedMeshNode.setUnicastAddress(unicast);
        events?._provisioningController?.add(null);
        await meshManagerApi.provisioning(unprovisionedMeshNode);
      } else if (event.state == 'PROVISIONING_INVITE') {
        if (!bleMeshManager.isProvisioningCompleted) {
          events?._provisioningInvitationController?.add(null);
        } else if (bleMeshManager.isProvisioningCompleted) {
          events?._provisioningReconnectController?.add(null);
          final unicast = await provisionedMeshNode.unicastAddress;
          await meshManagerApi.createMeshPduForConfigCompositionDataGet(unicast);
        }
      }
    });
    final onProvisioningFailedSubscription = meshManagerApi.onProvisioningFailed.listen((event) async {
      print('onProvisioningFailed $event');
      await meshManagerApi.cleanProvisioningData();
      completer.completeError(Exception('Failed to provision device ${device.id.id}'));
    });

    final sendProvisioningPduSubscription = meshManagerApi.sendProvisioningPdu.listen((event) async {
      print('sendProvisioningPdu $event');
      await bleMeshManager.sendPdu(event.pdu);
    });

    final onConfigCompositionDataStatusSubscription =
        meshManagerApi.onConfigCompositionDataStatus.listen((event) async {
      print('onConfigCompositionDataStatus $event');
      events?._onConfigCompositionDataStatusController?.add(null);
      await meshManagerApi.createMeshPduForConfigAppKeyAdd(await provisionedMeshNode.unicastAddress);
    });
    final onConfigAppKeyStatusSubscription = meshManagerApi.onConfigAppKeyStatus.listen((event) async {
      print('onConfigAppKeyStatus $event');
      events?._onConfigAppKeyStatusController?.add(null);
      completer.complete(provisionedMeshNode);
    });

    if (bleMeshManager.connected) {
      await bleMeshManager.disconnect();
    }

    print('connect');
    await bleMeshManager.connect(device);

    try {
      return await completer.future;
    } catch (e) {
      await device.disconnect();
      rethrow;
    } finally {
      await Future.wait([
        onProvisioningCompletedSubscription.cancel(),
        onProvisioningStateChangedSubscription.cancel(),
        onProvisioningFailedSubscription.cancel(),
        sendProvisioningPduSubscription.cancel(),
        onConfigCompositionDataStatusSubscription.cancel(),
        onConfigAppKeyStatusSubscription.cancel(),
        bleMeshManager?.callbacks?.dispose(),
      ]);
    }
  }
}

class _DoozBleMeshManagerCallbacks extends BleMeshManagerCallbacks {
  final MeshManagerApi _meshManagerApi;

  _DoozBleMeshManagerCallbacks(this._meshManagerApi);

  @override
  Future<void> sendMtuToMeshManagerApi(int mtu) async => _meshManagerApi.setMtu(mtu);
}
