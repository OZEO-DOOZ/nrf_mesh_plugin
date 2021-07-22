import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_network_transmit_status.freezed.dart';
part 'config_network_transmit_status.g.dart';

@freezed
abstract class ConfigNetworkTransmitStatus with _$ConfigNetworkTransmitStatus {
  const factory ConfigNetworkTransmitStatus(int source, int destination, int transmitCount, int transmitIntervalSteps) =
      _ConfigNetworkTransmitStatus;

  factory ConfigNetworkTransmitStatus.fromJson(Map<String, dynamic> json) =>
      _$ConfigNetworkTransmitStatusFromJson(json);
}
