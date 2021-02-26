// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
GroupData _$GroupDataFromJson(Map<String, dynamic> json) {
  return _GroupData.fromJson(json);
}

/// @nodoc
class _$GroupDataTearOff {
  const _$GroupDataTearOff();

// ignore: unused_element
  _GroupData call(String name, int address, @nullable String addressLabel, String meshUuid, int parentAddress,
      @nullable String parentAddressLabel) {
    return _GroupData(
      name,
      address,
      addressLabel,
      meshUuid,
      parentAddress,
      parentAddressLabel,
    );
  }

// ignore: unused_element
  GroupData fromJson(Map<String, Object> json) {
    return GroupData.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $GroupData = _$GroupDataTearOff();

/// @nodoc
mixin _$GroupData {
  String get name;
  int get address;
  @nullable
  String get addressLabel;
  String get meshUuid;
  int get parentAddress;
  @nullable
  String get parentAddressLabel;

  Map<String, dynamic> toJson();
  $GroupDataCopyWith<GroupData> get copyWith;
}

/// @nodoc
abstract class $GroupDataCopyWith<$Res> {
  factory $GroupDataCopyWith(GroupData value, $Res Function(GroupData) then) = _$GroupDataCopyWithImpl<$Res>;
  $Res call(
      {String name,
      int address,
      @nullable String addressLabel,
      String meshUuid,
      int parentAddress,
      @nullable String parentAddressLabel});
}

/// @nodoc
class _$GroupDataCopyWithImpl<$Res> implements $GroupDataCopyWith<$Res> {
  _$GroupDataCopyWithImpl(this._value, this._then);

  final GroupData _value;
  // ignore: unused_field
  final $Res Function(GroupData) _then;

  @override
  $Res call({
    Object name = freezed,
    Object address = freezed,
    Object addressLabel = freezed,
    Object meshUuid = freezed,
    Object parentAddress = freezed,
    Object parentAddressLabel = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      address: address == freezed ? _value.address : address as int,
      addressLabel: addressLabel == freezed ? _value.addressLabel : addressLabel as String,
      meshUuid: meshUuid == freezed ? _value.meshUuid : meshUuid as String,
      parentAddress: parentAddress == freezed ? _value.parentAddress : parentAddress as int,
      parentAddressLabel: parentAddressLabel == freezed ? _value.parentAddressLabel : parentAddressLabel as String,
    ));
  }
}

/// @nodoc
abstract class _$GroupDataCopyWith<$Res> implements $GroupDataCopyWith<$Res> {
  factory _$GroupDataCopyWith(_GroupData value, $Res Function(_GroupData) then) = __$GroupDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      int address,
      @nullable String addressLabel,
      String meshUuid,
      int parentAddress,
      @nullable String parentAddressLabel});
}

/// @nodoc
class __$GroupDataCopyWithImpl<$Res> extends _$GroupDataCopyWithImpl<$Res> implements _$GroupDataCopyWith<$Res> {
  __$GroupDataCopyWithImpl(_GroupData _value, $Res Function(_GroupData) _then)
      : super(_value, (v) => _then(v as _GroupData));

  @override
  _GroupData get _value => super._value as _GroupData;

  @override
  $Res call({
    Object name = freezed,
    Object address = freezed,
    Object addressLabel = freezed,
    Object meshUuid = freezed,
    Object parentAddress = freezed,
    Object parentAddressLabel = freezed,
  }) {
    return _then(_GroupData(
      name == freezed ? _value.name : name as String,
      address == freezed ? _value.address : address as int,
      addressLabel == freezed ? _value.addressLabel : addressLabel as String,
      meshUuid == freezed ? _value.meshUuid : meshUuid as String,
      parentAddress == freezed ? _value.parentAddress : parentAddress as int,
      parentAddressLabel == freezed ? _value.parentAddressLabel : parentAddressLabel as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_GroupData implements _GroupData {
  const _$_GroupData(this.name, this.address, @nullable this.addressLabel, this.meshUuid, this.parentAddress,
      @nullable this.parentAddressLabel)
      : assert(name != null),
        assert(address != null),
        assert(meshUuid != null),
        assert(parentAddress != null);

  factory _$_GroupData.fromJson(Map<String, dynamic> json) => _$_$_GroupDataFromJson(json);

  @override
  final String name;
  @override
  final int address;
  @override
  @nullable
  final String addressLabel;
  @override
  final String meshUuid;
  @override
  final int parentAddress;
  @override
  @nullable
  final String parentAddressLabel;

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

  @override
  _$GroupDataCopyWith<_GroupData> get copyWith => __$GroupDataCopyWithImpl<_GroupData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GroupDataToJson(this);
  }
}

abstract class _GroupData implements GroupData {
  const factory _GroupData(String name, int address, @nullable String addressLabel, String meshUuid, int parentAddress,
      @nullable String parentAddressLabel) = _$_GroupData;

  factory _GroupData.fromJson(Map<String, dynamic> json) = _$_GroupData.fromJson;

  @override
  String get name;
  @override
  int get address;
  @override
  @nullable
  String get addressLabel;
  @override
  String get meshUuid;
  @override
  int get parentAddress;
  @override
  @nullable
  String get parentAddressLabel;
  @override
  _$GroupDataCopyWith<_GroupData> get copyWith;
}
