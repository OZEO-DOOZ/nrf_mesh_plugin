// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'allocated_unicast_range.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
AllocatedUnicastRange _$AllocatedUnicastRangeFromJson(
    Map<String, dynamic> json) {
  return _AllocatedUnicastRange.fromJson(json);
}

/// @nodoc
class _$AllocatedUnicastRangeTearOff {
  const _$AllocatedUnicastRangeTearOff();

// ignore: unused_element
  _AllocatedUnicastRange call(int lowAddress, int highAddress) {
    return _AllocatedUnicastRange(
      lowAddress,
      highAddress,
    );
  }

// ignore: unused_element
  AllocatedUnicastRange fromJson(Map<String, Object> json) {
    return AllocatedUnicastRange.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $AllocatedUnicastRange = _$AllocatedUnicastRangeTearOff();

/// @nodoc
mixin _$AllocatedUnicastRange {
  int get lowAddress;
  int get highAddress;

  Map<String, dynamic> toJson();
  $AllocatedUnicastRangeCopyWith<AllocatedUnicastRange> get copyWith;
}

/// @nodoc
abstract class $AllocatedUnicastRangeCopyWith<$Res> {
  factory $AllocatedUnicastRangeCopyWith(AllocatedUnicastRange value,
          $Res Function(AllocatedUnicastRange) then) =
      _$AllocatedUnicastRangeCopyWithImpl<$Res>;
  $Res call({int lowAddress, int highAddress});
}

/// @nodoc
class _$AllocatedUnicastRangeCopyWithImpl<$Res>
    implements $AllocatedUnicastRangeCopyWith<$Res> {
  _$AllocatedUnicastRangeCopyWithImpl(this._value, this._then);

  final AllocatedUnicastRange _value;
  // ignore: unused_field
  final $Res Function(AllocatedUnicastRange) _then;

  @override
  $Res call({
    Object lowAddress = freezed,
    Object highAddress = freezed,
  }) {
    return _then(_value.copyWith(
      lowAddress: lowAddress == freezed ? _value.lowAddress : lowAddress as int,
      highAddress:
          highAddress == freezed ? _value.highAddress : highAddress as int,
    ));
  }
}

/// @nodoc
abstract class _$AllocatedUnicastRangeCopyWith<$Res>
    implements $AllocatedUnicastRangeCopyWith<$Res> {
  factory _$AllocatedUnicastRangeCopyWith(_AllocatedUnicastRange value,
          $Res Function(_AllocatedUnicastRange) then) =
      __$AllocatedUnicastRangeCopyWithImpl<$Res>;
  @override
  $Res call({int lowAddress, int highAddress});
}

/// @nodoc
class __$AllocatedUnicastRangeCopyWithImpl<$Res>
    extends _$AllocatedUnicastRangeCopyWithImpl<$Res>
    implements _$AllocatedUnicastRangeCopyWith<$Res> {
  __$AllocatedUnicastRangeCopyWithImpl(_AllocatedUnicastRange _value,
      $Res Function(_AllocatedUnicastRange) _then)
      : super(_value, (v) => _then(v as _AllocatedUnicastRange));

  @override
  _AllocatedUnicastRange get _value => super._value as _AllocatedUnicastRange;

  @override
  $Res call({
    Object lowAddress = freezed,
    Object highAddress = freezed,
  }) {
    return _then(_AllocatedUnicastRange(
      lowAddress == freezed ? _value.lowAddress : lowAddress as int,
      highAddress == freezed ? _value.highAddress : highAddress as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_AllocatedUnicastRange implements _AllocatedUnicastRange {
  const _$_AllocatedUnicastRange(this.lowAddress, this.highAddress)
      : assert(lowAddress != null),
        assert(highAddress != null);

  factory _$_AllocatedUnicastRange.fromJson(Map<String, dynamic> json) =>
      _$_$_AllocatedUnicastRangeFromJson(json);

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
                const DeepCollectionEquality()
                    .equals(other.lowAddress, lowAddress)) &&
            (identical(other.highAddress, highAddress) ||
                const DeepCollectionEquality()
                    .equals(other.highAddress, highAddress)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(lowAddress) ^
      const DeepCollectionEquality().hash(highAddress);

  @override
  _$AllocatedUnicastRangeCopyWith<_AllocatedUnicastRange> get copyWith =>
      __$AllocatedUnicastRangeCopyWithImpl<_AllocatedUnicastRange>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AllocatedUnicastRangeToJson(this);
  }
}

abstract class _AllocatedUnicastRange implements AllocatedUnicastRange {
  const factory _AllocatedUnicastRange(int lowAddress, int highAddress) =
      _$_AllocatedUnicastRange;

  factory _AllocatedUnicastRange.fromJson(Map<String, dynamic> json) =
      _$_AllocatedUnicastRange.fromJson;

  @override
  int get lowAddress;
  @override
  int get highAddress;
  @override
  _$AllocatedUnicastRangeCopyWith<_AllocatedUnicastRange> get copyWith;
}
