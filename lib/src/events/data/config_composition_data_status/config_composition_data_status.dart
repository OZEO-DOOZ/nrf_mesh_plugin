import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_composition_data_status.freezed.dart';
part 'config_composition_data_status.g.dart';

@freezed
abstract class ConfigCompositionDataStatusData
    with _$ConfigCompositionDataStatusData {
  @JsonSerializable(anyMap: true)
  const factory ConfigCompositionDataStatusData(
          int source, ConfigCompositionDataStatusMeshMessage meshMessage) =
      _ConfigCompositionDataStatusData;

  factory ConfigCompositionDataStatusData.fromJson(Map<String, dynamic> json) =>
      _$ConfigCompositionDataStatusDataFromJson(json);
}

@freezed
abstract class ConfigCompositionDataStatusMeshMessage
    with _$ConfigCompositionDataStatusMeshMessage {
  const factory ConfigCompositionDataStatusMeshMessage(
          int source, @nullable int aszmic, int destination) =
      _ConfigCompositionDataStatusMeshMessage;

  factory ConfigCompositionDataStatusMeshMessage.fromJson(
          Map<String, dynamic> json) =>
      _$ConfigCompositionDataStatusMeshMessageFromJson(json);
}
