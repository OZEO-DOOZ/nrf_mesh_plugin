class MeshManagerApiEvent {
  final String value;

  const MeshManagerApiEvent._(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) =>
      (other is String && other == value) || (other is MeshManagerApiEvent && other.value == value);

  static const loaded = MeshManagerApiEvent._('onNetworkLoaded');
  static const imported = MeshManagerApiEvent._('onNetworkImported');
  static const updated = MeshManagerApiEvent._('onNetworkUpdated');

  static const loadFailed = MeshManagerApiEvent._('onNetworkLoadFailed');
  static const importFailed = MeshManagerApiEvent._('onNetworkImportFailed');

  static const meshPduCreated = MeshManagerApiEvent._('onMeshPduCreated');
  static const sendProvisioningPdu = MeshManagerApiEvent._('sendProvisioningPdu');

  static const provisioningStateChanged = MeshManagerApiEvent._('onProvisioningStateChanged');
  static const provisioningFailed = MeshManagerApiEvent._('onProvisioningFailed');
  static const provisioningCompleted = MeshManagerApiEvent._('onProvisioningCompleted');
}
