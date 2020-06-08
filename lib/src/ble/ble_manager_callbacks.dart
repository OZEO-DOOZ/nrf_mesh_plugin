import 'package:flutter_blue/flutter_blue.dart';

class BleManagerCallbacksDiscoveredServices {
  final BluetoothDevice device;
  final bool optionalServicesFound;

  const BleManagerCallbacksDiscoveredServices(this.device, this.optionalServicesFound);
}

class BleManagerCallbacksError {
  final BluetoothDevice device;
  final String message;
  final int code;

  const BleManagerCallbacksError(this.device, this.message, this.code);
}

abstract class BleManagerCallbacks {
  Stream<BluetoothDevice> onDeviceConnecting;

  Stream<BluetoothDevice> onDeviceConnected;

  Stream<BluetoothDevice> onDeviceDisconnecting;

  Stream<BluetoothDevice> onDeviceDisconnected;

  Stream<BluetoothDevice> onLinkLossOccurred;

  Stream<BleManagerCallbacksDiscoveredServices> onServicesDiscovered;

  Stream<BluetoothDevice> onDeviceReady;

  Stream<BleManagerCallbacksError> onError;

  Stream<BluetoothDevice> onDeviceNotSupported;

  bool shouldEnableBatteryLevelNotifications(BluetoothDevice device) => false;
}
