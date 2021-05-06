// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'provisioner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Provisioner _$ProvisionerFromJson(Map<String, dynamic> json) {
  return _Provisioner.fromJson(json);
}

/// @nodoc
class _$ProvisionerTearOff {
  const _$ProvisionerTearOff();

// ignore: unused_element
  _Provisioner call(
      String provisionerName,
      String provisionerUuid,
      int globalTtl,
      int provisionerAddress,
      List<AllocatedUnicastRange> allocatedUnicastRanges,
      List<AllocatedGroupRange> allocatedGroupRanges,
      List<AllocatedSceneRange> allocatedSceneRanges,
      bool lastSelected) {
    return _Provisioner(
      provisionerName,
      provisionerUuid,
      globalTtl,
      provisionerAddress,
      allocatedUnicastRanges,
      allocatedGroupRanges,
      allocatedSceneRanges,
      lastSelected,
    );
  }

// ignore: unused_element
  Provisioner fromJson(Map<String, Object> json) {
    return Provisioner.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Provisioner = _$ProvisionerTearOff();

/// @nodoc
mixin _$Provisioner {
  String get provisionerName;
  String get provisionerUuid;
  int get globalTtl;
  int get provisionerAddress;
  List<AllocatedUnicastRange> get allocatedUnicastRanges;
  List<AllocatedGroupRange> get allocatedGroupRanges;
  List<AllocatedSceneRange> get allocatedSceneRanges;
  bool get lastSelected;

  Map<String, dynamic> toJson();
  $ProvisionerCopyWith<Provisioner> get copyWith;
}

/// @nodoc
abstract class $ProvisionerCopyWith<$Res> {
  factory $ProvisionerCopyWith(Provisioner value, $Res Function(Provisioner) then) = _$ProvisionerCopyWithImpl<$Res>;

  $Res call(
      {String provisionerName,
      String provisionerUuid,
      int globalTtl,
      int provisionerAddress,
      List<AllocatedUnicastRange> allocatedUnicastRanges,
      List<AllocatedGroupRange> allocatedGroupRanges,
      List<AllocatedSceneRange> allocatedSceneRanges,
      bool lastSelected});
}

/// @nodoc
class _$ProvisionerCopyWithImpl<$Res> implements $ProvisionerCopyWith<$Res> {
  _$ProvisionerCopyWithImpl(this._value, this._then);

  final Provisioner _value;
  // ignore: unused_field
  final $Res Function(Provisioner) _then;

  @override
  $Res call({
    Object provisionerName = freezed,
    Object provisionerUuid = freezed,
    Object globalTtl = freezed,
    Object provisionerAddress = freezed,
    Object allocatedUnicastRanges = freezed,
    Object allocatedGroupRanges = freezed,
    Object allocatedSceneRanges = freezed,
    Object lastSelected = freezed,
  }) {
    return _then(_value.copyWith(
      provisionerName: provisionerName == freezed ? _value.provisionerName : provisionerName as String,
      provisionerUuid: provisionerUuid == freezed ? _value.provisionerUuid : provisionerUuid as String,
      globalTtl: globalTtl == freezed ? _value.globalTtl : globalTtl as int,
      provisionerAddress: provisionerAddress == freezed ? _value.provisionerAddress : provisionerAddress as int,
      allocatedUnicastRanges: allocatedUnicastRanges == freezed
          ? _value.allocatedUnicastRanges
          : allocatedUnicastRanges as List<AllocatedUnicastRange>,
      allocatedGroupRanges: allocatedGroupRanges == freezed
          ? _value.allocatedGroupRanges
          : allocatedGroupRanges as List<AllocatedGroupRange>,
      allocatedSceneRanges: allocatedSceneRanges == freezed
          ? _value.allocatedSceneRanges
          : allocatedSceneRanges as List<AllocatedSceneRange>,
      lastSelected: lastSelected == freezed ? _value.lastSelected : lastSelected as bool,
    ));
  }
}

/// @nodoc
abstract class _$ProvisionerCopyWith<$Res> implements $ProvisionerCopyWith<$Res> {
  factory _$ProvisionerCopyWith(_Provisioner value, $Res Function(_Provisioner) then) =
      __$ProvisionerCopyWithImpl<$Res>;

  @override
  $Res call(
      {String provisionerName,
      String provisionerUuid,
      int globalTtl,
      int provisionerAddress,
      List<AllocatedUnicastRange> allocatedUnicastRanges,
      List<AllocatedGroupRange> allocatedGroupRanges,
      List<AllocatedSceneRange> allocatedSceneRanges,
      bool lastSelected});
}

/// @nodoc
class __$ProvisionerCopyWithImpl<$Res> extends _$ProvisionerCopyWithImpl<$Res> implements _$ProvisionerCopyWith<$Res> {
  __$ProvisionerCopyWithImpl(_Provisioner _value, $Res Function(_Provisioner) _then)
      : super(_value, (v) => _then(v as _Provisioner));

  @override
  _Provisioner get _value => super._value as _Provisioner;

  @override
  $Res call({
    Object provisionerName = freezed,
    Object provisionerUuid = freezed,
    Object globalTtl = freezed,
    Object provisionerAddress = freezed,
    Object allocatedUnicastRanges = freezed,
    Object allocatedGroupRanges = freezed,
    Object allocatedSceneRanges = freezed,
    Object lastSelected = freezed,
  }) {
    return _then(_Provisioner(
      provisionerName == freezed ? _value.provisionerName : provisionerName as String,
      provisionerUuid == freezed ? _value.provisionerUuid : provisionerUuid as String,
      globalTtl == freezed ? _value.globalTtl : globalTtl as int,
      provisionerAddress == freezed ? _value.provisionerAddress : provisionerAddress as int,
      allocatedUnicastRanges == freezed
          ? _value.allocatedUnicastRanges
          : allocatedUnicastRanges as List<AllocatedUnicastRange>,
      allocatedGroupRanges == freezed ? _value.allocatedGroupRanges : allocatedGroupRanges as List<AllocatedGroupRange>,
      allocatedSceneRanges == freezed ? _value.allocatedSceneRanges : allocatedSceneRanges as List<AllocatedSceneRange>,
      lastSelected == freezed ? _value.lastSelected : lastSelected as bool,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Provisioner implements _Provisioner {
  const _$_Provisioner(this.provisionerName, this.provisionerUuid, this.globalTtl, this.provisionerAddress,
      this.allocatedUnicastRanges, this.allocatedGroupRanges, this.allocatedSceneRanges, this.lastSelected)
      : assert(provisionerName != null),
        assert(provisionerUuid != null),
        assert(globalTtl != null),
        assert(provisionerAddress != null),
        assert(allocatedUnicastRanges != null),
        assert(allocatedGroupRanges != null),
        assert(allocatedSceneRanges != null),
        assert(lastSelected != null);

  factory _$_Provisioner.fromJson(Map<String, dynamic> json) => _$_$_ProvisionerFromJson(json);

  @override
  final String provisionerName;
  @override
  final String provisionerUuid;
  @override
  final int globalTtl;
  @override
  final int provisionerAddress;
  @override
  final List<AllocatedUnicastRange> allocatedUnicastRanges;
  @override
  final List<AllocatedGroupRange> allocatedGroupRanges;
  @override
  final List<AllocatedSceneRange> allocatedSceneRanges;
  @override
  final bool lastSelected;

  @override
  String toString() {
    return 'Provisioner(provisionerName: $provisionerName, provisionerUuid: $provisionerUuid, globalTtl: $globalTtl, provisionerAddress: $provisionerAddress, allocatedUnicastRanges: $allocatedUnicastRanges, allocatedGroupRanges: $allocatedGroupRanges, allocatedSceneRanges: $allocatedSceneRanges, lastSelected: $lastSelected)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Provisioner &&
            (identical(other.provisionerName, provisionerName) ||
                const DeepCollectionEquality().equals(other.provisionerName, provisionerName)) &&
            (identical(other.provisionerUuid, provisionerUuid) ||
                const DeepCollectionEquality().equals(other.provisionerUuid, provisionerUuid)) &&
            (identical(other.globalTtl, globalTtl) ||
                const DeepCollectionEquality().equals(other.globalTtl, globalTtl)) &&
            (identical(other.provisionerAddress, provisionerAddress) ||
                const DeepCollectionEquality().equals(other.provisionerAddress, provisionerAddress)) &&
            (identical(other.allocatedUnicastRanges, allocatedUnicastRanges) ||
                const DeepCollectionEquality().equals(other.allocatedUnicastRanges, allocatedUnicastRanges)) &&
            (identical(other.allocatedGroupRanges, allocatedGroupRanges) ||
                const DeepCollectionEquality().equals(other.allocatedGroupRanges, allocatedGroupRanges)) &&
            (identical(other.allocatedSceneRanges, allocatedSceneRanges) ||
                const DeepCollectionEquality().equals(other.allocatedSceneRanges, allocatedSceneRanges)) &&
            (identical(other.lastSelected, lastSelected) ||
                const DeepCollectionEquality().equals(other.lastSelected, lastSelected)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(provisionerName) ^
      const DeepCollectionEquality().hash(provisionerUuid) ^
      const DeepCollectionEquality().hash(globalTtl) ^
      const DeepCollectionEquality().hash(provisionerAddress) ^
      const DeepCollectionEquality().hash(allocatedUnicastRanges) ^
      const DeepCollectionEquality().hash(allocatedGroupRanges) ^
      const DeepCollectionEquality().hash(allocatedSceneRanges) ^
      const DeepCollectionEquality().hash(lastSelected);

  @override
  _$ProvisionerCopyWith<_Provisioner> get copyWith => __$ProvisionerCopyWithImpl<_Provisioner>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ProvisionerToJson(this);
  }
}

abstract class _Provisioner implements Provisioner {
  const factory _Provisioner(
      String provisionerName,
      String provisionerUuid,
      int globalTtl,
      int provisionerAddress,
      List<AllocatedUnicastRange> allocatedUnicastRanges,
      List<AllocatedGroupRange> allocatedGroupRanges,
      List<AllocatedSceneRange> allocatedSceneRanges,
      bool lastSelected) = _$_Provisioner;

  factory _Provisioner.fromJson(Map<String, dynamic> json) = _$_Provisioner.fromJson;

  @override
  String get provisionerName;

  @override
  String get provisionerUuid;

  @override
  int get globalTtl;

  @override
  int get provisionerAddress;

  @override
  List<AllocatedUnicastRange> get allocatedUnicastRanges;
  @override
  List<AllocatedGroupRange> get allocatedGroupRanges;
  @override
  List<AllocatedSceneRange> get allocatedSceneRanges;
  @override
  bool get lastSelected;
  @override
  _$ProvisionerCopyWith<_Provisioner> get copyWith;
}
