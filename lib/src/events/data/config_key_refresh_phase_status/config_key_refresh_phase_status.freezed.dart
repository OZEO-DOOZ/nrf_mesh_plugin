// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'config_key_refresh_phase_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConfigKeyRefreshPhaseStatus _$ConfigKeyRefreshPhaseStatusFromJson(
    Map<String, dynamic> json) {
  return _ConfigKeyRefreshPhaseStatus.fromJson(json);
}

/// @nodoc
class _$ConfigKeyRefreshPhaseStatusTearOff {
  const _$ConfigKeyRefreshPhaseStatusTearOff();

  _ConfigKeyRefreshPhaseStatus call(int source, int destination, int statusCode,
      String statusCodeName, int netKeyIndex, int transition) {
    return _ConfigKeyRefreshPhaseStatus(
      source,
      destination,
      statusCode,
      statusCodeName,
      netKeyIndex,
      transition,
    );
  }

  ConfigKeyRefreshPhaseStatus fromJson(Map<String, Object> json) {
    return ConfigKeyRefreshPhaseStatus.fromJson(json);
  }
}

/// @nodoc
const $ConfigKeyRefreshPhaseStatus = _$ConfigKeyRefreshPhaseStatusTearOff();

/// @nodoc
mixin _$ConfigKeyRefreshPhaseStatus {
  int get source => throw _privateConstructorUsedError;
  int get destination => throw _privateConstructorUsedError;
  int get statusCode => throw _privateConstructorUsedError;
  String get statusCodeName => throw _privateConstructorUsedError;
  int get netKeyIndex => throw _privateConstructorUsedError;
  int get transition => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigKeyRefreshPhaseStatusCopyWith<ConfigKeyRefreshPhaseStatus>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigKeyRefreshPhaseStatusCopyWith<$Res> {
  factory $ConfigKeyRefreshPhaseStatusCopyWith(
          ConfigKeyRefreshPhaseStatus value,
          $Res Function(ConfigKeyRefreshPhaseStatus) then) =
      _$ConfigKeyRefreshPhaseStatusCopyWithImpl<$Res>;
  $Res call(
      {int source,
      int destination,
      int statusCode,
      String statusCodeName,
      int netKeyIndex,
      int transition});
}

/// @nodoc
class _$ConfigKeyRefreshPhaseStatusCopyWithImpl<$Res>
    implements $ConfigKeyRefreshPhaseStatusCopyWith<$Res> {
  _$ConfigKeyRefreshPhaseStatusCopyWithImpl(this._value, this._then);

  final ConfigKeyRefreshPhaseStatus _value;
  // ignore: unused_field
  final $Res Function(ConfigKeyRefreshPhaseStatus) _then;

  @override
  $Res call({
    Object? source = freezed,
    Object? destination = freezed,
    Object? statusCode = freezed,
    Object? statusCodeName = freezed,
    Object? netKeyIndex = freezed,
    Object? transition = freezed,
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
      statusCode: statusCode == freezed
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      statusCodeName: statusCodeName == freezed
          ? _value.statusCodeName
          : statusCodeName // ignore: cast_nullable_to_non_nullable
              as String,
      netKeyIndex: netKeyIndex == freezed
          ? _value.netKeyIndex
          : netKeyIndex // ignore: cast_nullable_to_non_nullable
              as int,
      transition: transition == freezed
          ? _value.transition
          : transition // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$ConfigKeyRefreshPhaseStatusCopyWith<$Res>
    implements $ConfigKeyRefreshPhaseStatusCopyWith<$Res> {
  factory _$ConfigKeyRefreshPhaseStatusCopyWith(
          _ConfigKeyRefreshPhaseStatus value,
          $Res Function(_ConfigKeyRefreshPhaseStatus) then) =
      __$ConfigKeyRefreshPhaseStatusCopyWithImpl<$Res>;
  @override
  $Res call(
      {int source,
      int destination,
      int statusCode,
      String statusCodeName,
      int netKeyIndex,
      int transition});
}

/// @nodoc
class __$ConfigKeyRefreshPhaseStatusCopyWithImpl<$Res>
    extends _$ConfigKeyRefreshPhaseStatusCopyWithImpl<$Res>
    implements _$ConfigKeyRefreshPhaseStatusCopyWith<$Res> {
  __$ConfigKeyRefreshPhaseStatusCopyWithImpl(
      _ConfigKeyRefreshPhaseStatus _value,
      $Res Function(_ConfigKeyRefreshPhaseStatus) _then)
      : super(_value, (v) => _then(v as _ConfigKeyRefreshPhaseStatus));

  @override
  _ConfigKeyRefreshPhaseStatus get _value =>
      super._value as _ConfigKeyRefreshPhaseStatus;

  @override
  $Res call({
    Object? source = freezed,
    Object? destination = freezed,
    Object? statusCode = freezed,
    Object? statusCodeName = freezed,
    Object? netKeyIndex = freezed,
    Object? transition = freezed,
  }) {
    return _then(_ConfigKeyRefreshPhaseStatus(
      source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as int,
      statusCode == freezed
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      statusCodeName == freezed
          ? _value.statusCodeName
          : statusCodeName // ignore: cast_nullable_to_non_nullable
              as String,
      netKeyIndex == freezed
          ? _value.netKeyIndex
          : netKeyIndex // ignore: cast_nullable_to_non_nullable
              as int,
      transition == freezed
          ? _value.transition
          : transition // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConfigKeyRefreshPhaseStatus implements _ConfigKeyRefreshPhaseStatus {
  const _$_ConfigKeyRefreshPhaseStatus(this.source, this.destination,
      this.statusCode, this.statusCodeName, this.netKeyIndex, this.transition);

  factory _$_ConfigKeyRefreshPhaseStatus.fromJson(Map<String, dynamic> json) =>
      _$_$_ConfigKeyRefreshPhaseStatusFromJson(json);

  @override
  final int source;
  @override
  final int destination;
  @override
  final int statusCode;
  @override
  final String statusCodeName;
  @override
  final int netKeyIndex;
  @override
  final int transition;

  @override
  String toString() {
    return 'ConfigKeyRefreshPhaseStatus(source: $source, destination: $destination, statusCode: $statusCode, statusCodeName: $statusCodeName, netKeyIndex: $netKeyIndex, transition: $transition)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConfigKeyRefreshPhaseStatus &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.destination, destination) ||
                const DeepCollectionEquality()
                    .equals(other.destination, destination)) &&
            (identical(other.statusCode, statusCode) ||
                const DeepCollectionEquality()
                    .equals(other.statusCode, statusCode)) &&
            (identical(other.statusCodeName, statusCodeName) ||
                const DeepCollectionEquality()
                    .equals(other.statusCodeName, statusCodeName)) &&
            (identical(other.netKeyIndex, netKeyIndex) ||
                const DeepCollectionEquality()
                    .equals(other.netKeyIndex, netKeyIndex)) &&
            (identical(other.transition, transition) ||
                const DeepCollectionEquality()
                    .equals(other.transition, transition)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(destination) ^
      const DeepCollectionEquality().hash(statusCode) ^
      const DeepCollectionEquality().hash(statusCodeName) ^
      const DeepCollectionEquality().hash(netKeyIndex) ^
      const DeepCollectionEquality().hash(transition);

  @JsonKey(ignore: true)
  @override
  _$ConfigKeyRefreshPhaseStatusCopyWith<_ConfigKeyRefreshPhaseStatus>
      get copyWith => __$ConfigKeyRefreshPhaseStatusCopyWithImpl<
          _ConfigKeyRefreshPhaseStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigKeyRefreshPhaseStatusToJson(this);
  }
}

abstract class _ConfigKeyRefreshPhaseStatus
    implements ConfigKeyRefreshPhaseStatus {
  const factory _ConfigKeyRefreshPhaseStatus(
      int source,
      int destination,
      int statusCode,
      String statusCodeName,
      int netKeyIndex,
      int transition) = _$_ConfigKeyRefreshPhaseStatus;

  factory _ConfigKeyRefreshPhaseStatus.fromJson(Map<String, dynamic> json) =
      _$_ConfigKeyRefreshPhaseStatus.fromJson;

  @override
  int get source => throw _privateConstructorUsedError;
  @override
  int get destination => throw _privateConstructorUsedError;
  @override
  int get statusCode => throw _privateConstructorUsedError;
  @override
  String get statusCodeName => throw _privateConstructorUsedError;
  @override
  int get netKeyIndex => throw _privateConstructorUsedError;
  @override
  int get transition => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ConfigKeyRefreshPhaseStatusCopyWith<_ConfigKeyRefreshPhaseStatus>
      get copyWith => throw _privateConstructorUsedError;
}
