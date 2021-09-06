import 'package:freezed_annotation/freezed_annotation.dart';

part 'generic_level_status.freezed.dart';
part 'generic_level_status.g.dart';

@freezed
class GenericLevelStatusData with _$GenericLevelStatusData {
  const factory GenericLevelStatusData(
          int level, int? targetLevel, int? transitionSteps, int? transitionResolution, int source, int destination) =
      _GenericLevelStatusData;

  factory GenericLevelStatusData.fromJson(Map<String, dynamic> json) => _$GenericLevelStatusDataFromJson(json);
}
