// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'config_model_app_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConfigModelAppStatusData _$ConfigModelAppStatusDataFromJson(Map<String, dynamic> json) {
  return _ConfigModelAppStatusData.fromJson(json);
}

/// @nodoc
class _$ConfigModelAppStatusDataTearOff {
  const _$ConfigModelAppStatusDataTearOff();

  _ConfigModelAppStatusData call(int elementAddress, int modelId, int appKeyIndex) {
    return _ConfigModelAppStatusData(
      elementAddress,
      modelId,
      appKeyIndex,
    );
  }

  ConfigModelAppStatusData fromJson(Map<String, Object> json) {
    return ConfigModelAppStatusData.fromJson(json);
  }
}

/// @nodoc
const $ConfigModelAppStatusData = _$ConfigModelAppStatusDataTearOff();

/// @nodoc
mixin _$ConfigModelAppStatusData {
  int get elementAddress => throw _privateConstructorUsedError;
  int get modelId => throw _privateConstructorUsedError;
  int get appKeyIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigModelAppStatusDataCopyWith<ConfigModelAppStatusData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigModelAppStatusDataCopyWith<$Res> {
  factory $ConfigModelAppStatusDataCopyWith(
          ConfigModelAppStatusData value, $Res Function(ConfigModelAppStatusData) then) =
      _$ConfigModelAppStatusDataCopyWithImpl<$Res>;
  $Res call({int elementAddress, int modelId, int appKeyIndex});
}

/// @nodoc
class _$ConfigModelAppStatusDataCopyWithImpl<$Res> implements $ConfigModelAppStatusDataCopyWith<$Res> {
  _$ConfigModelAppStatusDataCopyWithImpl(this._value, this._then);

  final ConfigModelAppStatusData _value;
  // ignore: unused_field
  final $Res Function(ConfigModelAppStatusData) _then;

  @override
  $Res call({
    Object? elementAddress = freezed,
    Object? modelId = freezed,
    Object? appKeyIndex = freezed,
  }) {
    return _then(_value.copyWith(
      elementAddress: elementAddress == freezed
          ? _value.elementAddress
          : elementAddress // ignore: cast_nullable_to_non_nullable
              as int,
      modelId: modelId == freezed
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as int,
      appKeyIndex: appKeyIndex == freezed
          ? _value.appKeyIndex
          : appKeyIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$ConfigModelAppStatusDataCopyWith<$Res> implements $ConfigModelAppStatusDataCopyWith<$Res> {
  factory _$ConfigModelAppStatusDataCopyWith(
          _ConfigModelAppStatusData value, $Res Function(_ConfigModelAppStatusData) then) =
      __$ConfigModelAppStatusDataCopyWithImpl<$Res>;
  @override
  $Res call({int elementAddress, int modelId, int appKeyIndex});
}

/// @nodoc
class __$ConfigModelAppStatusDataCopyWithImpl<$Res> extends _$ConfigModelAppStatusDataCopyWithImpl<$Res>
    implements _$ConfigModelAppStatusDataCopyWith<$Res> {
  __$ConfigModelAppStatusDataCopyWithImpl(
      _ConfigModelAppStatusData _value, $Res Function(_ConfigModelAppStatusData) _then)
      : super(_value, (v) => _then(v as _ConfigModelAppStatusData));

  @override
  _ConfigModelAppStatusData get _value => super._value as _ConfigModelAppStatusData;

  @override
  $Res call({
    Object? elementAddress = freezed,
    Object? modelId = freezed,
    Object? appKeyIndex = freezed,
  }) {
    return _then(_ConfigModelAppStatusData(
      elementAddress == freezed
          ? _value.elementAddress
          : elementAddress // ignore: cast_nullable_to_non_nullable
              as int,
      modelId == freezed
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as int,
      appKeyIndex == freezed
          ? _value.appKeyIndex
          : appKeyIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConfigModelAppStatusData implements _ConfigModelAppStatusData {
  const _$_ConfigModelAppStatusData(this.elementAddress, this.modelId, this.appKeyIndex);

  factory _$_ConfigModelAppStatusData.fromJson(Map<String, dynamic> json) =>
      _$_$_ConfigModelAppStatusDataFromJson(json);

  @override
  final int elementAddress;
  @override
  final int modelId;
  @override
  final int appKeyIndex;

  @override
  String toString() {
    return 'ConfigModelAppStatusData(elementAddress: $elementAddress, modelId: $modelId, appKeyIndex: $appKeyIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConfigModelAppStatusData &&
            (identical(other.elementAddress, elementAddress) ||
                const DeepCollectionEquality().equals(other.elementAddress, elementAddress)) &&
            (identical(other.modelId, modelId) || const DeepCollectionEquality().equals(other.modelId, modelId)) &&
            (identical(other.appKeyIndex, appKeyIndex) ||
                const DeepCollectionEquality().equals(other.appKeyIndex, appKeyIndex)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(elementAddress) ^
      const DeepCollectionEquality().hash(modelId) ^
      const DeepCollectionEquality().hash(appKeyIndex);

  @JsonKey(ignore: true)
  @override
  _$ConfigModelAppStatusDataCopyWith<_ConfigModelAppStatusData> get copyWith =>
      __$ConfigModelAppStatusDataCopyWithImpl<_ConfigModelAppStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigModelAppStatusDataToJson(this);
  }
}

abstract class _ConfigModelAppStatusData implements ConfigModelAppStatusData {
  const factory _ConfigModelAppStatusData(int elementAddress, int modelId, int appKeyIndex) =
      _$_ConfigModelAppStatusData;

  factory _ConfigModelAppStatusData.fromJson(Map<String, dynamic> json) = _$_ConfigModelAppStatusData.fromJson;

  @override
  int get elementAddress => throw _privateConstructorUsedError;
  @override
  int get modelId => throw _privateConstructorUsedError;
  @override
  int get appKeyIndex => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ConfigModelAppStatusDataCopyWith<_ConfigModelAppStatusData> get copyWith => throw _privateConstructorUsedError;
}
