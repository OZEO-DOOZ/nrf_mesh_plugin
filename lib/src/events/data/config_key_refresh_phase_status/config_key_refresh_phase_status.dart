import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_key_refresh_phase_status.freezed.dart';
part 'config_key_refresh_phase_status.g.dart';

@freezed
class ConfigKeyRefreshPhaseStatus with _$ConfigKeyRefreshPhaseStatus {
  const factory ConfigKeyRefreshPhaseStatus(
    int source,
    int destination,
    int statusCode,
    String statusCodeName,
    int netKeyIndex,
    int transition,
  ) = _ConfigKeyRefreshPhaseStatus;

  factory ConfigKeyRefreshPhaseStatus.fromJson(Map<String, dynamic> json) =>
      _$ConfigKeyRefreshPhaseStatusFromJson(json);
}
