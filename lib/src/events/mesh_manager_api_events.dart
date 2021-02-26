class MeshManagerApiEvent {
  final String value;

  const MeshManagerApiEvent._(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) =>
      other is MeshManagerApiEvent && other.value == value;

  @override
  String toString() => value;

  static const loaded = MeshManagerApiEvent._('onNetworkLoaded');
  static const imported = MeshManagerApiEvent._('onNetworkImported');
  static const updated = MeshManagerApiEvent._('onNetworkUpdated');

  static const loadFailed = MeshManagerApiEvent._('onNetworkLoadFailed');
  static const importFailed = MeshManagerApiEvent._('onNetworkImportFailed');

  static const meshPduCreated = MeshManagerApiEvent._('onMeshPduCreated');
  static const sendProvisioningPdu =
      MeshManagerApiEvent._('sendProvisioningPdu');

  static const provisioningStateChanged =
      MeshManagerApiEvent._('onProvisioningStateChanged');
  static const provisioningFailed =
      MeshManagerApiEvent._('onProvisioningFailed');
  static const provisioningCompleted =
      MeshManagerApiEvent._('onProvisioningCompleted');

  static const configCompositionDataStatus =
      MeshManagerApiEvent._('onConfigCompositionDataStatus');
  static const configAppKeyStatus =
      MeshManagerApiEvent._('onConfigAppKeyStatus');
  static const genericLevelStatus =
      MeshManagerApiEvent._('onGenericLevelStatus');
  static const genericOnOffStatus =
      MeshManagerApiEvent._('onGenericOnOffStatus');

  static const lightLightnessStatus =
      MeshManagerApiEvent._('onLightLightnessStatus');
  static const lightCtlStatus = MeshManagerApiEvent._('onLightCtlStatus');
  static const lightHslStatus = MeshManagerApiEvent._('onLightHslStatus');

  static const configModelAppStatus =
      MeshManagerApiEvent._('onConfigModelAppStatus');
  static const configModelSubscriptionStatus =
      MeshManagerApiEvent._('onConfigModelSubscriptionStatus');
  static const configModelPublicationStatus =
      MeshManagerApiEvent._('onConfigModelPublicationStatus');
}
