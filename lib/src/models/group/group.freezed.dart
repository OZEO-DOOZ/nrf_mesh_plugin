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

class _$GroupDataTearOff {
  const _$GroupDataTearOff();

// ignore: unused_element
  _GroupData call(int id, String name, int address, String addressLabel,
      String meshUuid, int parentAddress, String parentAddressLabel) {
    return _GroupData(
      id,
      name,
      address,
      addressLabel,
      meshUuid,
      parentAddress,
      parentAddressLabel,
    );
  }
}

// ignore: unused_element
const $GroupData = _$GroupDataTearOff();

mixin _$GroupData {
  int get id;
  String get name;
  int get address;
  String get addressLabel;
  String get meshUuid;
  int get parentAddress;
  String get parentAddressLabel;

  Map<String, dynamic> toJson();
  $GroupDataCopyWith<GroupData> get copyWith;
}

abstract class $GroupDataCopyWith<$Res> {
  factory $GroupDataCopyWith(GroupData value, $Res Function(GroupData) then) =
      _$GroupDataCopyWithImpl<$Res>;
  $Res call(
      {int id,
      String name,
      int address,
      String addressLabel,
      String meshUuid,
      int parentAddress,
      String parentAddressLabel});
}

class _$GroupDataCopyWithImpl<$Res> implements $GroupDataCopyWith<$Res> {
  _$GroupDataCopyWithImpl(this._value, this._then);

  final GroupData _value;
  // ignore: unused_field
  final $Res Function(GroupData) _then;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object address = freezed,
    Object addressLabel = freezed,
    Object meshUuid = freezed,
    Object parentAddress = freezed,
    Object parentAddressLabel = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      name: name == freezed ? _value.name : name as String,
      address: address == freezed ? _value.address : address as int,
      addressLabel: addressLabel == freezed
          ? _value.addressLabel
          : addressLabel as String,
      meshUuid: meshUuid == freezed ? _value.meshUuid : meshUuid as String,
      parentAddress: parentAddress == freezed
          ? _value.parentAddress
          : parentAddress as int,
      parentAddressLabel: parentAddressLabel == freezed
          ? _value.parentAddressLabel
          : parentAddressLabel as String,
    ));
  }
}

abstract class _$GroupDataCopyWith<$Res> implements $GroupDataCopyWith<$Res> {
  factory _$GroupDataCopyWith(
          _GroupData value, $Res Function(_GroupData) then) =
      __$GroupDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      String name,
      int address,
      String addressLabel,
      String meshUuid,
      int parentAddress,
      String parentAddressLabel});
}

class __$GroupDataCopyWithImpl<$Res> extends _$GroupDataCopyWithImpl<$Res>
    implements _$GroupDataCopyWith<$Res> {
  __$GroupDataCopyWithImpl(_GroupData _value, $Res Function(_GroupData) _then)
      : super(_value, (v) => _then(v as _GroupData));

  @override
  _GroupData get _value => super._value as _GroupData;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object address = freezed,
    Object addressLabel = freezed,
    Object meshUuid = freezed,
    Object parentAddress = freezed,
    Object parentAddressLabel = freezed,
  }) {
    return _then(_GroupData(
      id == freezed ? _value.id : id as int,
      name == freezed ? _value.name : name as String,
      address == freezed ? _value.address : address as int,
      addressLabel == freezed ? _value.addressLabel : addressLabel as String,
      meshUuid == freezed ? _value.meshUuid : meshUuid as String,
      parentAddress == freezed ? _value.parentAddress : parentAddress as int,
      parentAddressLabel == freezed
          ? _value.parentAddressLabel
          : parentAddressLabel as String,
    ));
  }
}

@JsonSerializable()
class _$_GroupData implements _GroupData {
  const _$_GroupData(this.id, this.name, this.address, this.addressLabel,
      this.meshUuid, this.parentAddress, this.parentAddressLabel)
      : assert(id != null),
        assert(name != null),
        assert(address != null),
        assert(addressLabel != null),
        assert(meshUuid != null),
        assert(parentAddress != null),
        assert(parentAddressLabel != null);

  factory _$_GroupData.fromJson(Map<String, dynamic> json) =>
      _$_$_GroupDataFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int address;
  @override
  final String addressLabel;
  @override
  final String meshUuid;
  @override
  final int parentAddress;
  @override
  final String parentAddressLabel;

  @override
  String toString() {
    return 'GroupData(id: $id, name: $name, address: $address, addressLabel: $addressLabel, meshUuid: $meshUuid, parentAddress: $parentAddress, parentAddressLabel: $parentAddressLabel)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GroupData &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.address, address) ||
                const DeepCollectionEquality()
                    .equals(other.address, address)) &&
            (identical(other.addressLabel, addressLabel) ||
                const DeepCollectionEquality()
                    .equals(other.addressLabel, addressLabel)) &&
            (identical(other.meshUuid, meshUuid) ||
                const DeepCollectionEquality()
                    .equals(other.meshUuid, meshUuid)) &&
            (identical(other.parentAddress, parentAddress) ||
                const DeepCollectionEquality()
                    .equals(other.parentAddress, parentAddress)) &&
            (identical(other.parentAddressLabel, parentAddressLabel) ||
                const DeepCollectionEquality()
                    .equals(other.parentAddressLabel, parentAddressLabel)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(address) ^
      const DeepCollectionEquality().hash(addressLabel) ^
      const DeepCollectionEquality().hash(meshUuid) ^
      const DeepCollectionEquality().hash(parentAddress) ^
      const DeepCollectionEquality().hash(parentAddressLabel);

  @override
  _$GroupDataCopyWith<_GroupData> get copyWith =>
      __$GroupDataCopyWithImpl<_GroupData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GroupDataToJson(this);
  }
}

abstract class _GroupData implements GroupData {
  const factory _GroupData(
      int id,
      String name,
      int address,
      String addressLabel,
      String meshUuid,
      int parentAddress,
      String parentAddressLabel) = _$_GroupData;

  factory _GroupData.fromJson(Map<String, dynamic> json) =
      _$_GroupData.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get address;
  @override
  String get addressLabel;
  @override
  String get meshUuid;
  @override
  int get parentAddress;
  @override
  String get parentAddressLabel;
  @override
  _$GroupDataCopyWith<_GroupData> get copyWith;
}
