import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model_subscription_add_status.freezed.dart';
part 'config_model_subscription_add_status.g.dart';

@freezed
abstract class ConfigModelSubscriptionAddStatus with _$ConfigModelSubscriptionAddStatus {
  const factory ConfigModelSubscriptionAddStatus(
          int source, int destination, int elementAddress, int subscriptionAddress, int modelIdentifier) =
      _ConfigModelSubscriptionAddStatus;

  factory ConfigModelSubscriptionAddStatus.fromJson(Map<String, dynamic> json) =>
      _$ConfigModelSubscriptionAddStatusFromJson(json);
}
