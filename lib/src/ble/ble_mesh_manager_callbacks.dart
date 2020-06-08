import 'package:flutter_blue/flutter_blue.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_manager_callbacks.dart';

abstract class _BleMeshManagerCallbacksEvent {
  final BluetoothDevice device;
  final int mtu;
  final List<int> pdu;

  const _BleMeshManagerCallbacksEvent(this.device, this.mtu, this.pdu);
}

class BleMeshManagerCallbacksDataReceived extends _BleMeshManagerCallbacksEvent {
  const BleMeshManagerCallbacksDataReceived(BluetoothDevice device, int mtu, List<int> pdu) : super(device, mtu, pdu);
}

class BleMeshManagerCallbacksDataSent extends _BleMeshManagerCallbacksEvent {
  const BleMeshManagerCallbacksDataSent(BluetoothDevice device, int mtu, List<int> pdu) : super(device, mtu, pdu);
}

abstract class BleMeshManagerCallbacks extends BleManagerCallbacks {
  Stream<BleMeshManagerCallbacksDataReceived> onDataReceived;

  Stream<BleMeshManagerCallbacksDataReceived> onDataSent;
}
