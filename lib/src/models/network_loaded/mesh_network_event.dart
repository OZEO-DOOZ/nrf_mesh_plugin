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
  const factory MeshNetworkEventError(String error) = _MeshNetworkEventError;

  factory MeshNetworkEventError.fromJson(Map<String, dynamic> json) =>
      _$MeshNetworkEventErrorFromJson(json);
}
