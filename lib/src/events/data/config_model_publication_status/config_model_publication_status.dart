import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model_publication_status.freezed.dart';
part 'config_model_publication_status.g.dart';

@freezed
class ConfigModelPublicationStatus with _$ConfigModelPublicationStatus {
  const factory ConfigModelPublicationStatus(
    int elementAddress,
    int publishAddress,
    int appKeyIndex,
    bool credentialFlag,
    int publishTtl,
    int publicationSteps,
    int publicationResolution,
    int retransmitCount,
    int retransmitIntervalSteps,
    int modelIdentifier,
    bool isSuccessful,
  ) = _ConfigModelPublicationStatus;

  factory ConfigModelPublicationStatus.fromJson(Map<String, dynamic> json) =>
      _$ConfigModelPublicationStatusFromJson(json);
}
