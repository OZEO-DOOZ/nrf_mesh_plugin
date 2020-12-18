import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_app_key_status.freezed.dart';
part 'config_app_key_status.g.dart';

@freezed
abstract class ConfigAppKeyStatusData with _$ConfigAppKeyStatusData {
  const factory ConfigAppKeyStatusData(int source) = _ConfigAppKeyStatusData;

  factory ConfigAppKeyStatusData.fromJson(Map<String, dynamic> json) =>
      _$ConfigAppKeyStatusDataFromJson(json);
}

@freezed
abstract class ConfigAppKeyStatusMeshMessage
    with _$ConfigAppKeyStatusMeshMessage {
  const factory ConfigAppKeyStatusMeshMessage(int source, int destination) =
      _ConfigAppKeyStatusMeshMessage;

  factory ConfigAppKeyStatusMeshMessage.fromJson(Map<String, dynamic> json) =>
      _$ConfigAppKeyStatusMeshMessageFromJson(json);
}
