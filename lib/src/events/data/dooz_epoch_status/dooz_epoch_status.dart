import 'package:freezed_annotation/freezed_annotation.dart';

part 'dooz_epoch_status.freezed.dart';
part 'dooz_epoch_status.g.dart';

@freezed
class DoozEpochStatusData with _$DoozEpochStatusData {
  const factory DoozEpochStatusData(
    int tzData,
    int command,
    int io,
    int unused,
    int epoch,
    int correlation,
    int extra,
    int source,
    int destination,
  ) = _DoozEpochStatusData;

  factory DoozEpochStatusData.fromJson(Map<String, dynamic> json) => _$DoozEpochStatusDataFromJson(json);
}
