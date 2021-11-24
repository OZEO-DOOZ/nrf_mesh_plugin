import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nordic_nrf_mesh/src/models/models.dart';

part 'send_provisioning_pdu.freezed.dart';
part 'send_provisioning_pdu.g.dart';

@freezed
class SendProvisioningPduData with _$SendProvisioningPduData {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory SendProvisioningPduData(List<int> pdu, UnprovisionedMeshNode meshNode) = _SendProvisioningPduData;

  factory SendProvisioningPduData.fromJson(Map<String, dynamic> json) =>
      _$SendProvisioningPduDataFromJson(json.cast<String, dynamic>());
}
