import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_beacon_status.freezed.dart';
part 'config_beacon_status.g.dart';

@freezed
class ConfigBeaconStatus with _$ConfigBeaconStatus {
  const factory ConfigBeaconStatus(int source, int destination, bool enable) = _ConfigBeaconStatus;

  factory ConfigBeaconStatus.fromJson(Map<String, dynamic> json) => _$ConfigBeaconStatusFromJson(json);
}
