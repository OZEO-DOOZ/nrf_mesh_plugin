import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

/// {@template group_data}
/// A freezed data class used to hold a group data
/// {@endtemplate}
@freezed
class GroupData with _$GroupData {
  /// {@macro group_data}
  const factory GroupData(String name, int address, String? addressLabel, String meshUuid, int parentAddress,
      String? parentAddressLabel) = _GroupData;

  /// Provide a constructor to get [GroupData] from JSON [Map].
  /// {@macro group_data}
  factory GroupData.fromJson(Map<String, dynamic> json) => _$GroupDataFromJson(json);
}
