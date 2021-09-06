// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GroupData _$GroupDataFromJson(Map<String, dynamic> json) {
  return _GroupData.fromJson(json);
}

/// @nodoc
class _$GroupDataTearOff {
  const _$GroupDataTearOff();

  _GroupData call(
      String name, int address, String? addressLabel, String meshUuid, int parentAddress, String? parentAddressLabel) {
    return _GroupData(
      name,
      address,
      addressLabel,
      meshUuid,
      parentAddress,
      parentAddressLabel,
    );
  }

  GroupData fromJson(Map<String, Object> json) {
    return GroupData.fromJson(json);
  }
}

/// @nodoc
const $GroupData = _$GroupDataTearOff();

/// @nodoc
mixin _$GroupData {
  String get name => throw _privateConstructorUsedError;
  int get address => throw _privateConstructorUsedError;
  String? get addressLabel => throw _privateConstructorUsedError;
  String get meshUuid => throw _privateConstructorUsedError;
  int get parentAddress => throw _privateConstructorUsedError;
  String? get parentAddressLabel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupDataCopyWith<GroupData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupDataCopyWith<$Res> {
  factory $GroupDataCopyWith(GroupData value, $Res Function(GroupData) then) = _$GroupDataCopyWithImpl<$Res>;
  $Res call(
      {String name, int address, String? addressLabel, String meshUuid, int parentAddress, String? parentAddressLabel});
}

/// @nodoc
class _$GroupDataCopyWithImpl<$Res> implements $GroupDataCopyWith<$Res> {
  _$GroupDataCopyWithImpl(this._value, this._then);

  final GroupData _value;
  // ignore: unused_field
  final $Res Function(GroupData) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? address = freezed,
    Object? addressLabel = freezed,
    Object? meshUuid = freezed,
    Object? parentAddress = freezed,
    Object? parentAddressLabel = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as int,
      addressLabel: addressLabel == freezed
          ? _value.addressLabel
          : addressLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      meshUuid: meshUuid == freezed
          ? _value.meshUuid
          : meshUuid // ignore: cast_nullable_to_non_nullable
              as String,
      parentAddress: parentAddress == freezed
          ? _value.parentAddress
          : parentAddress // ignore: cast_nullable_to_non_nullable
              as int,
      parentAddressLabel: parentAddressLabel == freezed
          ? _value.parentAddressLabel
          : parentAddressLabel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$GroupDataCopyWith<$Res> implements $GroupDataCopyWith<$Res> {
  factory _$GroupDataCopyWith(_GroupData value, $Res Function(_GroupData) then) = __$GroupDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name, int address, String? addressLabel, String meshUuid, int parentAddress, String? parentAddressLabel});
}

/// @nodoc
class __$GroupDataCopyWithImpl<$Res> extends _$GroupDataCopyWithImpl<$Res> implements _$GroupDataCopyWith<$Res> {
  __$GroupDataCopyWithImpl(_GroupData _value, $Res Function(_GroupData) _then)
      : super(_value, (v) => _then(v as _GroupData));

  @override
  _GroupData get _value => super._value as _GroupData;

  @override
  $Res call({
    Object? name = freezed,
    Object? address = freezed,
    Object? addressLabel = freezed,
    Object? meshUuid = freezed,
    Object? parentAddress = freezed,
    Object? parentAddressLabel = freezed,
  }) {
    return _then(_GroupData(
      name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as int,
      addressLabel == freezed
          ? _value.addressLabel
          : addressLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      meshUuid == freezed
          ? _value.meshUuid
          : meshUuid // ignore: cast_nullable_to_non_nullable
              as String,
      parentAddress == freezed
          ? _value.parentAddress
          : parentAddress // ignore: cast_nullable_to_non_nullable
              as int,
      parentAddressLabel == freezed
          ? _value.parentAddressLabel
          : parentAddressLabel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GroupData implements _GroupData {
  const _$_GroupData(
      this.name, this.address, this.addressLabel, this.meshUuid, this.parentAddress, this.parentAddressLabel);

  factory _$_GroupData.fromJson(Map<String, dynamic> json) => _$_$_GroupDataFromJson(json);

  @override
  final String name;
  @override
  final int address;
  @override
  final String? addressLabel;
  @override
  final String meshUuid;
  @override
  final int parentAddress;
  @override
  final String? parentAddressLabel;

  @override
  String toString() {
    return 'GroupData(name: $name, address: $address, addressLabel: $addressLabel, meshUuid: $meshUuid, parentAddress: $parentAddress, parentAddressLabel: $parentAddressLabel)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GroupData &&
            (identical(other.name, name) || const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.address, address) || const DeepCollectionEquality().equals(other.address, address)) &&
            (identical(other.addressLabel, addressLabel) ||
                const DeepCollectionEquality().equals(other.addressLabel, addressLabel)) &&
            (identical(other.meshUuid, meshUuid) || const DeepCollectionEquality().equals(other.meshUuid, meshUuid)) &&
            (identical(other.parentAddress, parentAddress) ||
                const DeepCollectionEquality().equals(other.parentAddress, parentAddress)) &&
            (identical(other.parentAddressLabel, parentAddressLabel) ||
                const DeepCollectionEquality().equals(other.parentAddressLabel, parentAddressLabel)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(address) ^
      const DeepCollectionEquality().hash(addressLabel) ^
      const DeepCollectionEquality().hash(meshUuid) ^
      const DeepCollectionEquality().hash(parentAddress) ^
      const DeepCollectionEquality().hash(parentAddressLabel);

  @JsonKey(ignore: true)
  @override
  _$GroupDataCopyWith<_GroupData> get copyWith => __$GroupDataCopyWithImpl<_GroupData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GroupDataToJson(this);
  }
}

abstract class _GroupData implements GroupData {
  const factory _GroupData(String name, int address, String? addressLabel, String meshUuid, int parentAddress,
      String? parentAddressLabel) = _$_GroupData;

  factory _GroupData.fromJson(Map<String, dynamic> json) = _$_GroupData.fromJson;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  int get address => throw _privateConstructorUsedError;
  @override
  String? get addressLabel => throw _privateConstructorUsedError;
  @override
  String get meshUuid => throw _privateConstructorUsedError;
  @override
  int get parentAddress => throw _privateConstructorUsedError;
  @override
  String? get parentAddressLabel => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GroupDataCopyWith<_GroupData> get copyWith => throw _privateConstructorUsedError;
}
