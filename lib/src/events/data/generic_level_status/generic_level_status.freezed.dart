// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'generic_level_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
GenericLevelStatusData _$GenericLevelStatusDataFromJson(
    Map<String, dynamic> json) {
  return _GenericLevelStatusData.fromJson(json);
}

class _$GenericLevelStatusDataTearOff {
  const _$GenericLevelStatusDataTearOff();

// ignore: unused_element
  _GenericLevelStatusData call(
      int level, @nullable int targetLevel, int source) {
    return _GenericLevelStatusData(
      level,
      targetLevel,
      source,
    );
  }
}

// ignore: unused_element
const $GenericLevelStatusData = _$GenericLevelStatusDataTearOff();

mixin _$GenericLevelStatusData {
  int get level;
  @nullable
  int get targetLevel;
  int get source;

  Map<String, dynamic> toJson();
  $GenericLevelStatusDataCopyWith<GenericLevelStatusData> get copyWith;
}

abstract class $GenericLevelStatusDataCopyWith<$Res> {
  factory $GenericLevelStatusDataCopyWith(GenericLevelStatusData value,
          $Res Function(GenericLevelStatusData) then) =
      _$GenericLevelStatusDataCopyWithImpl<$Res>;
  $Res call({int level, @nullable int targetLevel, int source});
}

class _$GenericLevelStatusDataCopyWithImpl<$Res>
    implements $GenericLevelStatusDataCopyWith<$Res> {
  _$GenericLevelStatusDataCopyWithImpl(this._value, this._then);

  final GenericLevelStatusData _value;
  // ignore: unused_field
  final $Res Function(GenericLevelStatusData) _then;

  @override
  $Res call({
    Object level = freezed,
    Object targetLevel = freezed,
    Object source = freezed,
  }) {
    return _then(_value.copyWith(
      level: level == freezed ? _value.level : level as int,
      targetLevel:
          targetLevel == freezed ? _value.targetLevel : targetLevel as int,
      source: source == freezed ? _value.source : source as int,
    ));
  }
}

abstract class _$GenericLevelStatusDataCopyWith<$Res>
    implements $GenericLevelStatusDataCopyWith<$Res> {
  factory _$GenericLevelStatusDataCopyWith(_GenericLevelStatusData value,
          $Res Function(_GenericLevelStatusData) then) =
      __$GenericLevelStatusDataCopyWithImpl<$Res>;
  @override
  $Res call({int level, @nullable int targetLevel, int source});
}

class __$GenericLevelStatusDataCopyWithImpl<$Res>
    extends _$GenericLevelStatusDataCopyWithImpl<$Res>
    implements _$GenericLevelStatusDataCopyWith<$Res> {
  __$GenericLevelStatusDataCopyWithImpl(_GenericLevelStatusData _value,
      $Res Function(_GenericLevelStatusData) _then)
      : super(_value, (v) => _then(v as _GenericLevelStatusData));

  @override
  _GenericLevelStatusData get _value => super._value as _GenericLevelStatusData;

  @override
  $Res call({
    Object level = freezed,
    Object targetLevel = freezed,
    Object source = freezed,
  }) {
    return _then(_GenericLevelStatusData(
      level == freezed ? _value.level : level as int,
      targetLevel == freezed ? _value.targetLevel : targetLevel as int,
      source == freezed ? _value.source : source as int,
    ));
  }
}

@JsonSerializable()
class _$_GenericLevelStatusData implements _GenericLevelStatusData {
  const _$_GenericLevelStatusData(
      this.level, @nullable this.targetLevel, this.source)
      : assert(level != null),
        assert(source != null);

  factory _$_GenericLevelStatusData.fromJson(Map<String, dynamic> json) =>
      _$_$_GenericLevelStatusDataFromJson(json);

  @override
  final int level;
  @override
  @nullable
  final int targetLevel;
  @override
  final int source;

  @override
  String toString() {
    return 'GenericLevelStatusData(level: $level, targetLevel: $targetLevel, source: $source)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GenericLevelStatusData &&
            (identical(other.level, level) ||
                const DeepCollectionEquality().equals(other.level, level)) &&
            (identical(other.targetLevel, targetLevel) ||
                const DeepCollectionEquality()
                    .equals(other.targetLevel, targetLevel)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(level) ^
      const DeepCollectionEquality().hash(targetLevel) ^
      const DeepCollectionEquality().hash(source);

  @override
  _$GenericLevelStatusDataCopyWith<_GenericLevelStatusData> get copyWith =>
      __$GenericLevelStatusDataCopyWithImpl<_GenericLevelStatusData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GenericLevelStatusDataToJson(this);
  }
}

abstract class _GenericLevelStatusData implements GenericLevelStatusData {
  const factory _GenericLevelStatusData(
          int level, @nullable int targetLevel, int source) =
      _$_GenericLevelStatusData;

  factory _GenericLevelStatusData.fromJson(Map<String, dynamic> json) =
      _$_GenericLevelStatusData.fromJson;

  @override
  int get level;
  @override
  @nullable
  int get targetLevel;
  @override
  int get source;
  @override
  _$GenericLevelStatusDataCopyWith<_GenericLevelStatusData> get copyWith;
}
