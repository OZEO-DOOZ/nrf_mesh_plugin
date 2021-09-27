const namespace = 'fr.dooz.nordic_nrf_mesh';

enum ProvisioningFailureCode {
  /// when an error occurs in the callback of  `PROVISIONING_COMPLETE` event
  provisioningCompleted,

  /// when the node isn't found during BLE scan upon `PROVISIONING_COMPLETE` event
  notFound,

  /// when the phone could not reconnect to node upon `PROVISIONING_COMPLETE` event
  reconnection,

  /// when the found node has unexpected node composition (nb of elements)
  nodeComposition,

  /// when `PROVISIONING_FAILED` event is triggered
  mesh,
}

enum BleManagerFailureCode {
  /// when an error occured during service discovery
  serviceNotFound,
}
