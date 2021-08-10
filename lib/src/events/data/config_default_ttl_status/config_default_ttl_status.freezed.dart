// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'config_default_ttl_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConfigDefaultTtlStatus _$ConfigDefaultTtlStatusFromJson(Map<String, dynamic> json) {
  return _ConfigDefaultTtlStatus.fromJson(json);
}

/// @nodoc
class _$ConfigDefaultTtlStatusTearOff {
  const _$ConfigDefaultTtlStatusTearOff();

  _ConfigDefaultTtlStatus call(int source, int destination, int ttl) {
    return _ConfigDefaultTtlStatus(
      source,
      destination,
      ttl,
    );
  }

  ConfigDefaultTtlStatus fromJson(Map<String, Object> json) {
    return ConfigDefaultTtlStatus.fromJson(json);
  }
}

/// @nodoc
const $ConfigDefaultTtlStatus = _$ConfigDefaultTtlStatusTearOff();

/// @nodoc
mixin _$ConfigDefaultTtlStatus {
  int get source => throw _privateConstructorUsedError;
  int get destination => throw _privateConstructorUsedError;
  int get ttl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigDefaultTtlStatusCopyWith<ConfigDefaultTtlStatus> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigDefaultTtlStatusCopyWith<$Res> {
  factory $ConfigDefaultTtlStatusCopyWith(ConfigDefaultTtlStatus value, $Res Function(ConfigDefaultTtlStatus) then) =
      _$ConfigDefaultTtlStatusCopyWithImpl<$Res>;
  $Res call({int source, int destination, int ttl});
}

/// @nodoc
class _$ConfigDefaultTtlStatusCopyWithImpl<$Res> implements $ConfigDefaultTtlStatusCopyWith<$Res> {
  _$ConfigDefaultTtlStatusCopyWithImpl(this._value, this._then);

  final ConfigDefaultTtlStatus _value;
  // ignore: unused_field
  final $Res Function(ConfigDefaultTtlStatus) _then;

  @override
  $Res call({
    Object? source = freezed,
    Object? destination = freezed,
    Object? ttl = freezed,
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
      ttl: ttl == freezed
          ? _value.ttl
          : ttl // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$ConfigDefaultTtlStatusCopyWith<$Res> implements $ConfigDefaultTtlStatusCopyWith<$Res> {
  factory _$ConfigDefaultTtlStatusCopyWith(_ConfigDefaultTtlStatus value, $Res Function(_ConfigDefaultTtlStatus) then) =
      __$ConfigDefaultTtlStatusCopyWithImpl<$Res>;
  @override
  $Res call({int source, int destination, int ttl});
}

/// @nodoc
class __$ConfigDefaultTtlStatusCopyWithImpl<$Res> extends _$ConfigDefaultTtlStatusCopyWithImpl<$Res>
    implements _$ConfigDefaultTtlStatusCopyWith<$Res> {
  __$ConfigDefaultTtlStatusCopyWithImpl(_ConfigDefaultTtlStatus _value, $Res Function(_ConfigDefaultTtlStatus) _then)
      : super(_value, (v) => _then(v as _ConfigDefaultTtlStatus));

  @override
  _ConfigDefaultTtlStatus get _value => super._value as _ConfigDefaultTtlStatus;

  @override
  $Res call({
    Object? source = freezed,
    Object? destination = freezed,
    Object? ttl = freezed,
  }) {
    return _then(_ConfigDefaultTtlStatus(
      source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as int,
      ttl == freezed
          ? _value.ttl
          : ttl // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConfigDefaultTtlStatus implements _ConfigDefaultTtlStatus {
  const _$_ConfigDefaultTtlStatus(this.source, this.destination, this.ttl);

  factory _$_ConfigDefaultTtlStatus.fromJson(Map<String, dynamic> json) => _$_$_ConfigDefaultTtlStatusFromJson(json);

  @override
  final int source;
  @override
  final int destination;
  @override
  final int ttl;

  @override
  String toString() {
    return 'ConfigDefaultTtlStatus(source: $source, destination: $destination, ttl: $ttl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConfigDefaultTtlStatus &&
            (identical(other.source, source) || const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.destination, destination) ||
                const DeepCollectionEquality().equals(other.destination, destination)) &&
            (identical(other.ttl, ttl) || const DeepCollectionEquality().equals(other.ttl, ttl)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(destination) ^
      const DeepCollectionEquality().hash(ttl);

  @JsonKey(ignore: true)
  @override
  _$ConfigDefaultTtlStatusCopyWith<_ConfigDefaultTtlStatus> get copyWith =>
      __$ConfigDefaultTtlStatusCopyWithImpl<_ConfigDefaultTtlStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigDefaultTtlStatusToJson(this);
  }
}

abstract class _ConfigDefaultTtlStatus implements ConfigDefaultTtlStatus {
  const factory _ConfigDefaultTtlStatus(int source, int destination, int ttl) = _$_ConfigDefaultTtlStatus;

  factory _ConfigDefaultTtlStatus.fromJson(Map<String, dynamic> json) = _$_ConfigDefaultTtlStatus.fromJson;

  @override
  int get source => throw _privateConstructorUsedError;
  @override
  int get destination => throw _privateConstructorUsedError;
  @override
  int get ttl => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ConfigDefaultTtlStatusCopyWith<_ConfigDefaultTtlStatus> get copyWith => throw _privateConstructorUsedError;
}
