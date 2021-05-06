// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'light_hsl_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
LightHslStatusData _$LightHslStatusDataFromJson(Map<String, dynamic> json) {
  return _LightHslStatusData.fromJson(json);
}

/// @nodoc
class _$LightHslStatusDataTearOff {
  const _$LightHslStatusDataTearOff();

// ignore: unused_element
  _LightHslStatusData call(int presentLightness, int presentHue, int presentSaturation, int transitionSteps,
      int transitionResolution, int source, int destination) {
    return _LightHslStatusData(
      presentLightness,
      presentHue,
      presentSaturation,
      transitionSteps,
      transitionResolution,
      source,
      destination,
    );
  }

// ignore: unused_element
  LightHslStatusData fromJson(Map<String, Object> json) {
    return LightHslStatusData.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $LightHslStatusData = _$LightHslStatusDataTearOff();

/// @nodoc
mixin _$LightHslStatusData {
  int get presentLightness;
  int get presentHue;
  int get presentSaturation;
  int get transitionSteps;
  int get transitionResolution;
  int get source;
  int get destination;

  Map<String, dynamic> toJson();
  $LightHslStatusDataCopyWith<LightHslStatusData> get copyWith;
}

/// @nodoc
abstract class $LightHslStatusDataCopyWith<$Res> {
  factory $LightHslStatusDataCopyWith(LightHslStatusData value, $Res Function(LightHslStatusData) then) =
      _$LightHslStatusDataCopyWithImpl<$Res>;

  $Res call(
      {int presentLightness,
      int presentHue,
      int presentSaturation,
      int transitionSteps,
      int transitionResolution,
      int source,
      int destination});
}

/// @nodoc
class _$LightHslStatusDataCopyWithImpl<$Res> implements $LightHslStatusDataCopyWith<$Res> {
  _$LightHslStatusDataCopyWithImpl(this._value, this._then);

  final LightHslStatusData _value;

  // ignore: unused_field
  final $Res Function(LightHslStatusData) _then;

  @override
  $Res call({
    Object presentLightness = freezed,
    Object presentHue = freezed,
    Object presentSaturation = freezed,
    Object transitionSteps = freezed,
    Object transitionResolution = freezed,
    Object source = freezed,
    Object destination = freezed,
  }) {
    return _then(_value.copyWith(
      presentLightness: presentLightness == freezed ? _value.presentLightness : presentLightness as int,
      presentHue: presentHue == freezed ? _value.presentHue : presentHue as int,
      presentSaturation: presentSaturation == freezed ? _value.presentSaturation : presentSaturation as int,
      transitionSteps: transitionSteps == freezed ? _value.transitionSteps : transitionSteps as int,
      transitionResolution: transitionResolution == freezed ? _value.transitionResolution : transitionResolution as int,
      source: source == freezed ? _value.source : source as int,
      destination: destination == freezed ? _value.destination : destination as int,
    ));
  }
}

/// @nodoc
abstract class _$LightHslStatusDataCopyWith<$Res> implements $LightHslStatusDataCopyWith<$Res> {
  factory _$LightHslStatusDataCopyWith(_LightHslStatusData value, $Res Function(_LightHslStatusData) then) =
      __$LightHslStatusDataCopyWithImpl<$Res>;

  @override
  $Res call(
      {int presentLightness,
      int presentHue,
      int presentSaturation,
      int transitionSteps,
      int transitionResolution,
      int source,
      int destination});
}

/// @nodoc
class __$LightHslStatusDataCopyWithImpl<$Res> extends _$LightHslStatusDataCopyWithImpl<$Res>
    implements _$LightHslStatusDataCopyWith<$Res> {
  __$LightHslStatusDataCopyWithImpl(_LightHslStatusData _value, $Res Function(_LightHslStatusData) _then)
      : super(_value, (v) => _then(v as _LightHslStatusData));

  @override
  _LightHslStatusData get _value => super._value as _LightHslStatusData;

  @override
  $Res call({
    Object presentLightness = freezed,
    Object presentHue = freezed,
    Object presentSaturation = freezed,
    Object transitionSteps = freezed,
    Object transitionResolution = freezed,
    Object source = freezed,
    Object destination = freezed,
  }) {
    return _then(_LightHslStatusData(
      presentLightness == freezed ? _value.presentLightness : presentLightness as int,
      presentHue == freezed ? _value.presentHue : presentHue as int,
      presentSaturation == freezed ? _value.presentSaturation : presentSaturation as int,
      transitionSteps == freezed ? _value.transitionSteps : transitionSteps as int,
      transitionResolution == freezed ? _value.transitionResolution : transitionResolution as int,
      source == freezed ? _value.source : source as int,
      destination == freezed ? _value.destination : destination as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_LightHslStatusData implements _LightHslStatusData {
  const _$_LightHslStatusData(this.presentLightness, this.presentHue, this.presentSaturation, this.transitionSteps,
      this.transitionResolution, this.source, this.destination)
      : assert(presentLightness != null),
        assert(presentHue != null),
        assert(presentSaturation != null),
        assert(transitionSteps != null),
        assert(transitionResolution != null),
        assert(source != null),
        assert(destination != null);

  factory _$_LightHslStatusData.fromJson(Map<String, dynamic> json) => _$_$_LightHslStatusDataFromJson(json);

  @override
  final int presentLightness;
  @override
  final int presentHue;
  @override
  final int presentSaturation;
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
    return 'LightHslStatusData(presentLightness: $presentLightness, presentHue: $presentHue, presentSaturation: $presentSaturation, transitionSteps: $transitionSteps, transitionResolution: $transitionResolution, source: $source, destination: $destination)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LightHslStatusData &&
            (identical(other.presentLightness, presentLightness) ||
                const DeepCollectionEquality().equals(other.presentLightness, presentLightness)) &&
            (identical(other.presentHue, presentHue) ||
                const DeepCollectionEquality().equals(other.presentHue, presentHue)) &&
            (identical(other.presentSaturation, presentSaturation) ||
                const DeepCollectionEquality().equals(other.presentSaturation, presentSaturation)) &&
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
      const DeepCollectionEquality().hash(presentHue) ^
      const DeepCollectionEquality().hash(presentSaturation) ^
      const DeepCollectionEquality().hash(transitionSteps) ^
      const DeepCollectionEquality().hash(transitionResolution) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(destination);

  @override
  _$LightHslStatusDataCopyWith<_LightHslStatusData> get copyWith =>
      __$LightHslStatusDataCopyWithImpl<_LightHslStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_LightHslStatusDataToJson(this);
  }
}

abstract class _LightHslStatusData implements LightHslStatusData {
  const factory _LightHslStatusData(int presentLightness, int presentHue, int presentSaturation, int transitionSteps,
      int transitionResolution, int source, int destination) = _$_LightHslStatusData;

  factory _LightHslStatusData.fromJson(Map<String, dynamic> json) = _$_LightHslStatusData.fromJson;

  @override
  int get presentLightness;

  @override
  int get presentHue;

  @override
  int get presentSaturation;

  @override
  int get transitionSteps;

  @override
  int get transitionResolution;
  @override
  int get source;
  @override
  int get destination;
  @override
  _$LightHslStatusDataCopyWith<_LightHslStatusData> get copyWith;
}
