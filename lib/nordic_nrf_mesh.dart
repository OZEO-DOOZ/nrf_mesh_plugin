/// A Flutter plugin to enable mesh network management and communication using Nordic's SDKs. It also provides the ability to open BLE connection with mesh nodes using some other flutter package.
library nordic_nrf_mesh;

export 'src/nrf_mesh.dart';
export 'src/mesh_network.dart' show IMeshNetwork;
export 'src/mesh_manager_api.dart';
export 'src/events/data/event_data.dart';
export 'src/models/models.dart';
export 'src/ble/ble_manager.dart';
export 'src/ble/ble_manager_callbacks.dart';
export 'src/ble/ble_mesh_manager.dart';
export 'src/ble/ble_mesh_manager_callbacks.dart';
export 'src/utils/provisioning.dart' show ProvisioningEvent;
export 'src/constants.dart' show ProvisioningFailureCode, BleManagerFailureCode;
export 'src/exceptions/exceptions.dart';
export 'src/extensions/extensions.dart';
