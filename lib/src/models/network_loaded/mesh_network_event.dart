import 'package:freezed_annotation/freezed_annotation.dart';

part 'mesh_network_event.freezed.dart';
part 'mesh_network_event.g.dart';

@freezed
abstract class MeshNetworkEventData with _$MeshNetworkEventData {
  const factory MeshNetworkEventData(String id) = _MeshNetworkEventData;

  factory MeshNetworkEventData.fromJson(Map<String, dynamic> json) =>
      _$MeshNetworkEventDataFromJson(json);
}

@freezed
abstract class MeshNetworkEventError with _$MeshNetworkEventError {
  const factory MeshNetworkEventError(String id) = _MeshNetworkEventError;

  factory MeshNetworkEventError.fromJson(Map<String, dynamic> json) =>
      _$MeshNetworkEventErrorFromJson(json);
}

class MeshNetworkEventType {
  final String value;

  const MeshNetworkEventType._(this.value);

  static const loaded = MeshNetworkEventType._('onNetworkLoaded');
  static const imported = MeshNetworkEventType._('onNetworkImported');
  static const updated = MeshNetworkEventType._('onNetworkUpdated');

  static const loadFailed = MeshNetworkEventType._('onNetworkLoadFailed');
  static const importFailed = MeshNetworkEventType._('onNetworkImportFailed');
}
