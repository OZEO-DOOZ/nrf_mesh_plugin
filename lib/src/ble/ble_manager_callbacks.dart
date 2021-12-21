import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleManagerCallbacksDiscoveredServices {
  final DiscoveredDevice device;
  final DiscoveredService service;

  const BleManagerCallbacksDiscoveredServices(this.device, this.service);
}

class BleManagerCallbacksError {
  final DiscoveredDevice? device;
  final String message;
  final Object? error;

  const BleManagerCallbacksError(this.device, this.message, this.error);

  @override
  String toString() => 'BleManagerCallbacksError(message: $message, '
      'error: $error, '
      'device id: ${device?.id}, '
      'device name: ${device?.name})';
}

abstract class BleManagerCallbacks {
  final onDeviceConnectingController = StreamController<ConnectionStateUpdate>();
  Stream<ConnectionStateUpdate> get onDeviceConnecting => onDeviceConnectingController.stream;

  final onDeviceConnectedController = StreamController<ConnectionStateUpdate>();
  Stream<ConnectionStateUpdate> get onDeviceConnected => onDeviceConnectedController.stream;

  final onDeviceDisconnectingController = StreamController<ConnectionStateUpdate>();
  Stream<ConnectionStateUpdate> get onDeviceDisconnecting => onDeviceDisconnectingController.stream;

  final onDeviceDisconnectedController = StreamController<ConnectionStateUpdate>();
  Stream<ConnectionStateUpdate> get onDeviceDisconnected => onDeviceDisconnectedController.stream;

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
        onErrorController.close(),
      ]);
}
