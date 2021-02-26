import 'package:freezed_annotation/freezed_annotation.dart';

part 'magic_level_get_status.freezed.dart';
part 'magic_level_get_status.g.dart';

@freezed
abstract class MagicLevelGetStatusData with _$MagicLevelGetStatusData {
  const factory MagicLevelGetStatusData(int io, int index, int value, int correlation, int source, int destination) =
      _MagicLevelGetStatusData;

  factory MagicLevelGetStatusData.fromJson(Map<String, dynamic> json) => _$MagicLevelGetStatusDataFromJson(json);
}
