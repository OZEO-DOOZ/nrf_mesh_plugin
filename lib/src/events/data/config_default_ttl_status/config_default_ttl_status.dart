import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_default_ttl_status.freezed.dart';
part 'config_default_ttl_status.g.dart';

@freezed
abstract class ConfigDefaultTtlStatus with _$ConfigDefaultTtlStatus {
  const factory ConfigDefaultTtlStatus(int source, int destination, int ttl) = _ConfigDefaultTtlStatus;

  factory ConfigDefaultTtlStatus.fromJson(Map<String, dynamic> json) => _$ConfigDefaultTtlStatusFromJson(json);
}
