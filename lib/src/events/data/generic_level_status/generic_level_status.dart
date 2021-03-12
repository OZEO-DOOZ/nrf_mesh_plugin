import 'package:freezed_annotation/freezed_annotation.dart';

part 'generic_level_status.freezed.dart';
part 'generic_level_status.g.dart';

@freezed
abstract class GenericLevelStatusData with _$GenericLevelStatusData {
  const factory GenericLevelStatusData(int level, @nullable int targetLevel, @nullable int transitionSteps,
      @nullable int transitionResolution, int source, int destination) = _GenericLevelStatusData;

  factory GenericLevelStatusData.fromJson(Map<String, dynamic> json) => _$GenericLevelStatusDataFromJson(json);
}
