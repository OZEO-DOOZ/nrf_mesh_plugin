import 'package:freezed_annotation/freezed_annotation.dart';

part 'magic_level_set_status.freezed.dart';
part 'magic_level_set_status.g.dart';

@freezed
abstract class MagicLevelSetStatusData with _$MagicLevelSetStatusData {
  const factory MagicLevelSetStatusData(int io, int index, int value,
      int correlation, int source, int destination) = _MagicLevelSetStatusData;

  factory MagicLevelSetStatusData.fromJson(Map<String, dynamic> json) =>
      _$MagicLevelSetStatusDataFromJson(json);
}
