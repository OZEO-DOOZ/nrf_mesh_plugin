import 'package:freezed_annotation/freezed_annotation.dart';

part 'allocated_scene_range.freezed.dart';
part 'allocated_scene_range.g.dart';

@freezed
abstract class AllocatedSceneRange with _$AllocatedSceneRange {
  const factory AllocatedSceneRange(int firstScene, int lastScene) = _AllocatedSceneRange;

  factory AllocatedSceneRange.fromJson(Map<String, dynamic> json) => _$AllocatedSceneRangeFromJson(json);
}
