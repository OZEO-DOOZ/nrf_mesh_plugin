import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
abstract class GroupData with _$GroupData {
  const factory GroupData(int id, String name, int address, @nullable String addressLabel, String meshUuid,
      int parentAddress, @nullable String parentAddressLabel) = _GroupData;

  factory GroupData.fromJson(Map<String, dynamic> json) => _$GroupDataFromJson(json);
}
