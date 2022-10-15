// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'config_composition_data_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConfigCompositionDataStatusData _$ConfigCompositionDataStatusDataFromJson(Map<String, dynamic> json) {
  return _ConfigCompositionDataStatusData.fromJson(json);
}

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
abstract class _$$_ConfigCompositionDataStatusDataCopyWith<$Res>
    implements $ConfigCompositionDataStatusDataCopyWith<$Res> {
  factory _$$_ConfigCompositionDataStatusDataCopyWith(
          _$_ConfigCompositionDataStatusData value, $Res Function(_$_ConfigCompositionDataStatusData) then) =
      __$$_ConfigCompositionDataStatusDataCopyWithImpl<$Res>;
  @override
  $Res call({int source, ConfigCompositionDataStatusMeshMessage meshMessage});

  @override
  $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> get meshMessage;
}

/// @nodoc
class __$$_ConfigCompositionDataStatusDataCopyWithImpl<$Res> extends _$ConfigCompositionDataStatusDataCopyWithImpl<$Res>
    implements _$$_ConfigCompositionDataStatusDataCopyWith<$Res> {
  __$$_ConfigCompositionDataStatusDataCopyWithImpl(
      _$_ConfigCompositionDataStatusData _value, $Res Function(_$_ConfigCompositionDataStatusData) _then)
      : super(_value, (v) => _then(v as _$_ConfigCompositionDataStatusData));

  @override
  _$_ConfigCompositionDataStatusData get _value => super._value as _$_ConfigCompositionDataStatusData;

  @override
  $Res call({
    Object? source = freezed,
    Object? meshMessage = freezed,
  }) {
    return _then(_$_ConfigCompositionDataStatusData(
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
      _$$_ConfigCompositionDataStatusDataFromJson(json);

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
        (other.runtimeType == runtimeType &&
            other is _$_ConfigCompositionDataStatusData &&
            const DeepCollectionEquality().equals(other.source, source) &&
            const DeepCollectionEquality().equals(other.meshMessage, meshMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(source), const DeepCollectionEquality().hash(meshMessage));

  @JsonKey(ignore: true)
  @override
  _$$_ConfigCompositionDataStatusDataCopyWith<_$_ConfigCompositionDataStatusData> get copyWith =>
      __$$_ConfigCompositionDataStatusDataCopyWithImpl<_$_ConfigCompositionDataStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConfigCompositionDataStatusDataToJson(
      this,
    );
  }
}

abstract class _ConfigCompositionDataStatusData implements ConfigCompositionDataStatusData {
  const factory _ConfigCompositionDataStatusData(
      final int source, final ConfigCompositionDataStatusMeshMessage meshMessage) = _$_ConfigCompositionDataStatusData;

  factory _ConfigCompositionDataStatusData.fromJson(Map<String, dynamic> json) =
      _$_ConfigCompositionDataStatusData.fromJson;

  @override
  int get source;
  @override
  ConfigCompositionDataStatusMeshMessage get meshMessage;
  @override
  @JsonKey(ignore: true)
  _$$_ConfigCompositionDataStatusDataCopyWith<_$_ConfigCompositionDataStatusData> get copyWith =>
      throw _privateConstructorUsedError;
}

ConfigCompositionDataStatusMeshMessage _$ConfigCompositionDataStatusMeshMessageFromJson(Map<String, dynamic> json) {
  return _ConfigCompositionDataStatusMeshMessage.fromJson(json);
}

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
abstract class _$$_ConfigCompositionDataStatusMeshMessageCopyWith<$Res>
    implements $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> {
  factory _$$_ConfigCompositionDataStatusMeshMessageCopyWith(_$_ConfigCompositionDataStatusMeshMessage value,
          $Res Function(_$_ConfigCompositionDataStatusMeshMessage) then) =
      __$$_ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>;
  @override
  $Res call({int source, int? aszmic, int destination});
}

/// @nodoc
class __$$_ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>
    extends _$ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>
    implements _$$_ConfigCompositionDataStatusMeshMessageCopyWith<$Res> {
  __$$_ConfigCompositionDataStatusMeshMessageCopyWithImpl(
      _$_ConfigCompositionDataStatusMeshMessage _value, $Res Function(_$_ConfigCompositionDataStatusMeshMessage) _then)
      : super(_value, (v) => _then(v as _$_ConfigCompositionDataStatusMeshMessage));

  @override
  _$_ConfigCompositionDataStatusMeshMessage get _value => super._value as _$_ConfigCompositionDataStatusMeshMessage;

  @override
  $Res call({
    Object? source = freezed,
    Object? aszmic = freezed,
    Object? destination = freezed,
  }) {
    return _then(_$_ConfigCompositionDataStatusMeshMessage(
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
      _$$_ConfigCompositionDataStatusMeshMessageFromJson(json);

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
        (other.runtimeType == runtimeType &&
            other is _$_ConfigCompositionDataStatusMeshMessage &&
            const DeepCollectionEquality().equals(other.source, source) &&
            const DeepCollectionEquality().equals(other.aszmic, aszmic) &&
            const DeepCollectionEquality().equals(other.destination, destination));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(source),
      const DeepCollectionEquality().hash(aszmic), const DeepCollectionEquality().hash(destination));

  @JsonKey(ignore: true)
  @override
  _$$_ConfigCompositionDataStatusMeshMessageCopyWith<_$_ConfigCompositionDataStatusMeshMessage> get copyWith =>
      __$$_ConfigCompositionDataStatusMeshMessageCopyWithImpl<_$_ConfigCompositionDataStatusMeshMessage>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConfigCompositionDataStatusMeshMessageToJson(
      this,
    );
  }
}

abstract class _ConfigCompositionDataStatusMeshMessage implements ConfigCompositionDataStatusMeshMessage {
  const factory _ConfigCompositionDataStatusMeshMessage(final int source, final int? aszmic, final int destination) =
      _$_ConfigCompositionDataStatusMeshMessage;

  factory _ConfigCompositionDataStatusMeshMessage.fromJson(Map<String, dynamic> json) =
      _$_ConfigCompositionDataStatusMeshMessage.fromJson;

  @override
  int get source;
  @override
  int? get aszmic;
  @override
  int get destination;
  @override
  @JsonKey(ignore: true)
  _$$_ConfigCompositionDataStatusMeshMessageCopyWith<_$_ConfigCompositionDataStatusMeshMessage> get copyWith =>
      throw _privateConstructorUsedError;
}
