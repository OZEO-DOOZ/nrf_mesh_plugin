import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model_publication_status.freezed.dart';
part 'config_model_publication_status.g.dart';

@freezed
abstract class ConfigModelPublicationStatus
    with _$ConfigModelPublicationStatus {
  const factory ConfigModelPublicationStatus(
    int elementAddress,
    int publishAddress,
    int appKeyIndex,
    bool credentialFlag,
    int publishTtl,
    int publicationSteps,
    int publicationResolution,
    int publishRetransmitCount,
    int publishRetransmitIntervalSteps,
    int modelIdentifier,
    bool isSuccessful,
  ) = _ConfigModelPublicationStatus;

  factory ConfigModelPublicationStatus.fromJson(Map<String, dynamic> json) =>
      _$ConfigModelPublicationStatusFromJson(json);
}
