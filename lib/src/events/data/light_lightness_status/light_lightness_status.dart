import 'package:freezed_annotation/freezed_annotation.dart';

part 'light_lightness_status.freezed.dart';

part 'light_lightness_status.g.dart';

@freezed
class LightLightnessStatusData with _$LightLightnessStatusData {
  const factory LightLightnessStatusData(int presentLightness, int targetLightness, int transitionSteps,
      int transitionResolution, int source, int destination) = _LightLightnessStatusData;

  factory LightLightnessStatusData.fromJson(Map<String, dynamic> json) => _$LightLightnessStatusDataFromJson(json);
}
