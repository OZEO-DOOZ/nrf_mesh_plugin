// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'config_beacon_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConfigBeaconStatus _$ConfigBeaconStatusFromJson(Map<String, dynamic> json) {
  return _ConfigBeaconStatus.fromJson(json);
}

/// @nodoc
class _$ConfigBeaconStatusTearOff {
  const _$ConfigBeaconStatusTearOff();

  _ConfigBeaconStatus call(int source, int destination, bool enable) {
    return _ConfigBeaconStatus(
      source,
      destination,
      enable,
    );
  }

  ConfigBeaconStatus fromJson(Map<String, Object> json) {
    return ConfigBeaconStatus.fromJson(json);
  }
}

/// @nodoc
const $ConfigBeaconStatus = _$ConfigBeaconStatusTearOff();

/// @nodoc
mixin _$ConfigBeaconStatus {
  int get source => throw _privateConstructorUsedError;
  int get destination => throw _privateConstructorUsedError;
  bool get enable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigBeaconStatusCopyWith<ConfigBeaconStatus> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigBeaconStatusCopyWith<$Res> {
  factory $ConfigBeaconStatusCopyWith(ConfigBeaconStatus value, $Res Function(ConfigBeaconStatus) then) =
      _$ConfigBeaconStatusCopyWithImpl<$Res>;
  $Res call({int source, int destination, bool enable});
}

/// @nodoc
class _$ConfigBeaconStatusCopyWithImpl<$Res> implements $ConfigBeaconStatusCopyWith<$Res> {
  _$ConfigBeaconStatusCopyWithImpl(this._value, this._then);

  final ConfigBeaconStatus _value;
  // ignore: unused_field
  final $Res Function(ConfigBeaconStatus) _then;

  @override
  $Res call({
    Object? source = freezed,
    Object? destination = freezed,
    Object? enable = freezed,
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
      enable: enable == freezed
          ? _value.enable
          : enable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$ConfigBeaconStatusCopyWith<$Res> implements $ConfigBeaconStatusCopyWith<$Res> {
  factory _$ConfigBeaconStatusCopyWith(_ConfigBeaconStatus value, $Res Function(_ConfigBeaconStatus) then) =
      __$ConfigBeaconStatusCopyWithImpl<$Res>;
  @override
  $Res call({int source, int destination, bool enable});
}

/// @nodoc
class __$ConfigBeaconStatusCopyWithImpl<$Res> extends _$ConfigBeaconStatusCopyWithImpl<$Res>
    implements _$ConfigBeaconStatusCopyWith<$Res> {
  __$ConfigBeaconStatusCopyWithImpl(_ConfigBeaconStatus _value, $Res Function(_ConfigBeaconStatus) _then)
      : super(_value, (v) => _then(v as _ConfigBeaconStatus));

  @override
  _ConfigBeaconStatus get _value => super._value as _ConfigBeaconStatus;

  @override
  $Res call({
    Object? source = freezed,
    Object? destination = freezed,
    Object? enable = freezed,
  }) {
    return _then(_ConfigBeaconStatus(
      source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as int,
      enable == freezed
          ? _value.enable
          : enable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConfigBeaconStatus implements _ConfigBeaconStatus {
  const _$_ConfigBeaconStatus(this.source, this.destination, this.enable);

  factory _$_ConfigBeaconStatus.fromJson(Map<String, dynamic> json) => _$_$_ConfigBeaconStatusFromJson(json);

  @override
  final int source;
  @override
  final int destination;
  @override
  final bool enable;

  @override
  String toString() {
    return 'ConfigBeaconStatus(source: $source, destination: $destination, enable: $enable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConfigBeaconStatus &&
            (identical(other.source, source) || const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.destination, destination) ||
                const DeepCollectionEquality().equals(other.destination, destination)) &&
            (identical(other.enable, enable) || const DeepCollectionEquality().equals(other.enable, enable)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(destination) ^
      const DeepCollectionEquality().hash(enable);

  @JsonKey(ignore: true)
  @override
  _$ConfigBeaconStatusCopyWith<_ConfigBeaconStatus> get copyWith =>
      __$ConfigBeaconStatusCopyWithImpl<_ConfigBeaconStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigBeaconStatusToJson(this);
  }
}

abstract class _ConfigBeaconStatus implements ConfigBeaconStatus {
  const factory _ConfigBeaconStatus(int source, int destination, bool enable) = _$_ConfigBeaconStatus;

  factory _ConfigBeaconStatus.fromJson(Map<String, dynamic> json) = _$_ConfigBeaconStatus.fromJson;

  @override
  int get source => throw _privateConstructorUsedError;
  @override
  int get destination => throw _privateConstructorUsedError;
  @override
  bool get enable => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ConfigBeaconStatusCopyWith<_ConfigBeaconStatus> get copyWith => throw _privateConstructorUsedError;
}
