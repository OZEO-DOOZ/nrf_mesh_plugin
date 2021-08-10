import 'package:freezed_annotation/freezed_annotation.dart';

part 'allocated_unicast_range.freezed.dart';
part 'allocated_unicast_range.g.dart';

@freezed
class AllocatedUnicastRange with _$AllocatedUnicastRange {
  const factory AllocatedUnicastRange(int lowAddress, int highAddress) = _AllocatedUnicastRange;

  factory AllocatedUnicastRange.fromJson(Map<String, dynamic> json) => _$AllocatedUnicastRangeFromJson(json);
}
