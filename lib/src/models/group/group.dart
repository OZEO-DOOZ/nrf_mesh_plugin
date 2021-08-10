import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
class GroupData with _$GroupData {
  const factory GroupData(String name, int address, String? addressLabel, String meshUuid, int parentAddress,
      String? parentAddressLabel) = _GroupData;

  factory GroupData.fromJson(Map<String, dynamic> json) => _$GroupDataFromJson(json);
}
