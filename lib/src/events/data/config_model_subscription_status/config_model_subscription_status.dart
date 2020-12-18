import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model_subscription_status.freezed.dart';
part 'config_model_subscription_status.g.dart';

@freezed
abstract class ConfigModelSubscriptionStatus
    with _$ConfigModelSubscriptionStatus {
  const factory ConfigModelSubscriptionStatus(
    int source,
    int destination,
    int elementAddress,
    int subscriptionAddress,
    int modelIdentifier,
    bool isSuccessful,
  ) = _ConfigModelSubscriptionStatus;

  factory ConfigModelSubscriptionStatus.fromJson(Map<String, dynamic> json) =>
      _$ConfigModelSubscriptionStatusFromJson(json);
}
