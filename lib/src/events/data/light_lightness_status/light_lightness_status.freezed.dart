// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'light_lightness_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

LightLightnessStatusData _$LightLightnessStatusDataFromJson(Map<String, dynamic> json) {
  return _LightLightnessStatusData.fromJson(json);
}

/// @nodoc
class _$LightLightnessStatusDataTearOff {
  const _$LightLightnessStatusDataTearOff();

// ignore: unused_element
  _LightLightnessStatusData call(int presentLightness, int targetLightness, int transitionSteps,
      int transitionResolution, int source, int destination) {
    return _LightLightnessStatusData(
      presentLightness,
      targetLightness,
      transitionSteps,
      transitionResolution,
      source,
      destination,
    );
  }

// ignore: unused_element
  LightLightnessStatusData fromJson(Map<String, Object> json) {
    return LightLightnessStatusData.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $LightLightnessStatusData = _$LightLightnessStatusDataTearOff();

/// @nodoc
mixin _$LightLightnessStatusData {
  int get presentLightness;
  int get targetLightness;
  int get transitionSteps;
  int get transitionResolution;
  int get source;
  int get destination;

  Map<String, dynamic> toJson();
  $LightLightnessStatusDataCopyWith<LightLightnessStatusData> get copyWith;
}

/// @nodoc
abstract class $LightLightnessStatusDataCopyWith<$Res> {
  factory $LightLightnessStatusDataCopyWith(
          LightLightnessStatusData value, $Res Function(LightLightnessStatusData) then) =
      _$LightLightnessStatusDataCopyWithImpl<$Res>;

  $Res call(
      {int presentLightness,
      int targetLightness,
      int transitionSteps,
      int transitionResolution,
      int source,
      int destination});
}

/// @nodoc
class _$LightLightnessStatusDataCopyWithImpl<$Res> implements $LightLightnessStatusDataCopyWith<$Res> {
  _$LightLightnessStatusDataCopyWithImpl(this._value, this._then);

  final LightLightnessStatusData _value;

  // ignore: unused_field
  final $Res Function(LightLightnessStatusData) _then;

  @override
  $Res call({
    Object presentLightness = freezed,
    Object targetLightness = freezed,
    Object transitionSteps = freezed,
    Object transitionResolution = freezed,
    Object source = freezed,
    Object destination = freezed,
  }) {
    return _then(_value.copyWith(
      presentLightness: presentLightness == freezed ? _value.presentLightness : presentLightness as int,
      targetLightness: targetLightness == freezed ? _value.targetLightness : targetLightness as int,
      transitionSteps: transitionSteps == freezed ? _value.transitionSteps : transitionSteps as int,
      transitionResolution: transitionResolution == freezed ? _value.transitionResolution : transitionResolution as int,
      source: source == freezed ? _value.source : source as int,
      destination: destination == freezed ? _value.destination : destination as int,
    ));
  }
}

/// @nodoc
abstract class _$LightLightnessStatusDataCopyWith<$Res> implements $LightLightnessStatusDataCopyWith<$Res> {
  factory _$LightLightnessStatusDataCopyWith(
          _LightLightnessStatusData value, $Res Function(_LightLightnessStatusData) then) =
      __$LightLightnessStatusDataCopyWithImpl<$Res>;

  @override
  $Res call(
      {int presentLightness,
      int targetLightness,
      int transitionSteps,
      int transitionResolution,
      int source,
      int destination});
}

/// @nodoc
class __$LightLightnessStatusDataCopyWithImpl<$Res> extends _$LightLightnessStatusDataCopyWithImpl<$Res>
    implements _$LightLightnessStatusDataCopyWith<$Res> {
  __$LightLightnessStatusDataCopyWithImpl(
      _LightLightnessStatusData _value, $Res Function(_LightLightnessStatusData) _then)
      : super(_value, (v) => _then(v as _LightLightnessStatusData));

  @override
  _LightLightnessStatusData get _value => super._value as _LightLightnessStatusData;

  @override
  $Res call({
    Object presentLightness = freezed,
    Object targetLightness = freezed,
    Object transitionSteps = freezed,
    Object transitionResolution = freezed,
    Object source = freezed,
    Object destination = freezed,
  }) {
    return _then(_LightLightnessStatusData(
      presentLightness == freezed ? _value.presentLightness : presentLightness as int,
      targetLightness == freezed ? _value.targetLightness : targetLightness as int,
      transitionSteps == freezed ? _value.transitionSteps : transitionSteps as int,
      transitionResolution == freezed ? _value.transitionResolution : transitionResolution as int,
      source == freezed ? _value.source : source as int,
      destination == freezed ? _value.destination : destination as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_LightLightnessStatusData implements _LightLightnessStatusData {
  const _$_LightLightnessStatusData(this.presentLightness, this.targetLightness, this.transitionSteps,
      this.transitionResolution, this.source, this.destination)
      : assert(presentLightness != null),
        assert(targetLightness != null),
        assert(transitionSteps != null),
        assert(transitionResolution != null),
        assert(source != null),
        assert(destination != null);

  factory _$_LightLightnessStatusData.fromJson(Map<String, dynamic> json) =>
      _$_$_LightLightnessStatusDataFromJson(json);

  @override
  final int presentLightness;
  @override
  final int targetLightness;
  @override
  final int transitionSteps;
  @override
  final int transitionResolution;
  @override
  final int source;
  @override
  final int destination;

  @override
  String toString() {
    return 'LightLightnessStatusData(presentLightness: $presentLightness, targetLightness: $targetLightness, transitionSteps: $transitionSteps, transitionResolution: $transitionResolution, source: $source, destination: $destination)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LightLightnessStatusData &&
            (identical(other.presentLightness, presentLightness) ||
                const DeepCollectionEquality().equals(other.presentLightness, presentLightness)) &&
            (identical(other.targetLightness, targetLightness) ||
                const DeepCollectionEquality().equals(other.targetLightness, targetLightness)) &&
            (identical(other.transitionSteps, transitionSteps) ||
                const DeepCollectionEquality().equals(other.transitionSteps, transitionSteps)) &&
            (identical(other.transitionResolution, transitionResolution) ||
                const DeepCollectionEquality().equals(other.transitionResolution, transitionResolution)) &&
            (identical(other.source, source) || const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.destination, destination) ||
                const DeepCollectionEquality().equals(other.destination, destination)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(presentLightness) ^
      const DeepCollectionEquality().hash(targetLightness) ^
      const DeepCollectionEquality().hash(transitionSteps) ^
      const DeepCollectionEquality().hash(transitionResolution) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(destination);

  @override
  _$LightLightnessStatusDataCopyWith<_LightLightnessStatusData> get copyWith =>
      __$LightLightnessStatusDataCopyWithImpl<_LightLightnessStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_LightLightnessStatusDataToJson(this);
  }
}

abstract class _LightLightnessStatusData implements LightLightnessStatusData {
  const factory _LightLightnessStatusData(int presentLightness, int targetLightness, int transitionSteps,
      int transitionResolution, int source, int destination) = _$_LightLightnessStatusData;

  factory _LightLightnessStatusData.fromJson(Map<String, dynamic> json) = _$_LightLightnessStatusData.fromJson;

  @override
  int get presentLightness;

  @override
  int get targetLightness;

  @override
  int get transitionSteps;

  @override
  int get transitionResolution;

  @override
  int get source;
  @override
  int get destination;
  @override
  _$LightLightnessStatusDataCopyWith<_LightLightnessStatusData> get copyWith;
}
