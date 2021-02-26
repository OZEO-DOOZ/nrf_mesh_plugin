import 'package:freezed_annotation/freezed_annotation.dart';

part 'generic_on_off_status.freezed.dart';
part 'generic_on_off_status.g.dart';

@freezed
abstract class GenericOnOffStatusData with _$GenericOnOffStatusData {
  const factory GenericOnOffStatusData(
      int source,
      bool presentState,
      @nullable bool targetState,
      int transitionResolution,
      int transitionSteps) = _GenericOnOffStatusData;

  factory GenericOnOffStatusData.fromJson(Map<String, dynamic> json) =>
      _$GenericOnOffStatusDataFromJson(json);
}
