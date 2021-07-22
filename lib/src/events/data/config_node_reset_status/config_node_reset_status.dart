import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_node_reset_status.freezed.dart';
part 'config_node_reset_status.g.dart';

@freezed
abstract class ConfigNodeResetStatus with _$ConfigNodeResetStatus {
  const factory ConfigNodeResetStatus(int source, int destination, bool success) = _ConfigNodeResetStatus;

  factory ConfigNodeResetStatus.fromJson(Map<String, dynamic> json) => _$ConfigNodeResetStatusFromJson(json);
}
