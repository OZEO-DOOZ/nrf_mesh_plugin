import 'package:freezed_annotation/freezed_annotation.dart';

part 'mesh_provisioning_status.freezed.dart';
part 'mesh_provisioning_status.g.dart';

@freezed
class UnprovisionedMeshNodeData with _$UnprovisionedMeshNodeData {
  const factory UnprovisionedMeshNodeData(String uuid, {@Default([]) List<int>? provisionerPublicKeyXY}) =
      _UnprovisionedMeshNodeData;

  factory UnprovisionedMeshNodeData.fromJson(Map json) =>
      _$UnprovisionedMeshNodeDataFromJson(json.cast<String, dynamic>());
}

@freezed
class ProvisionedMeshNodeData with _$ProvisionedMeshNodeData {
  const factory ProvisionedMeshNodeData(String uuid) = _ProvisionedMeshNodeData;

  factory ProvisionedMeshNodeData.fromJson(Map json) => _$ProvisionedMeshNodeDataFromJson(json.cast<String, dynamic>());
}

@freezed
class MeshProvisioningStatusData with _$MeshProvisioningStatusData {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory MeshProvisioningStatusData(String state, List<int> data, UnprovisionedMeshNodeData? meshNode) =
      _MeshProvisioningStatusData;

  factory MeshProvisioningStatusData.fromJson(Map json) =>
      _$MeshProvisioningStatusDataFromJson(json.cast<String, dynamic>());
}

@freezed
class MeshProvisioningCompletedData with _$MeshProvisioningCompletedData {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory MeshProvisioningCompletedData(String state, List<int> data, ProvisionedMeshNodeData? meshNode) =
      _MeshProvisioningCompletedData;

  factory MeshProvisioningCompletedData.fromJson(Map json) =>
      _$MeshProvisioningCompletedDataFromJson(json.cast<String, dynamic>());
}
