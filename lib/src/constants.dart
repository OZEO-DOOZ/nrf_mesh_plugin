/// The namespace (used to identify flutter method and event channels)
const namespace = 'fr.dooz.nordic_nrf_mesh';
const Duration kDefaultScanDuration = Duration(seconds: 5);
const Duration kDefaultConnectionTimeout = Duration(seconds: 30);
const mtuSizeMax = 517;
const maxPacketSize = 20;

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

  /// when the connected device does not broadcast the DooZ custom service
  doozServiceNotFound,

  /// init GATT failure (MTU size negociation and notification subscription)
  initGatt,

  /// missing callbacks (Flutter layer)
  callbacks,

  /// disconnection event received before end of GATT negociation
  unexpectedDisconnection,

  /// when the connected device's UUID or MAC is not in the given whitelist
  proxyWhitelist,
}
