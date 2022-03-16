import 'package:freezed_annotation/freezed_annotation.dart';

part 'allocated_group_range.freezed.dart';
part 'allocated_group_range.g.dart';

/// {@template group_range}
/// A freezed data class used to hold a group address range
/// {@endtemplate}
@freezed
class AllocatedGroupRange with _$AllocatedGroupRange {
  /// {@macro group_range}
  const factory AllocatedGroupRange(int lowAddress, int highAddress) = _AllocatedGroupRange;

  /// Provide a constructor to get [AllocatedGroupRange] from JSON [Map].
  /// {@macro group_range}
  factory AllocatedGroupRange.fromJson(Map<String, dynamic> json) => _$AllocatedGroupRangeFromJson(json);
}
