// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'light_ctl_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
LightCtlStatusData _$LightCtlStatusDataFromJson(Map<String, dynamic> json) {
  return _LightCtlStatusData.fromJson(json);
}

/// @nodoc
class _$LightCtlStatusDataTearOff {
  const _$LightCtlStatusDataTearOff();

// ignore: unused_element
  _LightCtlStatusData call(
      int presentLightness,
      int targetLightness,
      int presentTemperature,
      int targetTemperature,
      int transitionSteps,
      int transitionResolution,
      int source,
      int destination) {
    return _LightCtlStatusData(
      presentLightness,
      targetLightness,
      presentTemperature,
      targetTemperature,
      transitionSteps,
      transitionResolution,
      source,
      destination,
    );
  }

// ignore: unused_element
  LightCtlStatusData fromJson(Map<String, Object> json) {
    return LightCtlStatusData.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $LightCtlStatusData = _$LightCtlStatusDataTearOff();

/// @nodoc
mixin _$LightCtlStatusData {
  int get presentLightness;
  int get targetLightness;
  int get presentTemperature;
  int get targetTemperature;
  int get transitionSteps;
  int get transitionResolution;
  int get source;
  int get destination;

  Map<String, dynamic> toJson();
  $LightCtlStatusDataCopyWith<LightCtlStatusData> get copyWith;
}

/// @nodoc
abstract class $LightCtlStatusDataCopyWith<$Res> {
  factory $LightCtlStatusDataCopyWith(
          LightCtlStatusData value, $Res Function(LightCtlStatusData) then) =
      _$LightCtlStatusDataCopyWithImpl<$Res>;
  $Res call(
      {int presentLightness,
      int targetLightness,
      int presentTemperature,
      int targetTemperature,
      int transitionSteps,
      int transitionResolution,
      int source,
      int destination});
}

/// @nodoc
class _$LightCtlStatusDataCopyWithImpl<$Res>
    implements $LightCtlStatusDataCopyWith<$Res> {
  _$LightCtlStatusDataCopyWithImpl(this._value, this._then);

  final LightCtlStatusData _value;
  // ignore: unused_field
  final $Res Function(LightCtlStatusData) _then;

  @override
  $Res call({
    Object presentLightness = freezed,
    Object targetLightness = freezed,
    Object presentTemperature = freezed,
    Object targetTemperature = freezed,
    Object transitionSteps = freezed,
    Object transitionResolution = freezed,
    Object source = freezed,
    Object destination = freezed,
  }) {
    return _then(_value.copyWith(
      presentLightness: presentLightness == freezed
          ? _value.presentLightness
          : presentLightness as int,
      targetLightness: targetLightness == freezed
          ? _value.targetLightness
          : targetLightness as int,
      presentTemperature: presentTemperature == freezed
          ? _value.presentTemperature
          : presentTemperature as int,
      targetTemperature: targetTemperature == freezed
          ? _value.targetTemperature
          : targetTemperature as int,
      transitionSteps: transitionSteps == freezed
          ? _value.transitionSteps
          : transitionSteps as int,
      transitionResolution: transitionResolution == freezed
          ? _value.transitionResolution
          : transitionResolution as int,
      source: source == freezed ? _value.source : source as int,
      destination:
          destination == freezed ? _value.destination : destination as int,
    ));
  }
}

/// @nodoc
abstract class _$LightCtlStatusDataCopyWith<$Res>
    implements $LightCtlStatusDataCopyWith<$Res> {
  factory _$LightCtlStatusDataCopyWith(
          _LightCtlStatusData value, $Res Function(_LightCtlStatusData) then) =
      __$LightCtlStatusDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {int presentLightness,
      int targetLightness,
      int presentTemperature,
      int targetTemperature,
      int transitionSteps,
      int transitionResolution,
      int source,
      int destination});
}

/// @nodoc
class __$LightCtlStatusDataCopyWithImpl<$Res>
    extends _$LightCtlStatusDataCopyWithImpl<$Res>
    implements _$LightCtlStatusDataCopyWith<$Res> {
  __$LightCtlStatusDataCopyWithImpl(
      _LightCtlStatusData _value, $Res Function(_LightCtlStatusData) _then)
      : super(_value, (v) => _then(v as _LightCtlStatusData));

  @override
  _LightCtlStatusData get _value => super._value as _LightCtlStatusData;

  @override
  $Res call({
    Object presentLightness = freezed,
    Object targetLightness = freezed,
    Object presentTemperature = freezed,
    Object targetTemperature = freezed,
    Object transitionSteps = freezed,
    Object transitionResolution = freezed,
    Object source = freezed,
    Object destination = freezed,
  }) {
    return _then(_LightCtlStatusData(
      presentLightness == freezed
          ? _value.presentLightness
          : presentLightness as int,
      targetLightness == freezed
          ? _value.targetLightness
          : targetLightness as int,
      presentTemperature == freezed
          ? _value.presentTemperature
          : presentTemperature as int,
      targetTemperature == freezed
          ? _value.targetTemperature
          : targetTemperature as int,
      transitionSteps == freezed
          ? _value.transitionSteps
          : transitionSteps as int,
      transitionResolution == freezed
          ? _value.transitionResolution
          : transitionResolution as int,
      source == freezed ? _value.source : source as int,
      destination == freezed ? _value.destination : destination as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_LightCtlStatusData implements _LightCtlStatusData {
  const _$_LightCtlStatusData(
      this.presentLightness,
      this.targetLightness,
      this.presentTemperature,
      this.targetTemperature,
      this.transitionSteps,
      this.transitionResolution,
      this.source,
      this.destination)
      : assert(presentLightness != null),
        assert(targetLightness != null),
        assert(presentTemperature != null),
        assert(targetTemperature != null),
        assert(transitionSteps != null),
        assert(transitionResolution != null),
        assert(source != null),
        assert(destination != null);

  factory _$_LightCtlStatusData.fromJson(Map<String, dynamic> json) =>
      _$_$_LightCtlStatusDataFromJson(json);

  @override
  final int presentLightness;
  @override
  final int targetLightness;
  @override
  final int presentTemperature;
  @override
  final int targetTemperature;
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
    return 'LightCtlStatusData(presentLightness: $presentLightness, targetLightness: $targetLightness, presentTemperature: $presentTemperature, targetTemperature: $targetTemperature, transitionSteps: $transitionSteps, transitionResolution: $transitionResolution, source: $source, destination: $destination)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LightCtlStatusData &&
            (identical(other.presentLightness, presentLightness) ||
                const DeepCollectionEquality()
                    .equals(other.presentLightness, presentLightness)) &&
            (identical(other.targetLightness, targetLightness) ||
                const DeepCollectionEquality()
                    .equals(other.targetLightness, targetLightness)) &&
            (identical(other.presentTemperature, presentTemperature) ||
                const DeepCollectionEquality()
                    .equals(other.presentTemperature, presentTemperature)) &&
            (identical(other.targetTemperature, targetTemperature) ||
                const DeepCollectionEquality()
                    .equals(other.targetTemperature, targetTemperature)) &&
            (identical(other.transitionSteps, transitionSteps) ||
                const DeepCollectionEquality()
                    .equals(other.transitionSteps, transitionSteps)) &&
            (identical(other.transitionResolution, transitionResolution) ||
                const DeepCollectionEquality().equals(
                    other.transitionResolution, transitionResolution)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.destination, destination) ||
                const DeepCollectionEquality()
                    .equals(other.destination, destination)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(presentLightness) ^
      const DeepCollectionEquality().hash(targetLightness) ^
      const DeepCollectionEquality().hash(presentTemperature) ^
      const DeepCollectionEquality().hash(targetTemperature) ^
      const DeepCollectionEquality().hash(transitionSteps) ^
      const DeepCollectionEquality().hash(transitionResolution) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(destination);

  @override
  _$LightCtlStatusDataCopyWith<_LightCtlStatusData> get copyWith =>
      __$LightCtlStatusDataCopyWithImpl<_LightCtlStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_LightCtlStatusDataToJson(this);
  }
}

abstract class _LightCtlStatusData implements LightCtlStatusData {
  const factory _LightCtlStatusData(
      int presentLightness,
      int targetLightness,
      int presentTemperature,
      int targetTemperature,
      int transitionSteps,
      int transitionResolution,
      int source,
      int destination) = _$_LightCtlStatusData;

  factory _LightCtlStatusData.fromJson(Map<String, dynamic> json) =
      _$_LightCtlStatusData.fromJson;

  @override
  int get presentLightness;
  @override
  int get targetLightness;
  @override
  int get presentTemperature;
  @override
  int get targetTemperature;
  @override
  int get transitionSteps;
  @override
  int get transitionResolution;
  @override
  int get source;
  @override
  int get destination;
  @override
  _$LightCtlStatusDataCopyWith<_LightCtlStatusData> get copyWith;
}
