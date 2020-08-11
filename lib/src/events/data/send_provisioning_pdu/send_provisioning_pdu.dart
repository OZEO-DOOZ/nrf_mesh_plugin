import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nordic_nrf_mesh/src/unprovisioned_mesh_node.dart';

part 'send_provisioning_pdu.freezed.dart';
part 'send_provisioning_pdu.g.dart';

@freezed
abstract class SendProvisioningPduData with _$SendProvisioningPduData {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory SendProvisioningPduData(List<int> pdu, UnprovisionedMeshNode meshNode) = _SendProvisioningPduData;

  factory SendProvisioningPduData.fromJson(Map<String, dynamic> json) =>
      _$SendProvisioningPduDataFromJson(json.cast<String, dynamic>());
}
