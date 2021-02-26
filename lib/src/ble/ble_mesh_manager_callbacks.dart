import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager_callbacks.dart';

abstract class _BleMeshManagerCallbacksEvent {
  final BluetoothDevice device;
  final int mtu;
  final List<int> pdu;

  const _BleMeshManagerCallbacksEvent(this.device, this.mtu, this.pdu);

  @override
  String toString() => '$device, $mtu, $pdu';
}

class BleMeshManagerCallbacksDataReceived
    extends _BleMeshManagerCallbacksEvent {
  const BleMeshManagerCallbacksDataReceived(
      BluetoothDevice device, int mtu, List<int> pdu)
      : super(device, mtu, pdu);

  @override
  String toString() =>
      'BleMeshManagerCallbacksDataReceived{ ${super.toString()} }';
}

class BleMeshManagerCallbacksDataSent extends _BleMeshManagerCallbacksEvent {
  const BleMeshManagerCallbacksDataSent(
      BluetoothDevice device, int mtu, List<int> pdu)
      : super(device, mtu, pdu);

  @override
  String toString() => 'BleMeshManagerCallbacksDataSent{ ${super.toString()} }';
}

abstract class BleMeshManagerCallbacks extends BleManagerCallbacks {
  final onDataReceivedController =
      StreamController<BleMeshManagerCallbacksDataReceived>();
  Stream<BleMeshManagerCallbacksDataReceived> get onDataReceived =>
      onDataReceivedController.stream;

  final onDataSentController =
      StreamController<BleMeshManagerCallbacksDataSent>();
  Stream<BleMeshManagerCallbacksDataSent> get onDataSent =>
      onDataSentController.stream;

  @override
  Future<void> dispose() => Future.wait([
        super.dispose(),
        onDataReceivedController.close(),
        onDataSentController.close(),
      ]);
}
