import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model_app_status.freezed.dart';
part 'config_model_app_status.g.dart';

@freezed
abstract class ConfigModelAppStatusData with _$ConfigModelAppStatusData {
  const factory ConfigModelAppStatusData(int elementAddress, int modelId, int appKeyIndex) = _ConfigModelAppStatusData;

  factory ConfigModelAppStatusData.fromJson(Map<String, dynamic> json) => _$ConfigModelAppStatusDataFromJson(json);
}
