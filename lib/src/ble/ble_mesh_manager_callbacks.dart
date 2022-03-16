import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager_callbacks.dart';

/// {@template ble_data_event}
/// An abstract data class that should be extended to hold the in/out data of the current BLE connection
/// {@endtemplate}
abstract class _BleMeshManagerCallbacksEvent {
  /// The currently connected device
  final DiscoveredDevice device;

  /// The currently used MTU size
  final int mtu;

  /// The PDU of this in/out event
  final List<int> pdu;

  /// {@macro ble_data_event}
  const _BleMeshManagerCallbacksEvent(this.device, this.mtu, this.pdu);

  @override
  String toString() => '$device, $mtu, $pdu';
}

/// {@template ble_data_received}
/// A data class used when some PDU is received
/// {@endtemplate}
class BleMeshManagerCallbacksDataReceived extends _BleMeshManagerCallbacksEvent {
  /// {@macro ble_data_received}
  const BleMeshManagerCallbacksDataReceived(DiscoveredDevice device, int mtu, List<int> pdu) : super(device, mtu, pdu);

  @override
  String toString() => 'BleMeshManagerCallbacksDataReceived{ ${super.toString()} }';
}

/// {@template ble_data_sent}
/// A data class used when some PDU is sent
/// {@endtemplate}
class BleMeshManagerCallbacksDataSent extends _BleMeshManagerCallbacksEvent {
  /// {@macro ble_data_sent}
  const BleMeshManagerCallbacksDataSent(DiscoveredDevice device, int mtu, List<int> pdu) : super(device, mtu, pdu);

  @override
  String toString() => 'BleMeshManagerCallbacksDataSent{ ${super.toString()} }';
}

/// An abstract class that should be extended to access callbacks during BLE device interactions
abstract class BleMeshManagerCallbacks extends BleManagerCallbacks {
  /// The [StreamController] that is used to trigger an event when some data is received while connected to a BLE device
  final onDataReceivedController = StreamController<BleMeshManagerCallbacksDataReceived>();

  /// The [Stream] that will contain any data received while connected to a BLE device
  Stream<BleMeshManagerCallbacksDataReceived> get onDataReceived => onDataReceivedController.stream;

  /// The [StreamController] that is used to trigger an event when some data is sent to the connected BLE device
  final onDataSentController = StreamController<BleMeshManagerCallbacksDataSent>();

  /// The [Stream] that will contain any data sent to the connected BLE device
  Stream<BleMeshManagerCallbacksDataSent> get onDataSent => onDataSentController.stream;

  @override
  Future<void> dispose() => Future.wait([
        onDataReceivedController.close(),
        onDataSentController.close(),
        super.dispose(),
      ]);
}
