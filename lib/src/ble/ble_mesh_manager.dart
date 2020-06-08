import 'package:nordic_nrf_mesh/src/ble/ble_manager.dart';
import 'package:nordic_nrf_mesh/src/ble/ble_mesh_manager_callbacks.dart';

class BleMeshManager<T extends BleMeshManagerCallbacks> extends BleManager<T> {}
