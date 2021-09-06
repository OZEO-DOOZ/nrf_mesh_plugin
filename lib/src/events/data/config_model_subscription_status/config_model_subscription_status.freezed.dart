// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'config_model_subscription_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConfigModelSubscriptionStatus _$ConfigModelSubscriptionStatusFromJson(Map<String, dynamic> json) {
  return _ConfigModelSubscriptionStatus.fromJson(json);
}

/// @nodoc
class _$ConfigModelSubscriptionStatusTearOff {
  const _$ConfigModelSubscriptionStatusTearOff();

  _ConfigModelSubscriptionStatus call(int source, int destination, int elementAddress, int subscriptionAddress,
      int modelIdentifier, bool isSuccessful) {
    return _ConfigModelSubscriptionStatus(
      source,
      destination,
      elementAddress,
      subscriptionAddress,
      modelIdentifier,
      isSuccessful,
    );
  }

  ConfigModelSubscriptionStatus fromJson(Map<String, Object> json) {
    return ConfigModelSubscriptionStatus.fromJson(json);
  }
}

/// @nodoc
const $ConfigModelSubscriptionStatus = _$ConfigModelSubscriptionStatusTearOff();

/// @nodoc
mixin _$ConfigModelSubscriptionStatus {
  int get source => throw _privateConstructorUsedError;
  int get destination => throw _privateConstructorUsedError;
  int get elementAddress => throw _privateConstructorUsedError;
  int get subscriptionAddress => throw _privateConstructorUsedError;
  int get modelIdentifier => throw _privateConstructorUsedError;
  bool get isSuccessful => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigModelSubscriptionStatusCopyWith<ConfigModelSubscriptionStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigModelSubscriptionStatusCopyWith<$Res> {
  factory $ConfigModelSubscriptionStatusCopyWith(
          ConfigModelSubscriptionStatus value, $Res Function(ConfigModelSubscriptionStatus) then) =
      _$ConfigModelSubscriptionStatusCopyWithImpl<$Res>;
  $Res call(
      {int source,
      int destination,
      int elementAddress,
      int subscriptionAddress,
      int modelIdentifier,
      bool isSuccessful});
}

/// @nodoc
class _$ConfigModelSubscriptionStatusCopyWithImpl<$Res> implements $ConfigModelSubscriptionStatusCopyWith<$Res> {
  _$ConfigModelSubscriptionStatusCopyWithImpl(this._value, this._then);

  final ConfigModelSubscriptionStatus _value;
  // ignore: unused_field
  final $Res Function(ConfigModelSubscriptionStatus) _then;

  @override
  $Res call({
    Object? source = freezed,
    Object? destination = freezed,
    Object? elementAddress = freezed,
    Object? subscriptionAddress = freezed,
    Object? modelIdentifier = freezed,
    Object? isSuccessful = freezed,
  }) {
    return _then(_value.copyWith(
      source: source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      destination: destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as int,
      elementAddress: elementAddress == freezed
          ? _value.elementAddress
          : elementAddress // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptionAddress: subscriptionAddress == freezed
          ? _value.subscriptionAddress
          : subscriptionAddress // ignore: cast_nullable_to_non_nullable
              as int,
      modelIdentifier: modelIdentifier == freezed
          ? _value.modelIdentifier
          : modelIdentifier // ignore: cast_nullable_to_non_nullable
              as int,
      isSuccessful: isSuccessful == freezed
          ? _value.isSuccessful
          : isSuccessful // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$ConfigModelSubscriptionStatusCopyWith<$Res> implements $ConfigModelSubscriptionStatusCopyWith<$Res> {
  factory _$ConfigModelSubscriptionStatusCopyWith(
          _ConfigModelSubscriptionStatus value, $Res Function(_ConfigModelSubscriptionStatus) then) =
      __$ConfigModelSubscriptionStatusCopyWithImpl<$Res>;
  @override
  $Res call(
      {int source,
      int destination,
      int elementAddress,
      int subscriptionAddress,
      int modelIdentifier,
      bool isSuccessful});
}

/// @nodoc
class __$ConfigModelSubscriptionStatusCopyWithImpl<$Res> extends _$ConfigModelSubscriptionStatusCopyWithImpl<$Res>
    implements _$ConfigModelSubscriptionStatusCopyWith<$Res> {
  __$ConfigModelSubscriptionStatusCopyWithImpl(
      _ConfigModelSubscriptionStatus _value, $Res Function(_ConfigModelSubscriptionStatus) _then)
      : super(_value, (v) => _then(v as _ConfigModelSubscriptionStatus));

  @override
  _ConfigModelSubscriptionStatus get _value => super._value as _ConfigModelSubscriptionStatus;

  @override
  $Res call({
    Object? source = freezed,
    Object? destination = freezed,
    Object? elementAddress = freezed,
    Object? subscriptionAddress = freezed,
    Object? modelIdentifier = freezed,
    Object? isSuccessful = freezed,
  }) {
    return _then(_ConfigModelSubscriptionStatus(
      source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as int,
      elementAddress == freezed
          ? _value.elementAddress
          : elementAddress // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptionAddress == freezed
          ? _value.subscriptionAddress
          : subscriptionAddress // ignore: cast_nullable_to_non_nullable
              as int,
      modelIdentifier == freezed
          ? _value.modelIdentifier
          : modelIdentifier // ignore: cast_nullable_to_non_nullable
              as int,
      isSuccessful == freezed
          ? _value.isSuccessful
          : isSuccessful // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConfigModelSubscriptionStatus implements _ConfigModelSubscriptionStatus {
  const _$_ConfigModelSubscriptionStatus(this.source, this.destination, this.elementAddress, this.subscriptionAddress,
      this.modelIdentifier, this.isSuccessful);

  factory _$_ConfigModelSubscriptionStatus.fromJson(Map<String, dynamic> json) =>
      _$_$_ConfigModelSubscriptionStatusFromJson(json);

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
  final bool isSuccessful;

  @override
  String toString() {
    return 'ConfigModelSubscriptionStatus(source: $source, destination: $destination, elementAddress: $elementAddress, subscriptionAddress: $subscriptionAddress, modelIdentifier: $modelIdentifier, isSuccessful: $isSuccessful)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConfigModelSubscriptionStatus &&
            (identical(other.source, source) || const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.destination, destination) ||
                const DeepCollectionEquality().equals(other.destination, destination)) &&
            (identical(other.elementAddress, elementAddress) ||
                const DeepCollectionEquality().equals(other.elementAddress, elementAddress)) &&
            (identical(other.subscriptionAddress, subscriptionAddress) ||
                const DeepCollectionEquality().equals(other.subscriptionAddress, subscriptionAddress)) &&
            (identical(other.modelIdentifier, modelIdentifier) ||
                const DeepCollectionEquality().equals(other.modelIdentifier, modelIdentifier)) &&
            (identical(other.isSuccessful, isSuccessful) ||
                const DeepCollectionEquality().equals(other.isSuccessful, isSuccessful)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(destination) ^
      const DeepCollectionEquality().hash(elementAddress) ^
      const DeepCollectionEquality().hash(subscriptionAddress) ^
      const DeepCollectionEquality().hash(modelIdentifier) ^
      const DeepCollectionEquality().hash(isSuccessful);

  @JsonKey(ignore: true)
  @override
  _$ConfigModelSubscriptionStatusCopyWith<_ConfigModelSubscriptionStatus> get copyWith =>
      __$ConfigModelSubscriptionStatusCopyWithImpl<_ConfigModelSubscriptionStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigModelSubscriptionStatusToJson(this);
  }
}

abstract class _ConfigModelSubscriptionStatus implements ConfigModelSubscriptionStatus {
  const factory _ConfigModelSubscriptionStatus(int source, int destination, int elementAddress, int subscriptionAddress,
      int modelIdentifier, bool isSuccessful) = _$_ConfigModelSubscriptionStatus;

  factory _ConfigModelSubscriptionStatus.fromJson(Map<String, dynamic> json) =
      _$_ConfigModelSubscriptionStatus.fromJson;

  @override
  int get source => throw _privateConstructorUsedError;
  @override
  int get destination => throw _privateConstructorUsedError;
  @override
  int get elementAddress => throw _privateConstructorUsedError;
  @override
  int get subscriptionAddress => throw _privateConstructorUsedError;
  @override
  int get modelIdentifier => throw _privateConstructorUsedError;
  @override
  bool get isSuccessful => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ConfigModelSubscriptionStatusCopyWith<_ConfigModelSubscriptionStatus> get copyWith =>
      throw _privateConstructorUsedError;
}
