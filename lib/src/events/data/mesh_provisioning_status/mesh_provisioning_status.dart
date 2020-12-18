import 'package:freezed_annotation/freezed_annotation.dart';

part 'mesh_provisioning_status.freezed.dart';
part 'mesh_provisioning_status.g.dart';

@freezed
abstract class UnprovisionedMeshNodeData with _$UnprovisionedMeshNodeData {
  const factory UnprovisionedMeshNodeData(
          {@required String uuid,
          @nullable @Default([]) List<int> provisionerPublicKeyXY}) =
      _UnprovisionedMeshNodeData;

  factory UnprovisionedMeshNodeData.fromJson(Map json) =>
      _$UnprovisionedMeshNodeDataFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class ProvisionedMeshNodeData with _$ProvisionedMeshNodeData {
  const factory ProvisionedMeshNodeData({@required String uuid}) =
      _ProvisionedMeshNodeData;

  factory ProvisionedMeshNodeData.fromJson(Map json) =>
      _$ProvisionedMeshNodeDataFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class MeshProvisioningStatusData with _$MeshProvisioningStatusData {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory MeshProvisioningStatusData(String state, List<int> data,
          @nullable UnprovisionedMeshNodeData meshNode) =
      _MeshProvisioningStatusData;

  factory MeshProvisioningStatusData.fromJson(Map json) =>
      _$MeshProvisioningStatusDataFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class MeshProvisioningCompletedData
    with _$MeshProvisioningCompletedData {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory MeshProvisioningCompletedData(String state, List<int> data,
          @nullable ProvisionedMeshNodeData meshNode) =
      _MeshProvisioningCompletedData;

  factory MeshProvisioningCompletedData.fromJson(Map json) =>
      _$MeshProvisioningCompletedDataFromJson(json.cast<String, dynamic>());
}
