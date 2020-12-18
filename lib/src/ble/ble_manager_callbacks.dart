import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

class BleManagerCallbacksDiscoveredServices {
  final BluetoothDevice device;
  final BluetoothService service;
  final bool optionalServicesFound;

  const BleManagerCallbacksDiscoveredServices(
      this.device, this.service, this.optionalServicesFound);
}

class BleManagerCallbacksError {
  final BluetoothDevice device;
  final String message;
  final int code;

  const BleManagerCallbacksError(this.device, this.message, this.code);
}

abstract class BleManagerCallbacks {
  final onDeviceConnectingController = StreamController<BluetoothDevice>();
  Stream<BluetoothDevice> get onDeviceConnecting =>
      onDeviceConnectingController.stream;

  final onDeviceConnectedController = StreamController<BluetoothDevice>();
  Stream<BluetoothDevice> get onDeviceConnected =>
      onDeviceConnectedController.stream;

  final onDeviceDisconnectingController = StreamController<BluetoothDevice>();
  Stream<BluetoothDevice> get onDeviceDisconnecting =>
      onDeviceDisconnectingController.stream;

  final onDeviceDisconnectedController = StreamController<BluetoothDevice>();
  Stream<BluetoothDevice> get onDeviceDisconnected =>
      onDeviceDisconnectedController.stream;

  // Stream<BluetoothDevice> onLinkLossOccurred;

  final onServicesDiscoveredController =
      StreamController<BleManagerCallbacksDiscoveredServices>();
  Stream<BleManagerCallbacksDiscoveredServices> get onServicesDiscovered =>
      onServicesDiscoveredController.stream;

  final onDeviceReadyController = StreamController<BluetoothDevice>();
  Stream<BluetoothDevice> get onDeviceReady => onDeviceReadyController.stream;

  // Stream<BleManagerCallbacksError> onError;

  // Stream<BluetoothDevice> onDeviceNotSupported;

  Future<void> sendMtuToMeshManagerApi(int mtu);

  bool shouldEnableBatteryLevelNotifications(BluetoothDevice device) => false;

  Future<void> dispose() => Future.wait([
        onDeviceConnectingController.close(),
        onDeviceConnectedController.close(),
        onDeviceDisconnectingController.close(),
        onDeviceDisconnectedController.close(),
        onServicesDiscoveredController.close(),
        onDeviceReadyController.close(),
      ]);
}
