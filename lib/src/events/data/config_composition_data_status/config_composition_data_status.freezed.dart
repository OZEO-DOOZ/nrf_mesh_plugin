// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'config_composition_data_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ConfigCompositionDataStatusData _$ConfigCompositionDataStatusDataFromJson(
    Map<String, dynamic> json) {
  return _ConfigCompositionDataStatusData.fromJson(json);
}

/// @nodoc
class _$ConfigCompositionDataStatusDataTearOff {
  const _$ConfigCompositionDataStatusDataTearOff();

// ignore: unused_element
  _ConfigCompositionDataStatusData call(
      int source, ConfigCompositionDataStatusMeshMessage meshMessage) {
    return _ConfigCompositionDataStatusData(
      source,
      meshMessage,
    );
  }

// ignore: unused_element
  ConfigCompositionDataStatusData fromJson(Map<String, Object> json) {
    return ConfigCompositionDataStatusData.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ConfigCompositionDataStatusData =
    _$ConfigCompositionDataStatusDataTearOff();

/// @nodoc
mixin _$ConfigCompositionDataStatusData {
  int get source;
  ConfigCompositionDataStatusMeshMessage get meshMessage;

  Map<String, dynamic> toJson();
  $ConfigCompositionDataStatusDataCopyWith<ConfigCompositionDataStatusData>
      get copyWith;
}

/// @nodoc
abstract class $ConfigCompositionDataStatusDataCopyWith<$Res> {
  factory $ConfigCompositionDataStatusDataCopyWith(
          ConfigCompositionDataStatusData value,
          $Res Function(ConfigCompositionDataStatusData) then) =
      _$ConfigCompositionDataStatusDataCopyWithImpl<$Res>;
  $Res call({int source, ConfigCompositionDataStatusMeshMessage meshMessage});

  $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> get meshMessage;
}

/// @nodoc
class _$ConfigCompositionDataStatusDataCopyWithImpl<$Res>
    implements $ConfigCompositionDataStatusDataCopyWith<$Res> {
  _$ConfigCompositionDataStatusDataCopyWithImpl(this._value, this._then);

  final ConfigCompositionDataStatusData _value;
  // ignore: unused_field
  final $Res Function(ConfigCompositionDataStatusData) _then;

  @override
  $Res call({
    Object source = freezed,
    Object meshMessage = freezed,
  }) {
    return _then(_value.copyWith(
      source: source == freezed ? _value.source : source as int,
      meshMessage: meshMessage == freezed
          ? _value.meshMessage
          : meshMessage as ConfigCompositionDataStatusMeshMessage,
    ));
  }

  @override
  $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> get meshMessage {
    if (_value.meshMessage == null) {
      return null;
    }
    return $ConfigCompositionDataStatusMeshMessageCopyWith<$Res>(
        _value.meshMessage, (value) {
      return _then(_value.copyWith(meshMessage: value));
    });
  }
}

/// @nodoc
abstract class _$ConfigCompositionDataStatusDataCopyWith<$Res>
    implements $ConfigCompositionDataStatusDataCopyWith<$Res> {
  factory _$ConfigCompositionDataStatusDataCopyWith(
          _ConfigCompositionDataStatusData value,
          $Res Function(_ConfigCompositionDataStatusData) then) =
      __$ConfigCompositionDataStatusDataCopyWithImpl<$Res>;
  @override
  $Res call({int source, ConfigCompositionDataStatusMeshMessage meshMessage});

  @override
  $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> get meshMessage;
}

/// @nodoc
class __$ConfigCompositionDataStatusDataCopyWithImpl<$Res>
    extends _$ConfigCompositionDataStatusDataCopyWithImpl<$Res>
    implements _$ConfigCompositionDataStatusDataCopyWith<$Res> {
  __$ConfigCompositionDataStatusDataCopyWithImpl(
      _ConfigCompositionDataStatusData _value,
      $Res Function(_ConfigCompositionDataStatusData) _then)
      : super(_value, (v) => _then(v as _ConfigCompositionDataStatusData));

  @override
  _ConfigCompositionDataStatusData get _value =>
      super._value as _ConfigCompositionDataStatusData;

  @override
  $Res call({
    Object source = freezed,
    Object meshMessage = freezed,
  }) {
    return _then(_ConfigCompositionDataStatusData(
      source == freezed ? _value.source : source as int,
      meshMessage == freezed
          ? _value.meshMessage
          : meshMessage as ConfigCompositionDataStatusMeshMessage,
    ));
  }
}

@JsonSerializable(anyMap: true)

/// @nodoc
class _$_ConfigCompositionDataStatusData
    implements _ConfigCompositionDataStatusData {
  const _$_ConfigCompositionDataStatusData(this.source, this.meshMessage)
      : assert(source != null),
        assert(meshMessage != null);

  factory _$_ConfigCompositionDataStatusData.fromJson(
          Map<String, dynamic> json) =>
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
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.meshMessage, meshMessage) ||
                const DeepCollectionEquality()
                    .equals(other.meshMessage, meshMessage)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(meshMessage);

  @override
  _$ConfigCompositionDataStatusDataCopyWith<_ConfigCompositionDataStatusData>
      get copyWith => __$ConfigCompositionDataStatusDataCopyWithImpl<
          _ConfigCompositionDataStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigCompositionDataStatusDataToJson(this);
  }
}

abstract class _ConfigCompositionDataStatusData
    implements ConfigCompositionDataStatusData {
  const factory _ConfigCompositionDataStatusData(
          int source, ConfigCompositionDataStatusMeshMessage meshMessage) =
      _$_ConfigCompositionDataStatusData;

  factory _ConfigCompositionDataStatusData.fromJson(Map<String, dynamic> json) =
      _$_ConfigCompositionDataStatusData.fromJson;

  @override
  int get source;
  @override
  ConfigCompositionDataStatusMeshMessage get meshMessage;
  @override
  _$ConfigCompositionDataStatusDataCopyWith<_ConfigCompositionDataStatusData>
      get copyWith;
}

ConfigCompositionDataStatusMeshMessage
    _$ConfigCompositionDataStatusMeshMessageFromJson(
        Map<String, dynamic> json) {
  return _ConfigCompositionDataStatusMeshMessage.fromJson(json);
}

/// @nodoc
class _$ConfigCompositionDataStatusMeshMessageTearOff {
  const _$ConfigCompositionDataStatusMeshMessageTearOff();

// ignore: unused_element
  _ConfigCompositionDataStatusMeshMessage call(
      int source, @nullable int aszmic, int destination) {
    return _ConfigCompositionDataStatusMeshMessage(
      source,
      aszmic,
      destination,
    );
  }

// ignore: unused_element
  ConfigCompositionDataStatusMeshMessage fromJson(Map<String, Object> json) {
    return ConfigCompositionDataStatusMeshMessage.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ConfigCompositionDataStatusMeshMessage =
    _$ConfigCompositionDataStatusMeshMessageTearOff();

/// @nodoc
mixin _$ConfigCompositionDataStatusMeshMessage {
  int get source;
  @nullable
  int get aszmic;
  int get destination;

  Map<String, dynamic> toJson();
  $ConfigCompositionDataStatusMeshMessageCopyWith<
      ConfigCompositionDataStatusMeshMessage> get copyWith;
}

/// @nodoc
abstract class $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> {
  factory $ConfigCompositionDataStatusMeshMessageCopyWith(
          ConfigCompositionDataStatusMeshMessage value,
          $Res Function(ConfigCompositionDataStatusMeshMessage) then) =
      _$ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>;
  $Res call({int source, @nullable int aszmic, int destination});
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
    Object source = freezed,
    Object aszmic = freezed,
    Object destination = freezed,
  }) {
    return _then(_value.copyWith(
      source: source == freezed ? _value.source : source as int,
      aszmic: aszmic == freezed ? _value.aszmic : aszmic as int,
      destination:
          destination == freezed ? _value.destination : destination as int,
    ));
  }
}

/// @nodoc
abstract class _$ConfigCompositionDataStatusMeshMessageCopyWith<$Res>
    implements $ConfigCompositionDataStatusMeshMessageCopyWith<$Res> {
  factory _$ConfigCompositionDataStatusMeshMessageCopyWith(
          _ConfigCompositionDataStatusMeshMessage value,
          $Res Function(_ConfigCompositionDataStatusMeshMessage) then) =
      __$ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>;
  @override
  $Res call({int source, @nullable int aszmic, int destination});
}

/// @nodoc
class __$ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>
    extends _$ConfigCompositionDataStatusMeshMessageCopyWithImpl<$Res>
    implements _$ConfigCompositionDataStatusMeshMessageCopyWith<$Res> {
  __$ConfigCompositionDataStatusMeshMessageCopyWithImpl(
      _ConfigCompositionDataStatusMeshMessage _value,
      $Res Function(_ConfigCompositionDataStatusMeshMessage) _then)
      : super(
            _value, (v) => _then(v as _ConfigCompositionDataStatusMeshMessage));

  @override
  _ConfigCompositionDataStatusMeshMessage get _value =>
      super._value as _ConfigCompositionDataStatusMeshMessage;

  @override
  $Res call({
    Object source = freezed,
    Object aszmic = freezed,
    Object destination = freezed,
  }) {
    return _then(_ConfigCompositionDataStatusMeshMessage(
      source == freezed ? _value.source : source as int,
      aszmic == freezed ? _value.aszmic : aszmic as int,
      destination == freezed ? _value.destination : destination as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_ConfigCompositionDataStatusMeshMessage
    implements _ConfigCompositionDataStatusMeshMessage {
  const _$_ConfigCompositionDataStatusMeshMessage(
      this.source, @nullable this.aszmic, this.destination)
      : assert(source != null),
        assert(destination != null);

  factory _$_ConfigCompositionDataStatusMeshMessage.fromJson(
          Map<String, dynamic> json) =>
      _$_$_ConfigCompositionDataStatusMeshMessageFromJson(json);

  @override
  final int source;
  @override
  @nullable
  final int aszmic;
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
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.aszmic, aszmic) ||
                const DeepCollectionEquality().equals(other.aszmic, aszmic)) &&
            (identical(other.destination, destination) ||
                const DeepCollectionEquality()
                    .equals(other.destination, destination)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(aszmic) ^
      const DeepCollectionEquality().hash(destination);

  @override
  _$ConfigCompositionDataStatusMeshMessageCopyWith<
          _ConfigCompositionDataStatusMeshMessage>
      get copyWith => __$ConfigCompositionDataStatusMeshMessageCopyWithImpl<
          _ConfigCompositionDataStatusMeshMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ConfigCompositionDataStatusMeshMessageToJson(this);
  }
}

abstract class _ConfigCompositionDataStatusMeshMessage
    implements ConfigCompositionDataStatusMeshMessage {
  const factory _ConfigCompositionDataStatusMeshMessage(
          int source, @nullable int aszmic, int destination) =
      _$_ConfigCompositionDataStatusMeshMessage;

  factory _ConfigCompositionDataStatusMeshMessage.fromJson(
          Map<String, dynamic> json) =
      _$_ConfigCompositionDataStatusMeshMessage.fromJson;

  @override
  int get source;
  @override
  @nullable
  int get aszmic;
  @override
  int get destination;
  @override
  _$ConfigCompositionDataStatusMeshMessageCopyWith<
      _ConfigCompositionDataStatusMeshMessage> get copyWith;
}
