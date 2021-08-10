// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'mesh_network_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MeshNetworkEventData _$MeshNetworkEventDataFromJson(Map<String, dynamic> json) {
  return _MeshNetworkEventData.fromJson(json);
}

/// @nodoc
class _$MeshNetworkEventDataTearOff {
  const _$MeshNetworkEventDataTearOff();

  _MeshNetworkEventData call(String id) {
    return _MeshNetworkEventData(
      id,
    );
  }

  MeshNetworkEventData fromJson(Map<String, Object> json) {
    return MeshNetworkEventData.fromJson(json);
  }
}

/// @nodoc
const $MeshNetworkEventData = _$MeshNetworkEventDataTearOff();

/// @nodoc
mixin _$MeshNetworkEventData {
  String get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeshNetworkEventDataCopyWith<MeshNetworkEventData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeshNetworkEventDataCopyWith<$Res> {
  factory $MeshNetworkEventDataCopyWith(MeshNetworkEventData value, $Res Function(MeshNetworkEventData) then) =
      _$MeshNetworkEventDataCopyWithImpl<$Res>;
  $Res call({String id});
}

/// @nodoc
class _$MeshNetworkEventDataCopyWithImpl<$Res> implements $MeshNetworkEventDataCopyWith<$Res> {
  _$MeshNetworkEventDataCopyWithImpl(this._value, this._then);

  final MeshNetworkEventData _value;
  // ignore: unused_field
  final $Res Function(MeshNetworkEventData) _then;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$MeshNetworkEventDataCopyWith<$Res> implements $MeshNetworkEventDataCopyWith<$Res> {
  factory _$MeshNetworkEventDataCopyWith(_MeshNetworkEventData value, $Res Function(_MeshNetworkEventData) then) =
      __$MeshNetworkEventDataCopyWithImpl<$Res>;
  @override
  $Res call({String id});
}

/// @nodoc
class __$MeshNetworkEventDataCopyWithImpl<$Res> extends _$MeshNetworkEventDataCopyWithImpl<$Res>
    implements _$MeshNetworkEventDataCopyWith<$Res> {
  __$MeshNetworkEventDataCopyWithImpl(_MeshNetworkEventData _value, $Res Function(_MeshNetworkEventData) _then)
      : super(_value, (v) => _then(v as _MeshNetworkEventData));

  @override
  _MeshNetworkEventData get _value => super._value as _MeshNetworkEventData;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_MeshNetworkEventData(
      id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MeshNetworkEventData implements _MeshNetworkEventData {
  const _$_MeshNetworkEventData(this.id);

  factory _$_MeshNetworkEventData.fromJson(Map<String, dynamic> json) => _$_$_MeshNetworkEventDataFromJson(json);

  @override
  final String id;

  @override
  String toString() {
    return 'MeshNetworkEventData(id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MeshNetworkEventData &&
            (identical(other.id, id) || const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  int get hashCode => runtimeType.hashCode ^ const DeepCollectionEquality().hash(id);

  @JsonKey(ignore: true)
  @override
  _$MeshNetworkEventDataCopyWith<_MeshNetworkEventData> get copyWith =>
      __$MeshNetworkEventDataCopyWithImpl<_MeshNetworkEventData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MeshNetworkEventDataToJson(this);
  }
}

abstract class _MeshNetworkEventData implements MeshNetworkEventData {
  const factory _MeshNetworkEventData(String id) = _$_MeshNetworkEventData;

  factory _MeshNetworkEventData.fromJson(Map<String, dynamic> json) = _$_MeshNetworkEventData.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MeshNetworkEventDataCopyWith<_MeshNetworkEventData> get copyWith => throw _privateConstructorUsedError;
}

MeshNetworkEventError _$MeshNetworkEventErrorFromJson(Map<String, dynamic> json) {
  return _MeshNetworkEventError.fromJson(json);
}

/// @nodoc
class _$MeshNetworkEventErrorTearOff {
  const _$MeshNetworkEventErrorTearOff();

  _MeshNetworkEventError call(String error) {
    return _MeshNetworkEventError(
      error,
    );
  }

  MeshNetworkEventError fromJson(Map<String, Object> json) {
    return MeshNetworkEventError.fromJson(json);
  }
}

/// @nodoc
const $MeshNetworkEventError = _$MeshNetworkEventErrorTearOff();

/// @nodoc
mixin _$MeshNetworkEventError {
  String get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeshNetworkEventErrorCopyWith<MeshNetworkEventError> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeshNetworkEventErrorCopyWith<$Res> {
  factory $MeshNetworkEventErrorCopyWith(MeshNetworkEventError value, $Res Function(MeshNetworkEventError) then) =
      _$MeshNetworkEventErrorCopyWithImpl<$Res>;
  $Res call({String error});
}

/// @nodoc
class _$MeshNetworkEventErrorCopyWithImpl<$Res> implements $MeshNetworkEventErrorCopyWith<$Res> {
  _$MeshNetworkEventErrorCopyWithImpl(this._value, this._then);

  final MeshNetworkEventError _value;
  // ignore: unused_field
  final $Res Function(MeshNetworkEventError) _then;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$MeshNetworkEventErrorCopyWith<$Res> implements $MeshNetworkEventErrorCopyWith<$Res> {
  factory _$MeshNetworkEventErrorCopyWith(_MeshNetworkEventError value, $Res Function(_MeshNetworkEventError) then) =
      __$MeshNetworkEventErrorCopyWithImpl<$Res>;
  @override
  $Res call({String error});
}

/// @nodoc
class __$MeshNetworkEventErrorCopyWithImpl<$Res> extends _$MeshNetworkEventErrorCopyWithImpl<$Res>
    implements _$MeshNetworkEventErrorCopyWith<$Res> {
  __$MeshNetworkEventErrorCopyWithImpl(_MeshNetworkEventError _value, $Res Function(_MeshNetworkEventError) _then)
      : super(_value, (v) => _then(v as _MeshNetworkEventError));

  @override
  _MeshNetworkEventError get _value => super._value as _MeshNetworkEventError;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(_MeshNetworkEventError(
      error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MeshNetworkEventError implements _MeshNetworkEventError {
  const _$_MeshNetworkEventError(this.error);

  factory _$_MeshNetworkEventError.fromJson(Map<String, dynamic> json) => _$_$_MeshNetworkEventErrorFromJson(json);

  @override
  final String error;

  @override
  String toString() {
    return 'MeshNetworkEventError(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MeshNetworkEventError &&
            (identical(other.error, error) || const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode => runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  _$MeshNetworkEventErrorCopyWith<_MeshNetworkEventError> get copyWith =>
      __$MeshNetworkEventErrorCopyWithImpl<_MeshNetworkEventError>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MeshNetworkEventErrorToJson(this);
  }
}

abstract class _MeshNetworkEventError implements MeshNetworkEventError {
  const factory _MeshNetworkEventError(String error) = _$_MeshNetworkEventError;

  factory _MeshNetworkEventError.fromJson(Map<String, dynamic> json) = _$_MeshNetworkEventError.fromJson;

  @override
  String get error => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MeshNetworkEventErrorCopyWith<_MeshNetworkEventError> get copyWith => throw _privateConstructorUsedError;
}
