import 'package:nordic_nrf_mesh/src/ble/ble_manager_callbacks.dart';

class BleManager<E extends BleManagerCallbacks> {
  E _callbacks;

  set callbacks(E callback) => _callbacks = callback;
}
