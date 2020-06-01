class MeshNetworkApiEvent {
  final String value;

  const MeshNetworkApiEvent._(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) =>
      (other is String && other == value) ||
      (other is MeshNetworkApiEvent && other.value == value);

  static const loaded = MeshNetworkApiEvent._('onNetworkLoaded');
  static const imported = MeshNetworkApiEvent._('onNetworkImported');
  static const updated = MeshNetworkApiEvent._('onNetworkUpdated');

  static const loadFailed = MeshNetworkApiEvent._('onNetworkLoadFailed');
  static const importFailed = MeshNetworkApiEvent._('onNetworkImportFailed');
}
