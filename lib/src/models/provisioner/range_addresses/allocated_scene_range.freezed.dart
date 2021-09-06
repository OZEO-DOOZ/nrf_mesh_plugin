// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'allocated_scene_range.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AllocatedSceneRange _$AllocatedSceneRangeFromJson(Map<String, dynamic> json) {
  return _AllocatedSceneRange.fromJson(json);
}

/// @nodoc
class _$AllocatedSceneRangeTearOff {
  const _$AllocatedSceneRangeTearOff();

  _AllocatedSceneRange call(int firstScene, int lastScene) {
    return _AllocatedSceneRange(
      firstScene,
      lastScene,
    );
  }

  AllocatedSceneRange fromJson(Map<String, Object> json) {
    return AllocatedSceneRange.fromJson(json);
  }
}

/// @nodoc
const $AllocatedSceneRange = _$AllocatedSceneRangeTearOff();

/// @nodoc
mixin _$AllocatedSceneRange {
  int get firstScene => throw _privateConstructorUsedError;
  int get lastScene => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AllocatedSceneRangeCopyWith<AllocatedSceneRange> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllocatedSceneRangeCopyWith<$Res> {
  factory $AllocatedSceneRangeCopyWith(AllocatedSceneRange value, $Res Function(AllocatedSceneRange) then) =
      _$AllocatedSceneRangeCopyWithImpl<$Res>;
  $Res call({int firstScene, int lastScene});
}

/// @nodoc
class _$AllocatedSceneRangeCopyWithImpl<$Res> implements $AllocatedSceneRangeCopyWith<$Res> {
  _$AllocatedSceneRangeCopyWithImpl(this._value, this._then);

  final AllocatedSceneRange _value;
  // ignore: unused_field
  final $Res Function(AllocatedSceneRange) _then;

  @override
  $Res call({
    Object? firstScene = freezed,
    Object? lastScene = freezed,
  }) {
    return _then(_value.copyWith(
      firstScene: firstScene == freezed
          ? _value.firstScene
          : firstScene // ignore: cast_nullable_to_non_nullable
              as int,
      lastScene: lastScene == freezed
          ? _value.lastScene
          : lastScene // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$AllocatedSceneRangeCopyWith<$Res> implements $AllocatedSceneRangeCopyWith<$Res> {
  factory _$AllocatedSceneRangeCopyWith(_AllocatedSceneRange value, $Res Function(_AllocatedSceneRange) then) =
      __$AllocatedSceneRangeCopyWithImpl<$Res>;
  @override
  $Res call({int firstScene, int lastScene});
}

/// @nodoc
class __$AllocatedSceneRangeCopyWithImpl<$Res> extends _$AllocatedSceneRangeCopyWithImpl<$Res>
    implements _$AllocatedSceneRangeCopyWith<$Res> {
  __$AllocatedSceneRangeCopyWithImpl(_AllocatedSceneRange _value, $Res Function(_AllocatedSceneRange) _then)
      : super(_value, (v) => _then(v as _AllocatedSceneRange));

  @override
  _AllocatedSceneRange get _value => super._value as _AllocatedSceneRange;

  @override
  $Res call({
    Object? firstScene = freezed,
    Object? lastScene = freezed,
  }) {
    return _then(_AllocatedSceneRange(
      firstScene == freezed
          ? _value.firstScene
          : firstScene // ignore: cast_nullable_to_non_nullable
              as int,
      lastScene == freezed
          ? _value.lastScene
          : lastScene // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AllocatedSceneRange implements _AllocatedSceneRange {
  const _$_AllocatedSceneRange(this.firstScene, this.lastScene);

  factory _$_AllocatedSceneRange.fromJson(Map<String, dynamic> json) => _$_$_AllocatedSceneRangeFromJson(json);

  @override
  final int firstScene;
  @override
  final int lastScene;

  @override
  String toString() {
    return 'AllocatedSceneRange(firstScene: $firstScene, lastScene: $lastScene)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AllocatedSceneRange &&
            (identical(other.firstScene, firstScene) ||
                const DeepCollectionEquality().equals(other.firstScene, firstScene)) &&
            (identical(other.lastScene, lastScene) ||
                const DeepCollectionEquality().equals(other.lastScene, lastScene)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(firstScene) ^
      const DeepCollectionEquality().hash(lastScene);

  @JsonKey(ignore: true)
  @override
  _$AllocatedSceneRangeCopyWith<_AllocatedSceneRange> get copyWith =>
      __$AllocatedSceneRangeCopyWithImpl<_AllocatedSceneRange>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AllocatedSceneRangeToJson(this);
  }
}

abstract class _AllocatedSceneRange implements AllocatedSceneRange {
  const factory _AllocatedSceneRange(int firstScene, int lastScene) = _$_AllocatedSceneRange;

  factory _AllocatedSceneRange.fromJson(Map<String, dynamic> json) = _$_AllocatedSceneRange.fromJson;

  @override
  int get firstScene => throw _privateConstructorUsedError;
  @override
  int get lastScene => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AllocatedSceneRangeCopyWith<_AllocatedSceneRange> get copyWith => throw _privateConstructorUsedError;
}
