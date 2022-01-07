const namespace = 'fr.dooz.nordic_nrf_mesh';

/// Used when an error occured during the provisioning process
enum ProvisioningFailureCode {
  /// when an error occurs in the callback of  `PROVISIONING_COMPLETE` event
  provisioningCompleted,

  /// when the node isn't found during BLE scan upon `PROVISIONING_COMPLETE` event
  notFound,

  /// when the first connection was tried
  initialConnection,

  /// when the phone could not reconnect to node upon `PROVISIONING_COMPLETE` event
  reconnection,

  /// when the found node had unexpected node composition (nb of elements)
  nodeComposition,

  /// when `PROVISIONING_FAILED` event is triggered
  provisioningFailed,

  /// when the configuration of the n/w is invalid (null network ?)
  meshConfiguration,

  /// when an unexpected disconnection event is received with an error
  unexpectedGattError,

  /// when provisioning goes timeout
  timeout,

  /// unknown error that should be diagnosed
  unknown,
}

/// Used when an error occured on BLE GATT layer
enum BleManagerFailureCode {
  /// service discovery failure
  serviceNotFound,

  /// negociation failure
  negociation,

  /// missing callbacks (Flutter layer)
  callbacks,

  /// disconnection event received before end of GATT negociation
  unexpectedDisconnection,
}
