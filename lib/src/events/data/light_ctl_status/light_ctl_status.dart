import 'package:freezed_annotation/freezed_annotation.dart';

part 'light_ctl_status.freezed.dart';

part 'light_ctl_status.g.dart';

@freezed
abstract class LightCtlStatusData with _$LightCtlStatusData {
  const factory LightCtlStatusData(
      int presentLightness,
      int targetLightness,
      int presentTemperature,
      int targetTemperature,
      int transitionSteps,
      int transitionResolution,
      int source,
      int destination) = _LightCtlStatusData;

  factory LightCtlStatusData.fromJson(Map<String, dynamic> json) =>
      _$LightCtlStatusDataFromJson(json);
}
