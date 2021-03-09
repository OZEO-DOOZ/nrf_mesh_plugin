import 'package:freezed_annotation/freezed_annotation.dart';

part 'allocated_group_range.freezed.dart';
part 'allocated_group_range.g.dart';

@freezed
abstract class AllocatedGroupRange with _$AllocatedGroupRange {
  const factory AllocatedGroupRange(int lowAddress, int highAddress) = _AllocatedGroupRange;

  factory AllocatedGroupRange.fromJson(Map<String, dynamic> json) => _$AllocatedGroupRangeFromJson(json);
}
