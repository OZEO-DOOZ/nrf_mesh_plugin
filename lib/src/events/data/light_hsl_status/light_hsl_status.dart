import 'package:freezed_annotation/freezed_annotation.dart';

part 'light_hsl_status.freezed.dart';

part 'light_hsl_status.g.dart';

@freezed
abstract class LightHslStatusData with _$LightHslStatusData {
  const factory LightHslStatusData(
      int presentLightness,
      int presentHue,
      int presentSaturation,
      int transitionSteps,
      int transitionResolution,
      int source,
      int destination) = _LightHslStatusData;

  factory LightHslStatusData.fromJson(Map<String, dynamic> json) =>
      _$LightHslStatusDataFromJson(json);
}
