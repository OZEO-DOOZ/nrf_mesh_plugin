import 'package:freezed_annotation/freezed_annotation.dart';

part 'allocated_scene_range.freezed.dart';
part 'allocated_scene_range.g.dart';

/// {@template scene_range}
/// A freezed data class used to hold a scene range
/// {@endtemplate}
@freezed
class AllocatedSceneRange with _$AllocatedSceneRange {
  /// {@macro scene_range}
  const factory AllocatedSceneRange(int firstScene, int lastScene) = _AllocatedSceneRange;

  /// Provide a constructor to get [AllocatedSceneRange] from JSON [Map].
  /// {@macro scene_range}
  factory AllocatedSceneRange.fromJson(Map<String, dynamic> json) => _$AllocatedSceneRangeFromJson(json);
}
