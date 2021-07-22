// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'allocated_group_range.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
AllocatedGroupRange _$AllocatedGroupRangeFromJson(Map<String, dynamic> json) {
  return _AllocatedGroupRange.fromJson(json);
}

/// @nodoc
class _$AllocatedGroupRangeTearOff {
  const _$AllocatedGroupRangeTearOff();

// ignore: unused_element
  _AllocatedGroupRange call(int lowAddress, int highAddress) {
    return _AllocatedGroupRange(
      lowAddress,
      highAddress,
    );
  }

// ignore: unused_element
  AllocatedGroupRange fromJson(Map<String, Object> json) {
    return AllocatedGroupRange.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $AllocatedGroupRange = _$AllocatedGroupRangeTearOff();

/// @nodoc
mixin _$AllocatedGroupRange {
  int get lowAddress;
  int get highAddress;

  Map<String, dynamic> toJson();
  $AllocatedGroupRangeCopyWith<AllocatedGroupRange> get copyWith;
}

/// @nodoc
abstract class $AllocatedGroupRangeCopyWith<$Res> {
  factory $AllocatedGroupRangeCopyWith(
          AllocatedGroupRange value, $Res Function(AllocatedGroupRange) then) =
      _$AllocatedGroupRangeCopyWithImpl<$Res>;
  $Res call({int lowAddress, int highAddress});
}

/// @nodoc
class _$AllocatedGroupRangeCopyWithImpl<$Res>
    implements $AllocatedGroupRangeCopyWith<$Res> {
  _$AllocatedGroupRangeCopyWithImpl(this._value, this._then);

  final AllocatedGroupRange _value;
  // ignore: unused_field
  final $Res Function(AllocatedGroupRange) _then;

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
abstract class _$AllocatedGroupRangeCopyWith<$Res>
    implements $AllocatedGroupRangeCopyWith<$Res> {
  factory _$AllocatedGroupRangeCopyWith(_AllocatedGroupRange value,
          $Res Function(_AllocatedGroupRange) then) =
      __$AllocatedGroupRangeCopyWithImpl<$Res>;
  @override
  $Res call({int lowAddress, int highAddress});
}

/// @nodoc
class __$AllocatedGroupRangeCopyWithImpl<$Res>
    extends _$AllocatedGroupRangeCopyWithImpl<$Res>
    implements _$AllocatedGroupRangeCopyWith<$Res> {
  __$AllocatedGroupRangeCopyWithImpl(
      _AllocatedGroupRange _value, $Res Function(_AllocatedGroupRange) _then)
      : super(_value, (v) => _then(v as _AllocatedGroupRange));

  @override
  _AllocatedGroupRange get _value => super._value as _AllocatedGroupRange;

  @override
  $Res call({
    Object lowAddress = freezed,
    Object highAddress = freezed,
  }) {
    return _then(_AllocatedGroupRange(
      lowAddress == freezed ? _value.lowAddress : lowAddress as int,
      highAddress == freezed ? _value.highAddress : highAddress as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_AllocatedGroupRange implements _AllocatedGroupRange {
  const _$_AllocatedGroupRange(this.lowAddress, this.highAddress)
      : assert(lowAddress != null),
        assert(highAddress != null);

  factory _$_AllocatedGroupRange.fromJson(Map<String, dynamic> json) =>
      _$_$_AllocatedGroupRangeFromJson(json);

  @override
  final int lowAddress;
  @override
  final int highAddress;

  @override
  String toString() {
    return 'AllocatedGroupRange(lowAddress: $lowAddress, highAddress: $highAddress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AllocatedGroupRange &&
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
  _$AllocatedGroupRangeCopyWith<_AllocatedGroupRange> get copyWith =>
      __$AllocatedGroupRangeCopyWithImpl<_AllocatedGroupRange>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AllocatedGroupRangeToJson(this);
  }
}

abstract class _AllocatedGroupRange implements AllocatedGroupRange {
  const factory _AllocatedGroupRange(int lowAddress, int highAddress) =
      _$_AllocatedGroupRange;

  factory _AllocatedGroupRange.fromJson(Map<String, dynamic> json) =
      _$_AllocatedGroupRange.fromJson;

  @override
  int get lowAddress;
  @override
  int get highAddress;
  @override
  _$AllocatedGroupRangeCopyWith<_AllocatedGroupRange> get copyWith;
}
