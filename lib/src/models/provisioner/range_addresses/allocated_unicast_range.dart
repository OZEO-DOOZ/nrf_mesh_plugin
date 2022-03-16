import 'package:freezed_annotation/freezed_annotation.dart';

part 'allocated_unicast_range.freezed.dart';
part 'allocated_unicast_range.g.dart';

/// {@template unicast_range}
/// A freezed data class used to hold a unicast address range
/// {@endtemplate}
@freezed
class AllocatedUnicastRange with _$AllocatedUnicastRange {
  /// {@macro unicast_range}
  const factory AllocatedUnicastRange(int lowAddress, int highAddress) = _AllocatedUnicastRange;

  /// Provide a constructor to get [AllocatedUnicastRange] from JSON [Map].
  /// {@macro unicast_range}
  factory AllocatedUnicastRange.fromJson(Map<String, dynamic> json) => _$AllocatedUnicastRangeFromJson(json);
}
