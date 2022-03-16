import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

/// {@template discovered_device_and_service}
/// A data class used to hold a [DiscoveredDevice] and the corresponding BLE Mesh service
/// {@endtemplate}
class BleManagerCallbacksDiscoveredServices {
  final DiscoveredDevice device;
  final DiscoveredService service;

  /// {@macro discovered_device_and_service}
  const BleManagerCallbacksDiscoveredServices(this.device, this.service);
}

/// {@template ble_error}
/// An error class use for propagating BLE errors
/// {@endtemplate}
class BleManagerCallbacksError {
  final DiscoveredDevice? device;
  final String message;
  final Object? error;

  /// {@macro ble_error}
  const BleManagerCallbacksError(this.device, this.message, this.error);

  @override
  String toString() => 'BleManagerCallbacksError(message: $message, '
      'error: $error, '
      'device id: ${device?.id}, '
      'device name: ${device?.name})';
}

/// An abstract class that should be extended to access callbacks during BLE device interactions
abstract class BleManagerCallbacks {
  /// The [StreamController] that is used to trigger an event when a device is connecting
  final onDeviceConnectingController = StreamController<ConnectionStateUpdate>();

  /// The [Stream] that will contain the `connecting` event
  Stream<ConnectionStateUpdate> get onDeviceConnecting => onDeviceConnectingController.stream;

  /// The [StreamController] that is used to trigger an event when a device is connected
  final onDeviceConnectedController = StreamController<ConnectionStateUpdate>();

  /// The [Stream] that will contain the `connected` event
  Stream<ConnectionStateUpdate> get onDeviceConnected => onDeviceConnectedController.stream;

  /// The [StreamController] that is used to trigger an event when a device is disconnecting
  final onDeviceDisconnectingController = StreamController<ConnectionStateUpdate>();

  /// The [Stream] that will contain the `disconnecting` event
  Stream<ConnectionStateUpdate> get onDeviceDisconnecting => onDeviceDisconnectingController.stream;

  /// The [StreamController] that is used to trigger an event when a device is disconnected
  final onDeviceDisconnectedController = StreamController<ConnectionStateUpdate>();

  /// The [Stream] that will contain the `disconnected` event
  Stream<ConnectionStateUpdate> get onDeviceDisconnected => onDeviceDisconnectedController.stream;

  /// The [StreamController] that is used to trigger an event when BLE services are validated upon connection
  final onServicesDiscoveredController = StreamController<BleManagerCallbacksDiscoveredServices>();

  /// The [Stream] that will contain a [BleManagerCallbacksDiscoveredServices] object when BLE services are validated upon connection
  Stream<BleManagerCallbacksDiscoveredServices> get onServicesDiscovered => onServicesDiscoveredController.stream;

  /// The [StreamController] that is used to trigger an event when the phone is ready to interact with target BLE device
  final onDeviceReadyController = StreamController<DiscoveredDevice>();

  /// The [Stream] that will contain an event when the phone is ready to interact with target BLE device
  Stream<DiscoveredDevice> get onDeviceReady => onDeviceReadyController.stream;

  /// The [StreamController] that is used to trigger an event when an error occur during connection lifetime
  final onErrorController = StreamController<BleManagerCallbacksError>();

  /// The [Stream] that will contain any [BleManagerCallbacksError] that could occur during connection lifetime
  Stream<BleManagerCallbacksError> get onError => onErrorController.stream;

  /// A method that should be used to update the stored MTU so the native code properly constructs the PDUs
  Future<void> sendMtuToMeshManagerApi(int mtu);

  /// RFU
  bool shouldEnableBatteryLevelNotifications(DiscoveredDevice device) => false;

  /// Will clear the used resources
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
