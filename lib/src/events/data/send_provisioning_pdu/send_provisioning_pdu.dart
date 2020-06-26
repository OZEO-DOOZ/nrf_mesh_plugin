import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_provisioning_pdu.freezed.dart';
part 'send_provisioning_pdu.g.dart';

@freezed
abstract class SendProvisioningPduData with _$SendProvisioningPduData {
  const factory SendProvisioningPduData(List<int> pdu, String meshNodeUuid) = _SendProvisioningPduData;

  factory SendProvisioningPduData.fromJson(Map<String, dynamic> json) => _$SendProvisioningPduDataFromJson(json);
}
