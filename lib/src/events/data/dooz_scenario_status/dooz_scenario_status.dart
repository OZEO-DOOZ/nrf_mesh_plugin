import 'package:freezed_annotation/freezed_annotation.dart';

part 'dooz_scenario_status.freezed.dart';
part 'dooz_scenario_status.g.dart';

@freezed
class DoozScenarioStatusData with _$DoozScenarioStatusData {
  const factory DoozScenarioStatusData(
    int scenarioId,
    int command,
    int io,
    bool isActive,
    int unused,
    int value,
    int transition,
    int startAt,
    int duration,
    int daysInWeek,
    int correlation,
    int extra,
    int source,
    int destination,
  ) = _DoozScenarioStatusData;

  factory DoozScenarioStatusData.fromJson(Map<String, dynamic> json) => _$DoozScenarioStatusDataFromJson(json);
}
