// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'config_model_subscription_add_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ConfigModelSubscriptionAddStatus _$ConfigModelSubscriptionAddStatusFromJson(
    Map<String, dynamic> json) {
  return _ConfigModelSubscriptionAddStatus.fromJson(json);
}

class _$ConfigModelSubscriptionAddStatusTearOff {
  const _$ConfigModelSubscriptionAddStatusTearOff();

// ignore: unused_element
  _ConfigModelSubscriptionAddStatus call(int source, int destination,
      int elementAddress, int subscriptionAddress, int modelIdentifier) {
    return _ConfigModelSubscriptionAddStatus(
      source,
      destination,
      elementAddress,
      subscriptionAddress,
      modelIdentifier,
    );
  }
}

// ignore: unused_element
const $ConfigModelSubscriptionAddStatus =
    _$ConfigModelSubscriptionAddStatusTearOff();

mixin _$ConfigModelSubscriptionAddStatus {
  int get source;
  int get destination;
  int get elementAddress;
  int get subscriptionAddress;
  int get modelIdentifier;

  Map<String, dynamic> toJson();
  $ConfigModelSubscriptionAddStatusCopyWith<ConfigModelSubscriptionAddStatus>
      get copyWith;
}

abstract class $ConfigModelSubscriptionAddStatusCopyWith<$Res> {
  factory $ConfigModelSubscriptionAddStatusCopyWith(
          ConfigModelSubscriptionAddStatus value,
          $Res Function(ConfigModelSubscriptionAddStatus) then) =
      _$ConfigModelSubscriptionAddStatusCopyWithImpl<$Res>;
  $Res call(
      {int source,
      int destination,
      int elementAddress,
      int subscriptionAddress,
      int modelIdentifier});
}

class _$ConfigModelSubscriptionAddStatusCopyWithImpl<$Res>
    implements $ConfigModelSubscriptionAddStatusCopyWith<$Res> {
  _$ConfigModelSubscriptionAddStatusCopyWithImpl(this._value, this._then);

  final ConfigModelSubscriptionAddStatus _value;
  // ignore: unused_field
  final $Res Function(ConfigModelSubscriptionAddStatus) _then;

  @override
  $Res call({
    Object source = freezed,
    Object destination = freezed,
    Object elementAddress = freezed,
    Object subscriptionAddress = freezed,
    Object modelIdentifier = freezed,
  }) {
    return _then(_value.copyWith(
      source: source == freezed ? _value.source : source as int,
      destination:
          destination == freezed ? _value.destination : destination as int,
      elementAddress: elementAddress == freezed
          ? _value.elementAddress
          : elementAddress as int,
      subscriptionAddress: subscriptionAddress == freezed
          ? _value.subscriptionAddress
          : subscriptionAddress as int,
      modelIdentifier: modelIdentifier == freezed
          ? _value.modelIdentifier
          : modelIdentifier as int,
    ));
  }
}

abstract class _$ConfigModelSubscriptionAddStatusCopyWith<$Res>
    implements $ConfigModelSubscriptionAddStatusCopyWith<$Res> {
  factory _$ConfigModelSubscriptionAddStatusCopyWith(
          _ConfigModelSubscriptionAddStatus value,
          $Res Function(_ConfigModelSubscriptionAddStatus) then) =
      __$ConfigModelSubscriptionAddStatusCopyWithImpl<$Res>;
  @override
  $Res call(
      {int source,
      int destination,
      int elementAddress,
      int subscriptionAddress,
      int modelIdentifier});
}

class __$ConfigModelSubscriptionAddStatusCopyWithImpl<$Res>
    extends _$ConfigModelSubscriptionAddStatusCopyWithImpl<$Res>
    implements _$ConfigModelSubscriptionAddStatusCopyWith<$Res> {
  __$ConfigModelSubscriptionAddStatusCopyWithImpl(
      _ConfigModelSubscriptionAddStatus _value,
      $Res Function(_ConfigModelSubscriptionAddStatus) _then)
      : super(_value, (v) => _then(v as _ConfigModelSubscriptionAddStatus));

  @override
  _ConfigModelSubscriptionAddStatus get _value =>
      super._value as _ConfigModelSubscriptionAddStatus;

  @override
  $Res call({
    Object source = freezed,
    Object destination = freezed,
    Object elementAddress = freezed,
    Object subscriptionAddress = freezed,
    Object modelIdentifier = freezed,
  }) {
    return _then(_ConfigModelSubscriptionAddStatus(
      source == freezed ? _value.source : source as int,
      destination == freezed ? _value.destination : destination as int,
      elementAddress == freezed ? _value.elementAddress : elementAddress as int,
      subscriptionAddress == freezed
          ? _value.subscriptionAddress
          : subscriptionAddress as int,
      modelIdentifier == freezed
          ? _value.modelIdentifier
          : modelIdentifier as int,
    ));
  }
}

@JsonSerializable()
class _$_ConfigModelSubscriptionAddStatus
    implements _ConfigModelSubscriptionAddStatus {
  const _$_ConfigModelSubscriptionAddStatus(this.source, this.destination,
      this.elementAddress, this.subscriptionAddress, this.modelIdentifier)
      : assert(source != null),
        assert(destination != null),
        assert(elementAddress != null),
        assert(subscriptionAddress != null),
        assert(modelIdentifier != null);

  factory _$_ConfigModelSubscriptionAddStatus.fromJson(
          Map<String, dynamic> json) =>
      _$_$_ConfigModelSubscriptionAddStatusFromJson(json);

  @override
  final int source;
  @override
  final int destination;
  @override
  final int elementAddress;
  @override
  final int subscriptionAddress;
  @override
  final int modelIdentifier;

  @override
  String toString() {
    return 'ConfigModelSubscriptionAddStatus(source: $source, destination: $destination, elementAddress: $elementAddress, subscriptionAddress: $subscriptionAddress, modelIdentifier: $modelIdentifier)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConfigModelSubscriptionAddStatus &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.destination, destination) ||
                const DeepCollectionEquality()
                    .equals(other.destination, destination)) &&
            (identical(other.elementAddress, elementAddress) ||
                const DeepCollectionEquality()
                    .equals(other.elementAddress, elementAddress)) &&
            (identical(other.subscriptionAddress, subscriptionAddress) ||
                const DeepCollectionEquality()
                    .equals(other.subscriptionAddress, subscriptionAddress)) &&
            (identical(other.modelIdentifier, modelIdentifier) ||
                const DeepCollectionEquality()
                    .equals(other.modelIdentifier, modelIdentifier)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(destination) ^
      const DeepCollectionEquality().hash(elementAddress) ^
      const DeepCollectionEquality().hash(subscriptionAddress) ^
      const DeepCollectionEquality().hash(modelIdentifier);

  @override
  _$ConfigModelSubscriptionAddStatusCopyWith<_ConfigModelSubscriptionAddStatus>
      get copyWith => __$ConfigModelSubscriptionAddStatusCopyWithImpl<
          _ConfigModelSubscriptionAddStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigModelSubscriptionAddStatusToJson(this);
  }
}

abstract class _ConfigModelSubscriptionAddStatus
    implements ConfigModelSubscriptionAddStatus {
  const factory _ConfigModelSubscriptionAddStatus(
      int source,
      int destination,
      int elementAddress,
      int subscriptionAddress,
      int modelIdentifier) = _$_ConfigModelSubscriptionAddStatus;

  factory _ConfigModelSubscriptionAddStatus.fromJson(
      Map<String, dynamic> json) = _$_ConfigModelSubscriptionAddStatus.fromJson;

  @override
  int get source;
  @override
  int get destination;
  @override
  int get elementAddress;
  @override
  int get subscriptionAddress;
  @override
  int get modelIdentifier;
  @override
  _$ConfigModelSubscriptionAddStatusCopyWith<_ConfigModelSubscriptionAddStatus>
      get copyWith;
}
