// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'config_composition_data_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConfigCompositionDataStatusData _$ConfigCompositionDataStatusDataFromJson(Map<String, dynamic> json) {
  return _ConfigCompositionDataStatusData.fromJson(json);
}

/// @nodoc
class _$ConfigCompositionDataStatusDataTearOff {
  const _$ConfigCompositionDataStatusDataTearOff();

  _ConfigCompositionDataStatusData call(int source, ConfigCompositionDataStatusMeshMessage meshMessage) {
    return _ConfigCompositionDataStatusData(
      source,
      meshMessage,
    );
  }

  ConfigCompositionDataStatusData fromJson(Map<String, Object> json) {
    return ConfigCompositionDataStatusData.fromJson(json);
  }
}

/// @nodoc
const $ConfigCompositionDataStatusData = _$ConfigCompositionDataStatusDataTearOff();

/// @nodoc
mixin _$ConfigCompositionDataStatusData {
  int get source => throw _privateConstructorUsedError;
  ConfigCompositionDataStatusMeshMessage get meshMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigCompositionDataStatusDataCopyWith<ConfigCompositionDataStatusData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigCompositionDataStatusDataCopyWith<$Res> {
  factory $ConfigCompositionDataStatusDataCopyWith(
          ConfigCompositionDataStatusData value, $Res Function(ConfigCompositionDataStatusData) then) =
      _$ConfigCompositionDataStatusDataCopyWithImpl<$Res>;
  $Res call({int source, ConfigCompositionDataStatusMeshMessage meshMessage});

  $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> get meshMessage;
}

/// @nodoc
class _$ConfigCompositionDataStatusDataCopyWithImpl<$Res> implements $ConfigCompositionDataStatusDataCopyWith<$Res> {
  _$ConfigCompositionDataStatusDataCopyWithImpl(this._value, this._then);

  final ConfigCompositionDataStatusData _value;
  // ignore: unused_field
  final $Res Function(ConfigCompositionDataStatusData) _then;

  @override
  $Res call({
    Object? source = freezed,
    Object? meshMessage = freezed,
  }) {
    return _then(_value.copyWith(
      source: source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      meshMessage: meshMessage == freezed
          ? _value.meshMessage
          : meshMessage // ignore: cast_nullable_to_non_nullable
              as ConfigCompositionDataStatusMeshMessage,
    ));
  }

  @override
  $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> get meshMessage {
    return $ConfigCompositionDataStatusMeshMessageCopyWith<$Res>(_value.meshMessage, (value) {
      return _then(_value.copyWith(meshMessage: value));
    });
  }
}

/// @nodoc
abstract class _$ConfigCompositionDataStatusDataCopyWith<$Res>
    implements $ConfigCompositionDataStatusDataCopyWith<$Res> {
  factory _$ConfigCompositionDataStatusDataCopyWith(
          _ConfigCompositionDataStatusData value, $Res Function(_ConfigCompositionDataStatusData) then) =
      __$ConfigCompositionDataStatusDataCopyWithImpl<$Res>;
  @override
  $Res call({int source, ConfigCompositionDataStatusMeshMessage meshMessage});

  @override
  $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> get meshMessage;
}

/// @nodoc
class __$ConfigCompositionDataStatusDataCopyWithImpl<$Res> extends _$ConfigCompositionDataStatusDataCopyWithImpl<$Res>
    implements _$ConfigCompositionDataStatusDataCopyWith<$Res> {
  __$ConfigCompositionDataStatusDataCopyWithImpl(
      _ConfigCompositionDataStatusData _value, $Res Function(_ConfigCompositionDataStatusData) _then)
      : super(_value, (v) => _then(v as _ConfigCompositionDataStatusData));

  @override
  _ConfigCompositionDataStatusData get _value => super._value as _ConfigCompositionDataStatusData;

  @override
  $Res call({
    Object? source = freezed,
    Object? meshMessage = freezed,
  }) {
    return _then(_ConfigCompositionDataStatusData(
      source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      meshMessage == freezed
          ? _value.meshMessage
          : meshMessage // ignore: cast_nullable_to_non_nullable
              as ConfigCompositionDataStatusMeshMessage,
    ));
  }
}

/// @nodoc

@JsonSerializable(anyMap: true)
class _$_ConfigCompositionDataStatusData implements _ConfigCompositionDataStatusData {
  const _$_ConfigCompositionDataStatusData(this.source, this.meshMessage);

  factory _$_ConfigCompositionDataStatusData.fromJson(Map<String, dynamic> json) =>
      _$_$_ConfigCompositionDataStatusDataFromJson(json);

  @override
  final int source;
  @override
  final ConfigCompositionDataStatusMeshMessage meshMessage;

  @override
  String toString() {
    return 'ConfigCompositionDataStatusData(source: $source, meshMessage: $meshMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConfigCompositionDataStatusData &&
            (identical(other.source, source) || const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.meshMessage, meshMessage) ||
                const DeepCollectionEquality().equals(other.meshMessage, meshMessage)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(meshMessage);

  @JsonKey(ignore: true)
  @override
  _$ConfigCompositionDataStatusDataCopyWith<_ConfigCompositionDataStatusData> get copyWith =>
      __$ConfigCompositionDataStatusDataCopyWithImpl<_ConfigCompositionDataStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigCompositionDataStatusDataToJson(this);
  }
}

abstract class _ConfigCompositionDataStatusData implements ConfigCompositionDataStatusData {
  const factory _ConfigCompositionDataStatusData(int source, ConfigCompositionDataStatusMeshMessage meshMessage) =
      _$_ConfigCompositionDataStatusData;

  factory _ConfigCompositionDataStatusData.fromJson(Map<String, dynamic> json) =
      _$_ConfigCompositionDataStatusData.fromJson;

  @override
  int get source => throw _privateConstructorUsedError;
  @override
  ConfigCompositionDataStatusMeshMessage get meshMessage => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ConfigCompositionDataStatusDataCopyWith<_ConfigCompositionDataStatusData> get copyWith =>
      throw _privateConstructorUsedError;
}

ConfigCompositionDataStatusMeshMessage _$ConfigCompositionDataStatusMeshMessageFromJson(Map<String, dynamic> json) {
  return _ConfigCompositionDataStatusMeshMessage.fromJson(json);
}

/// @nodoc
class _$ConfigCompositionDataStatusMeshMessageTearOff {
  const _$ConfigCompositionDataStatusMeshMessageTearOff();

  _ConfigCompositionDataStatusMeshMessage call(int source, int? aszmic, int destination) {
    return _ConfigCompositionDataStatusMeshMessage(
      source,
      aszmic,
      destination,
    );
  }

  ConfigCompositionDataStatusMeshMessage fromJson(Map<String, Object> json) {
    return ConfigCompositionDataStatusMeshMessage.fromJson(json);
  }
}

/// @nodoc
const $ConfigCompositionDataStatusMeshMessage = _$ConfigCompositionDataStatusMeshMessageTearOff();

/// @nodoc
mixin _$ConfigCompositionDataStatusMeshMessage {
  int get source => throw _privateConstructorUsedError;
  int? get aszmic => throw _privateConstructorUsedError;
  int get destination => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConfigCompositionDataStatusMeshMessageCopyWith<ConfigCompositionDataStatusMeshMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> {
  factory $ConfigCompositionDataStatusMeshMessageCopyWith(
          ConfigCompositionDataStatusMeshMessage value, $Res Function(ConfigCompositionDataStatusMeshMessage) then) =
      _$ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>;
  $Res call({int source, int? aszmic, int destination});
}

/// @nodoc
class _$ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>
    implements $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> {
  _$ConfigCompositionDataStatusMeshMessageCopyWithImpl(this._value, this._then);

  final ConfigCompositionDataStatusMeshMessage _value;
  // ignore: unused_field
  final $Res Function(ConfigCompositionDataStatusMeshMessage) _then;

  @override
  $Res call({
    Object? source = freezed,
    Object? aszmic = freezed,
    Object? destination = freezed,
  }) {
    return _then(_value.copyWith(
      source: source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      aszmic: aszmic == freezed
          ? _value.aszmic
          : aszmic // ignore: cast_nullable_to_non_nullable
              as int?,
      destination: destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$ConfigCompositionDataStatusMeshMessageCopyWith<$Res>
    implements $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> {
  factory _$ConfigCompositionDataStatusMeshMessageCopyWith(
          _ConfigCompositionDataStatusMeshMessage value, $Res Function(_ConfigCompositionDataStatusMeshMessage) then) =
      __$ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>;
  @override
  $Res call({int source, int? aszmic, int destination});
}

/// @nodoc
class __$ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>
    extends _$ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>
    implements _$ConfigCompositionDataStatusMeshMessageCopyWith<$Res> {
  __$ConfigCompositionDataStatusMeshMessageCopyWithImpl(
      _ConfigCompositionDataStatusMeshMessage _value, $Res Function(_ConfigCompositionDataStatusMeshMessage) _then)
      : super(_value, (v) => _then(v as _ConfigCompositionDataStatusMeshMessage));

  @override
  _ConfigCompositionDataStatusMeshMessage get _value => super._value as _ConfigCompositionDataStatusMeshMessage;

  @override
  $Res call({
    Object? source = freezed,
    Object? aszmic = freezed,
    Object? destination = freezed,
  }) {
    return _then(_ConfigCompositionDataStatusMeshMessage(
      source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      aszmic == freezed
          ? _value.aszmic
          : aszmic // ignore: cast_nullable_to_non_nullable
              as int?,
      destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConfigCompositionDataStatusMeshMessage implements _ConfigCompositionDataStatusMeshMessage {
  const _$_ConfigCompositionDataStatusMeshMessage(this.source, this.aszmic, this.destination);

  factory _$_ConfigCompositionDataStatusMeshMessage.fromJson(Map<String, dynamic> json) =>
      _$_$_ConfigCompositionDataStatusMeshMessageFromJson(json);

  @override
  final int source;
  @override
  final int? aszmic;
  @override
  final int destination;

  @override
  String toString() {
    return 'ConfigCompositionDataStatusMeshMessage(source: $source, aszmic: $aszmic, destination: $destination)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ConfigCompositionDataStatusMeshMessage &&
            (identical(other.source, source) || const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.aszmic, aszmic) || const DeepCollectionEquality().equals(other.aszmic, aszmic)) &&
            (identical(other.destination, destination) ||
                const DeepCollectionEquality().equals(other.destination, destination)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(aszmic) ^
      const DeepCollectionEquality().hash(destination);

  @JsonKey(ignore: true)
  @override
  _$ConfigCompositionDataStatusMeshMessageCopyWith<_ConfigCompositionDataStatusMeshMessage> get copyWith =>
      __$ConfigCompositionDataStatusMeshMessageCopyWithImpl<_ConfigCompositionDataStatusMeshMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigCompositionDataStatusMeshMessageToJson(this);
  }
}

abstract class _ConfigCompositionDataStatusMeshMessage implements ConfigCompositionDataStatusMeshMessage {
  const factory _ConfigCompositionDataStatusMeshMessage(int source, int? aszmic, int destination) =
      _$_ConfigCompositionDataStatusMeshMessage;

  factory _ConfigCompositionDataStatusMeshMessage.fromJson(Map<String, dynamic> json) =
      _$_ConfigCompositionDataStatusMeshMessage.fromJson;

  @override
  int get source => throw _privateConstructorUsedError;
  @override
  int? get aszmic => throw _privateConstructorUsedError;
  @override
  int get destination => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ConfigCompositionDataStatusMeshMessageCopyWith<_ConfigCompositionDataStatusMeshMessage> get copyWith =>
      throw _privateConstructorUsedError;
}
