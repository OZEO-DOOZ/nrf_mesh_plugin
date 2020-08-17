import 'package:freezed_annotation/freezed_annotation.dart';

part 'generic_level_status.freezed.dart';
part 'generic_level_status.g.dart';

@freezed
abstract class GenericLevelStatusData with _$GenericLevelStatusData {
  const factory GenericLevelStatusData(int level, int elementId, int targetLevel, int source) = _GenericLevelStatusData;

  factory GenericLevelStatusData.fromJson(Map<String, dynamic> json) => _$GenericLevelStatusDataFromJson(json);
}
