// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'config_network_transmit_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ConfigNetworkTransmitStatus _$ConfigNetworkTransmitStatusFromJson(Map<String, dynamic> json) {
  return _ConfigNetworkTransmitStatus.fromJson(json);
}

/// @nodoc
class _$ConfigNetworkTransmitStatusTearOff {
  const _$ConfigNetworkTransmitStatusTearOff();

// ignore: unused_element
  _ConfigNetworkTransmitStatus call(int source, int destination, int transmitCount, int transmitIntervalSteps) {
    return _ConfigNetworkTransmitStatus(
      source,
      destination,
      transmitCount,
      transmitIntervalSteps,
    );
  }

// ignore: unused_element
  ConfigNetworkTransmitStatus fromJson(Map<String, Object> json) {
    return ConfigNetworkTransmitStatus.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ConfigNetworkTransmitStatus = _$ConfigNetworkTransmitStatusTearOff();

/// @nodoc
mixin _$ConfigNetworkTransmitStatus {
  int get source;
  int get destination;
  int get transmitCount;
  int get transmitIntervalSteps;

  Map<String, dynamic> toJson();
  $ConfigNetworkTransmitStatusCopyWith<ConfigNetworkTransmitStatus> get copyWith;
}

/// @nodoc
abstract class $ConfigNetworkTransmitStatusCopyWith<$Res> {
  factory $ConfigNetworkTransmitStatusCopyWith(
          ConfigNetworkTransmitStatus value, $Res Function(ConfigNetworkTransmitStatus) then) =
      _$ConfigNetworkTransmitStatusCopyWithImpl<$Res>;
  $Res call({int source, int destination, int transmitCount, int transmitIntervalSteps});
}

/// @nodoc
class _$ConfigNetworkTransmitStatusCopyWithImpl<$Res> implements $ConfigNetworkTransmitStatusCopyWith<$Res> {
  _$ConfigNetworkTransmitStatusCopyWithImpl(this._value, this._then);

  final ConfigNetworkTransmitStatus _value;
  // ignore: unused_field
  final $Res Function(ConfigNetworkTransmitStatus) _then;

  @override
  $Res call({
    Object source = freezed,
    Object destination = freezed,
    Object transmitCount = freezed,
    Object transmitIntervalSteps = freezed,
  }) {
    return _then(_value.copyWith(
      source: source == freezed ? _value.source : source as int,
      destination: destination == freezed ? _value.destination : destination as int,
      transmitCount: transmitCount == freezed ? _value.transmitCount : transmitCount as int,
      transmitIntervalSteps:
          transmitIntervalSteps == freezed ? _value.transmitIntervalSteps : transmitIntervalSteps as int,
    ));
  }
}

/// @nodoc
abstract class _$ConfigNetworkTransmitStatusCopyWith<$Res> implements $ConfigNetworkTransmitStatusCopyWith<$Res> {
  factory _$ConfigNetworkTransmitStatusCopyWith(
          _ConfigNetworkTransmitStatus value, $Res Function(_ConfigNetworkTransmitStatus) then) =
      __$ConfigNetworkTransmitStatusCopyWithImpl<$Res>;
  @override
  $Res call({int source, int destination, int transmitCount, int transmitIntervalSteps});
}

/// @nodoc
class __$ConfigNetworkTransmitStatusCopyWithImpl<$Res> extends _$ConfigNetworkTransmitStatusCopyWithImpl<$Res>
    implements _$ConfigNetworkTransmitStatusCopyWith<$Res> {
  __$ConfigNetworkTransmitStatusCopyWithImpl(
      _ConfigNetworkTransmitStatus _value, $Res Function(_ConfigNetworkTransmitStatus) _then)
      : super(_value, (v) => _then(v as _ConfigNetworkTransmitStatus));

  @override
  _ConfigNetworkTransmitStatus get _value => super._value as _ConfigNetworkTransmitStatus;

  @override
  $Res call({
    Object source = freezed,
    Object destination = freezed,
    Object transmitCount = freezed,
    Object transmitIntervalSteps = freezed,
  }) {
    return _then(_ConfigNetworkTransmitStatus(
      source == freezed ? _value.source : source as int,
      destination == freezed ? _value.destination : destination as int,
      transmitCount == freezed ? _value.transmitCount : transmitCount as int,
      transmitIntervalSteps == freezed ? _value.transmitIntervalSteps : transmitIntervalSteps as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_ConfigNetworkTransmitStatus implements _ConfigNetworkTransmitStatus {
  const _$_ConfigNetworkTransmitStatus(this.source, this.destination, this.transmitCount, this.transmitIntervalSteps)
      : assert(source != null),
        assert(destination != null),
        assert(transmitCount != null),
        assert(transmitIntervalSteps != null);

  factory _$_ConfigNetworkTransmitStatus.fromJson(Map<String, dynamic> json) =>
      _$_$_ConfigNetworkTransmitStatusFromJson(json);

  @override
  final int source;
  @override
  final int destination;
  @override
  final int transmitCount;
  @override
  final int transmitIntervalSteps;

  @override
  String toString() {
    return 'ConfigNetworkTransmitStatus(source: $source, destination: $destination, transmitCount: $transmitCount, transmitIntervalSteps: $transmitIntervalSteps)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConfigNetworkTransmitStatus &&
            (identical(other.source, source) || const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.destination, destination) ||
                const DeepCollectionEquality().equals(other.destination, destination)) &&
            (identical(other.transmitCount, transmitCount) ||
                const DeepCollectionEquality().equals(other.transmitCount, transmitCount)) &&
            (identical(other.transmitIntervalSteps, transmitIntervalSteps) ||
                const DeepCollectionEquality().equals(other.transmitIntervalSteps, transmitIntervalSteps)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(destination) ^
      const DeepCollectionEquality().hash(transmitCount) ^
      const DeepCollectionEquality().hash(transmitIntervalSteps);

  @override
  _$ConfigNetworkTransmitStatusCopyWith<_ConfigNetworkTransmitStatus> get copyWith =>
      __$ConfigNetworkTransmitStatusCopyWithImpl<_ConfigNetworkTransmitStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigNetworkTransmitStatusToJson(this);
  }
}

abstract class _ConfigNetworkTransmitStatus implements ConfigNetworkTransmitStatus {
  const factory _ConfigNetworkTransmitStatus(
      int source, int destination, int transmitCount, int transmitIntervalSteps) = _$_ConfigNetworkTransmitStatus;

  factory _ConfigNetworkTransmitStatus.fromJson(Map<String, dynamic> json) = _$_ConfigNetworkTransmitStatus.fromJson;

  @override
  int get source;
  @override
  int get destination;
  @override
  int get transmitCount;
  @override
  int get transmitIntervalSteps;
  @override
  _$ConfigNetworkTransmitStatusCopyWith<_ConfigNetworkTransmitStatus> get copyWith;
}
