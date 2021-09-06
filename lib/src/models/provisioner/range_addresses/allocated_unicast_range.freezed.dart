// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'allocated_unicast_range.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AllocatedUnicastRange _$AllocatedUnicastRangeFromJson(Map<String, dynamic> json) {
  return _AllocatedUnicastRange.fromJson(json);
}

/// @nodoc
class _$AllocatedUnicastRangeTearOff {
  const _$AllocatedUnicastRangeTearOff();

  _AllocatedUnicastRange call(int lowAddress, int highAddress) {
    return _AllocatedUnicastRange(
      lowAddress,
      highAddress,
    );
  }

  AllocatedUnicastRange fromJson(Map<String, Object> json) {
    return AllocatedUnicastRange.fromJson(json);
  }
}

/// @nodoc
const $AllocatedUnicastRange = _$AllocatedUnicastRangeTearOff();

/// @nodoc
mixin _$AllocatedUnicastRange {
  int get lowAddress => throw _privateConstructorUsedError;
  int get highAddress => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AllocatedUnicastRangeCopyWith<AllocatedUnicastRange> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllocatedUnicastRangeCopyWith<$Res> {
  factory $AllocatedUnicastRangeCopyWith(AllocatedUnicastRange value, $Res Function(AllocatedUnicastRange) then) =
      _$AllocatedUnicastRangeCopyWithImpl<$Res>;
  $Res call({int lowAddress, int highAddress});
}

/// @nodoc
class _$AllocatedUnicastRangeCopyWithImpl<$Res> implements $AllocatedUnicastRangeCopyWith<$Res> {
  _$AllocatedUnicastRangeCopyWithImpl(this._value, this._then);

  final AllocatedUnicastRange _value;
  // ignore: unused_field
  final $Res Function(AllocatedUnicastRange) _then;

  @override
  $Res call({
    Object? lowAddress = freezed,
    Object? highAddress = freezed,
  }) {
    return _then(_value.copyWith(
      lowAddress: lowAddress == freezed
          ? _value.lowAddress
          : lowAddress // ignore: cast_nullable_to_non_nullable
              as int,
      highAddress: highAddress == freezed
          ? _value.highAddress
          : highAddress // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$AllocatedUnicastRangeCopyWith<$Res> implements $AllocatedUnicastRangeCopyWith<$Res> {
  factory _$AllocatedUnicastRangeCopyWith(_AllocatedUnicastRange value, $Res Function(_AllocatedUnicastRange) then) =
      __$AllocatedUnicastRangeCopyWithImpl<$Res>;
  @override
  $Res call({int lowAddress, int highAddress});
}

/// @nodoc
class __$AllocatedUnicastRangeCopyWithImpl<$Res> extends _$AllocatedUnicastRangeCopyWithImpl<$Res>
    implements _$AllocatedUnicastRangeCopyWith<$Res> {
  __$AllocatedUnicastRangeCopyWithImpl(_AllocatedUnicastRange _value, $Res Function(_AllocatedUnicastRange) _then)
      : super(_value, (v) => _then(v as _AllocatedUnicastRange));

  @override
  _AllocatedUnicastRange get _value => super._value as _AllocatedUnicastRange;

  @override
  $Res call({
    Object? lowAddress = freezed,
    Object? highAddress = freezed,
  }) {
    return _then(_AllocatedUnicastRange(
      lowAddress == freezed
          ? _value.lowAddress
          : lowAddress // ignore: cast_nullable_to_non_nullable
              as int,
      highAddress == freezed
          ? _value.highAddress
          : highAddress // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AllocatedUnicastRange implements _AllocatedUnicastRange {
  const _$_AllocatedUnicastRange(this.lowAddress, this.highAddress);

  factory _$_AllocatedUnicastRange.fromJson(Map<String, dynamic> json) => _$_$_AllocatedUnicastRangeFromJson(json);

  @override
  final int lowAddress;
  @override
  final int highAddress;

  @override
  String toString() {
    return 'AllocatedUnicastRange(lowAddress: $lowAddress, highAddress: $highAddress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AllocatedUnicastRange &&
            (identical(other.lowAddress, lowAddress) ||
                const DeepCollectionEquality().equals(other.lowAddress, lowAddress)) &&
            (identical(other.highAddress, highAddress) ||
                const DeepCollectionEquality().equals(other.highAddress, highAddress)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(lowAddress) ^
      const DeepCollectionEquality().hash(highAddress);

  @JsonKey(ignore: true)
  @override
  _$AllocatedUnicastRangeCopyWith<_AllocatedUnicastRange> get copyWith =>
      __$AllocatedUnicastRangeCopyWithImpl<_AllocatedUnicastRange>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AllocatedUnicastRangeToJson(this);
  }
}

abstract class _AllocatedUnicastRange implements AllocatedUnicastRange {
  const factory _AllocatedUnicastRange(int lowAddress, int highAddress) = _$_AllocatedUnicastRange;

  factory _AllocatedUnicastRange.fromJson(Map<String, dynamic> json) = _$_AllocatedUnicastRange.fromJson;

  @override
  int get lowAddress => throw _privateConstructorUsedError;
  @override
  int get highAddress => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AllocatedUnicastRangeCopyWith<_AllocatedUnicastRange> get copyWith => throw _privateConstructorUsedError;
}
