// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'generic_level_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GenericLevelStatusData _$GenericLevelStatusDataFromJson(Map<String, dynamic> json) {
  return _GenericLevelStatusData.fromJson(json);
}

/// @nodoc
class _$GenericLevelStatusDataTearOff {
  const _$GenericLevelStatusDataTearOff();

  _GenericLevelStatusData call(
      int level, int? targetLevel, int? transitionSteps, int? transitionResolution, int source, int destination) {
    return _GenericLevelStatusData(
      level,
      targetLevel,
      transitionSteps,
      transitionResolution,
      source,
      destination,
    );
  }

  GenericLevelStatusData fromJson(Map<String, Object> json) {
    return GenericLevelStatusData.fromJson(json);
  }
}

/// @nodoc
const $GenericLevelStatusData = _$GenericLevelStatusDataTearOff();

/// @nodoc
mixin _$GenericLevelStatusData {
  int get level => throw _privateConstructorUsedError;
  int? get targetLevel => throw _privateConstructorUsedError;
  int? get transitionSteps => throw _privateConstructorUsedError;
  int? get transitionResolution => throw _privateConstructorUsedError;
  int get source => throw _privateConstructorUsedError;
  int get destination => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GenericLevelStatusDataCopyWith<GenericLevelStatusData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenericLevelStatusDataCopyWith<$Res> {
  factory $GenericLevelStatusDataCopyWith(GenericLevelStatusData value, $Res Function(GenericLevelStatusData) then) =
      _$GenericLevelStatusDataCopyWithImpl<$Res>;
  $Res call(
      {int level, int? targetLevel, int? transitionSteps, int? transitionResolution, int source, int destination});
}

/// @nodoc
class _$GenericLevelStatusDataCopyWithImpl<$Res> implements $GenericLevelStatusDataCopyWith<$Res> {
  _$GenericLevelStatusDataCopyWithImpl(this._value, this._then);

  final GenericLevelStatusData _value;
  // ignore: unused_field
  final $Res Function(GenericLevelStatusData) _then;

  @override
  $Res call({
    Object? level = freezed,
    Object? targetLevel = freezed,
    Object? transitionSteps = freezed,
    Object? transitionResolution = freezed,
    Object? source = freezed,
    Object? destination = freezed,
  }) {
    return _then(_value.copyWith(
      level: level == freezed
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      targetLevel: targetLevel == freezed
          ? _value.targetLevel
          : targetLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      transitionSteps: transitionSteps == freezed
          ? _value.transitionSteps
          : transitionSteps // ignore: cast_nullable_to_non_nullable
              as int?,
      transitionResolution: transitionResolution == freezed
          ? _value.transitionResolution
          : transitionResolution // ignore: cast_nullable_to_non_nullable
              as int?,
      source: source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      destination: destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$GenericLevelStatusDataCopyWith<$Res> implements $GenericLevelStatusDataCopyWith<$Res> {
  factory _$GenericLevelStatusDataCopyWith(_GenericLevelStatusData value, $Res Function(_GenericLevelStatusData) then) =
      __$GenericLevelStatusDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {int level, int? targetLevel, int? transitionSteps, int? transitionResolution, int source, int destination});
}

/// @nodoc
class __$GenericLevelStatusDataCopyWithImpl<$Res> extends _$GenericLevelStatusDataCopyWithImpl<$Res>
    implements _$GenericLevelStatusDataCopyWith<$Res> {
  __$GenericLevelStatusDataCopyWithImpl(_GenericLevelStatusData _value, $Res Function(_GenericLevelStatusData) _then)
      : super(_value, (v) => _then(v as _GenericLevelStatusData));

  @override
  _GenericLevelStatusData get _value => super._value as _GenericLevelStatusData;

  @override
  $Res call({
    Object? level = freezed,
    Object? targetLevel = freezed,
    Object? transitionSteps = freezed,
    Object? transitionResolution = freezed,
    Object? source = freezed,
    Object? destination = freezed,
  }) {
    return _then(_GenericLevelStatusData(
      level == freezed
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      targetLevel == freezed
          ? _value.targetLevel
          : targetLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      transitionSteps == freezed
          ? _value.transitionSteps
          : transitionSteps // ignore: cast_nullable_to_non_nullable
              as int?,
      transitionResolution == freezed
          ? _value.transitionResolution
          : transitionResolution // ignore: cast_nullable_to_non_nullable
              as int?,
      source == freezed
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as int,
      destination == freezed
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GenericLevelStatusData implements _GenericLevelStatusData {
  const _$_GenericLevelStatusData(
      this.level, this.targetLevel, this.transitionSteps, this.transitionResolution, this.source, this.destination);

  factory _$_GenericLevelStatusData.fromJson(Map<String, dynamic> json) => _$_$_GenericLevelStatusDataFromJson(json);

  @override
  final int level;
  @override
  final int? targetLevel;
  @override
  final int? transitionSteps;
  @override
  final int? transitionResolution;
  @override
  final int source;
  @override
  final int destination;

  @override
  String toString() {
    return 'GenericLevelStatusData(level: $level, targetLevel: $targetLevel, transitionSteps: $transitionSteps, transitionResolution: $transitionResolution, source: $source, destination: $destination)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GenericLevelStatusData &&
            (identical(other.level, level) || const DeepCollectionEquality().equals(other.level, level)) &&
            (identical(other.targetLevel, targetLevel) ||
                const DeepCollectionEquality().equals(other.targetLevel, targetLevel)) &&
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
      const DeepCollectionEquality().hash(level) ^
      const DeepCollectionEquality().hash(targetLevel) ^
      const DeepCollectionEquality().hash(transitionSteps) ^
      const DeepCollectionEquality().hash(transitionResolution) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(destination);

  @JsonKey(ignore: true)
  @override
  _$GenericLevelStatusDataCopyWith<_GenericLevelStatusData> get copyWith =>
      __$GenericLevelStatusDataCopyWithImpl<_GenericLevelStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GenericLevelStatusDataToJson(this);
  }
}

abstract class _GenericLevelStatusData implements GenericLevelStatusData {
  const factory _GenericLevelStatusData(
          int level, int? targetLevel, int? transitionSteps, int? transitionResolution, int source, int destination) =
      _$_GenericLevelStatusData;

  factory _GenericLevelStatusData.fromJson(Map<String, dynamic> json) = _$_GenericLevelStatusData.fromJson;

  @override
  int get level => throw _privateConstructorUsedError;
  @override
  int? get targetLevel => throw _privateConstructorUsedError;
  @override
  int? get transitionSteps => throw _privateConstructorUsedError;
  @override
  int? get transitionResolution => throw _privateConstructorUsedError;
  @override
  int get source => throw _privateConstructorUsedError;
  @override
  int get destination => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GenericLevelStatusDataCopyWith<_GenericLevelStatusData> get copyWith => throw _privateConstructorUsedError;
}
