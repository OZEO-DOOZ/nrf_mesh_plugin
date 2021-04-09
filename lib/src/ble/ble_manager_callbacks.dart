import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleManagerCallbacksDiscoveredServices {
  final DiscoveredDevice device;
  final DiscoveredService service;
  final bool optionalServicesFound;

  const BleManagerCallbacksDiscoveredServices(this.device, this.service, this.optionalServicesFound);
}

class BleManagerCallbacksError {
  final DiscoveredDevice device;
  final String message;
  final Object error;

  const BleManagerCallbacksError(this.device, this.message, this.error);
}

abstract class BleManagerCallbacks {
  final onDeviceConnectingController = StreamController<DiscoveredDevice>();
  Stream<DiscoveredDevice> get onDeviceConnecting => onDeviceConnectingController.stream;

  final onDeviceConnectedController = StreamController<DiscoveredDevice>();
  Stream<DiscoveredDevice> get onDeviceConnected => onDeviceConnectedController.stream;

  final onDeviceDisconnectingController = StreamController<DiscoveredDevice>();
  Stream<DiscoveredDevice> get onDeviceDisconnecting => onDeviceDisconnectingController.stream;

  final onDeviceDisconnectedController = StreamController<DiscoveredDevice>();
  Stream<DiscoveredDevice> get onDeviceDisconnected => onDeviceDisconnectedController.stream;

  // Stream<BluetoothDevice> onLinkLossOccurred;

  final onServicesDiscoveredController = StreamController<BleManagerCallbacksDiscoveredServices>();
  Stream<BleManagerCallbacksDiscoveredServices> get onServicesDiscovered => onServicesDiscoveredController.stream;

  final onDeviceReadyController = StreamController<DiscoveredDevice>();
  Stream<DiscoveredDevice> get onDeviceReady => onDeviceReadyController.stream;

  final onErrorController = StreamController<BleManagerCallbacksError>();
  Stream<BleManagerCallbacksError> get onError => onErrorController.stream;

  // Stream<BluetoothDevice> onDeviceNotSupported;

  Future<void> sendMtuToMeshManagerApi(int mtu);

  bool shouldEnableBatteryLevelNotifications(DiscoveredDevice device) => false;

  Future<void> dispose() => Future.wait([
        onDeviceConnectingController.close(),
        onDeviceConnectedController.close(),
        onDeviceDisconnectingController.close(),
        onDeviceDisconnectedController.close(),
        onServicesDiscoveredController.close(),
        onDeviceReadyController.close(),
      ]);
}
