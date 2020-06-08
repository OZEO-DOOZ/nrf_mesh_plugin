import 'package:freezed_annotation/freezed_annotation.dart';

part 'mesh_provisioning_status.freezed.dart';
part 'mesh_provisioning_status.g.dart';

@freezed
abstract class MeshProvisioningStatusData with _$MeshProvisioningStatusData {
  const factory MeshProvisioningStatusData(String state, List<int> data, String meshNodeUuid) =
      _MeshProvisioningStatusData;

  factory MeshProvisioningStatusData.fromJson(Map<String, dynamic> json) => _$MeshProvisioningStatusDataFromJson(json);
}
