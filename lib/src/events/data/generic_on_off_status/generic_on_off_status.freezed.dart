// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'generic_on_off_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GenericOnOffStatusData _$GenericOnOffStatusDataFromJson(Map<String, dynamic> json) {
  return _GenericOnOffStatusData.fromJson(json);
}

/// @nodoc
class _$GenericOnOffStatusDataTearOff {
  const _$GenericOnOffStatusDataTearOff();

  _GenericOnOffStatusData call(
      int source, bool presentState, bool? targetState, int transitionResolution, int transitionSteps) {
    return _GenericOnOffStatusData(
      source,
      presentState,
      targetState,
      transitionResolution,
      transitionSteps,
    );
  }

  GenericOnOffStatusData fromJson(Map<String, Object> json) {
    return GenericOnOffStatusData.fromJson(json);
  }
}

/// @nodoc
const $GenericOnOffStatusData = _$GenericOnOffStatusDataTearOff();

/// @nodoc
mixin _$GenericOnOffStatusData {
  int get source => throw _privateConstructorUsedError;
  bool get presentState => throw _privateConstructorUsedError;
  bool? get targetState => throw _privateConstructorUsedError;
  int get transitionResolution => throw _privateConstructorUsedError;
  int get transitionSteps => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GenericOnOffStatusDataCopyWith<GenericOnOffStatusData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenericOnOffStatusDataCopyWith<$Res> {
  factory $GenericOnOffStatusDataCopyWith(GenericOnOffStatusData value, $Res Function(GenericOnOffStatusData) then) =
      _$GenericOnOffStatusDataCopyWithImpl<$Res>;
  $Res call({int source, bool presentState, bool? targetState, int transitionResolution, int transitionSteps});
}

/// @nodoc
class _$GenericOnOffStatusDataCopyWithImpl<$Res> implements $GenericOnOffStatusDataCopyWith<$Res> {
  _$GenericOnOffStatusDataCopyWithImpl(this._value, this._then);

  final GenericOnOffStatusData _value;
  // ignore: unused_field
  final $Res Function(GenericOnOffStatusData) _then;

  @override
  $Res call({
    Object? source = freezed,
    Object? presentState = freezed,
    Object? targetState = freezed,
    Object? transitionResolution = freezed,
    Object? transitionSteps = freezed,
  }) {
    return _then(_value.copyWith(
      source: source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      presentState: presentState == freezed
          ? _value.presentState
          : presentState // ignore: cast_nullable_to_non_nullable
              as bool,
      targetState: targetState == freezed
          ? _value.targetState
          : targetState // ignore: cast_nullable_to_non_nullable
              as bool?,
      transitionResolution: transitionResolution == freezed
          ? _value.transitionResolution
          : transitionResolution // ignore: cast_nullable_to_non_nullable
              as int,
      transitionSteps: transitionSteps == freezed
          ? _value.transitionSteps
          : transitionSteps // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$GenericOnOffStatusDataCopyWith<$Res> implements $GenericOnOffStatusDataCopyWith<$Res> {
  factory _$GenericOnOffStatusDataCopyWith(_GenericOnOffStatusData value, $Res Function(_GenericOnOffStatusData) then) =
      __$GenericOnOffStatusDataCopyWithImpl<$Res>;
  @override
  $Res call({int source, bool presentState, bool? targetState, int transitionResolution, int transitionSteps});
}

/// @nodoc
class __$GenericOnOffStatusDataCopyWithImpl<$Res> extends _$GenericOnOffStatusDataCopyWithImpl<$Res>
    implements _$GenericOnOffStatusDataCopyWith<$Res> {
  __$GenericOnOffStatusDataCopyWithImpl(_GenericOnOffStatusData _value, $Res Function(_GenericOnOffStatusData) _then)
      : super(_value, (v) => _then(v as _GenericOnOffStatusData));

  @override
  _GenericOnOffStatusData get _value => super._value as _GenericOnOffStatusData;

  @override
  $Res call({
    Object? source = freezed,
    Object? presentState = freezed,
    Object? targetState = freezed,
    Object? transitionResolution = freezed,
    Object? transitionSteps = freezed,
  }) {
    return _then(_GenericOnOffStatusData(
      source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      presentState == freezed
          ? _value.presentState
          : presentState // ignore: cast_nullable_to_non_nullable
              as bool,
      targetState == freezed
          ? _value.targetState
          : targetState // ignore: cast_nullable_to_non_nullable
              as bool?,
      transitionResolution == freezed
          ? _value.transitionResolution
          : transitionResolution // ignore: cast_nullable_to_non_nullable
              as int,
      transitionSteps == freezed
          ? _value.transitionSteps
          : transitionSteps // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GenericOnOffStatusData implements _GenericOnOffStatusData {
  const _$_GenericOnOffStatusData(
      this.source, this.presentState, this.targetState, this.transitionResolution, this.transitionSteps);

  factory _$_GenericOnOffStatusData.fromJson(Map<String, dynamic> json) => _$_$_GenericOnOffStatusDataFromJson(json);

  @override
  final int source;
  @override
  final bool presentState;
  @override
  final bool? targetState;
  @override
  final int transitionResolution;
  @override
  final int transitionSteps;

  @override
  String toString() {
    return 'GenericOnOffStatusData(source: $source, presentState: $presentState, targetState: $targetState, transitionResolution: $transitionResolution, transitionSteps: $transitionSteps)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GenericOnOffStatusData &&
            (identical(other.source, source) || const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.presentState, presentState) ||
                const DeepCollectionEquality().equals(other.presentState, presentState)) &&
            (identical(other.targetState, targetState) ||
                const DeepCollectionEquality().equals(other.targetState, targetState)) &&
            (identical(other.transitionResolution, transitionResolution) ||
                const DeepCollectionEquality().equals(other.transitionResolution, transitionResolution)) &&
            (identical(other.transitionSteps, transitionSteps) ||
                const DeepCollectionEquality().equals(other.transitionSteps, transitionSteps)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(presentState) ^
      const DeepCollectionEquality().hash(targetState) ^
      const DeepCollectionEquality().hash(transitionResolution) ^
      const DeepCollectionEquality().hash(transitionSteps);

  @JsonKey(ignore: true)
  @override
  _$GenericOnOffStatusDataCopyWith<_GenericOnOffStatusData> get copyWith =>
      __$GenericOnOffStatusDataCopyWithImpl<_GenericOnOffStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GenericOnOffStatusDataToJson(this);
  }
}

abstract class _GenericOnOffStatusData implements GenericOnOffStatusData {
  const factory _GenericOnOffStatusData(
          int source, bool presentState, bool? targetState, int transitionResolution, int transitionSteps) =
      _$_GenericOnOffStatusData;

  factory _GenericOnOffStatusData.fromJson(Map<String, dynamic> json) = _$_GenericOnOffStatusData.fromJson;

  @override
  int get source => throw _privateConstructorUsedError;
  @override
  bool get presentState => throw _privateConstructorUsedError;
  @override
  bool? get targetState => throw _privateConstructorUsedError;
  @override
  int get transitionResolution => throw _privateConstructorUsedError;
  @override
  int get transitionSteps => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GenericOnOffStatusDataCopyWith<_GenericOnOffStatusData> get copyWith => throw _privateConstructorUsedError;
}
