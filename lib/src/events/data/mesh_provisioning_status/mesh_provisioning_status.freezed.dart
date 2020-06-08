// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'mesh_provisioning_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
MeshProvisioningStatusData _$MeshProvisioningStatusDataFromJson(
    Map<String, dynamic> json) {
  return _MeshProvisioningStatusData.fromJson(json);
}

class _$MeshProvisioningStatusDataTearOff {
  const _$MeshProvisioningStatusDataTearOff();

  _MeshProvisioningStatusData call(
      String state, List<int> data, String meshNodeUuid) {
    return _MeshProvisioningStatusData(
      state,
      data,
      meshNodeUuid,
    );
  }
}

// ignore: unused_element
const $MeshProvisioningStatusData = _$MeshProvisioningStatusDataTearOff();

mixin _$MeshProvisioningStatusData {
  String get state;
  List<int> get data;
  String get meshNodeUuid;

  Map<String, dynamic> toJson();
  $MeshProvisioningStatusDataCopyWith<MeshProvisioningStatusData> get copyWith;
}

abstract class $MeshProvisioningStatusDataCopyWith<$Res> {
  factory $MeshProvisioningStatusDataCopyWith(MeshProvisioningStatusData value,
          $Res Function(MeshProvisioningStatusData) then) =
      _$MeshProvisioningStatusDataCopyWithImpl<$Res>;
  $Res call({String state, List<int> data, String meshNodeUuid});
}

class _$MeshProvisioningStatusDataCopyWithImpl<$Res>
    implements $MeshProvisioningStatusDataCopyWith<$Res> {
  _$MeshProvisioningStatusDataCopyWithImpl(this._value, this._then);

  final MeshProvisioningStatusData _value;
  // ignore: unused_field
  final $Res Function(MeshProvisioningStatusData) _then;

  @override
  $Res call({
    Object state = freezed,
    Object data = freezed,
    Object meshNodeUuid = freezed,
  }) {
    return _then(_value.copyWith(
      state: state == freezed ? _value.state : state as String,
      data: data == freezed ? _value.data : data as List<int>,
      meshNodeUuid: meshNodeUuid == freezed
          ? _value.meshNodeUuid
          : meshNodeUuid as String,
    ));
  }
}

abstract class _$MeshProvisioningStatusDataCopyWith<$Res>
    implements $MeshProvisioningStatusDataCopyWith<$Res> {
  factory _$MeshProvisioningStatusDataCopyWith(
          _MeshProvisioningStatusData value,
          $Res Function(_MeshProvisioningStatusData) then) =
      __$MeshProvisioningStatusDataCopyWithImpl<$Res>;
  @override
  $Res call({String state, List<int> data, String meshNodeUuid});
}

class __$MeshProvisioningStatusDataCopyWithImpl<$Res>
    extends _$MeshProvisioningStatusDataCopyWithImpl<$Res>
    implements _$MeshProvisioningStatusDataCopyWith<$Res> {
  __$MeshProvisioningStatusDataCopyWithImpl(_MeshProvisioningStatusData _value,
      $Res Function(_MeshProvisioningStatusData) _then)
      : super(_value, (v) => _then(v as _MeshProvisioningStatusData));

  @override
  _MeshProvisioningStatusData get _value =>
      super._value as _MeshProvisioningStatusData;

  @override
  $Res call({
    Object state = freezed,
    Object data = freezed,
    Object meshNodeUuid = freezed,
  }) {
    return _then(_MeshProvisioningStatusData(
      state == freezed ? _value.state : state as String,
      data == freezed ? _value.data : data as List<int>,
      meshNodeUuid == freezed ? _value.meshNodeUuid : meshNodeUuid as String,
    ));
  }
}

@JsonSerializable()
class _$_MeshProvisioningStatusData implements _MeshProvisioningStatusData {
  const _$_MeshProvisioningStatusData(this.state, this.data, this.meshNodeUuid)
      : assert(state != null),
        assert(data != null),
        assert(meshNodeUuid != null);

  factory _$_MeshProvisioningStatusData.fromJson(Map<String, dynamic> json) =>
      _$_$_MeshProvisioningStatusDataFromJson(json);

  @override
  final String state;
  @override
  final List<int> data;
  @override
  final String meshNodeUuid;

  @override
  String toString() {
    return 'MeshProvisioningStatusData(state: $state, data: $data, meshNodeUuid: $meshNodeUuid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MeshProvisioningStatusData &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.meshNodeUuid, meshNodeUuid) ||
                const DeepCollectionEquality()
                    .equals(other.meshNodeUuid, meshNodeUuid)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(meshNodeUuid);

  @override
  _$MeshProvisioningStatusDataCopyWith<_MeshProvisioningStatusData>
      get copyWith => __$MeshProvisioningStatusDataCopyWithImpl<
          _MeshProvisioningStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MeshProvisioningStatusDataToJson(this);
  }
}

abstract class _MeshProvisioningStatusData
    implements MeshProvisioningStatusData {
  const factory _MeshProvisioningStatusData(
          String state, List<int> data, String meshNodeUuid) =
      _$_MeshProvisioningStatusData;

  factory _MeshProvisioningStatusData.fromJson(Map<String, dynamic> json) =
      _$_MeshProvisioningStatusData.fromJson;

  @override
  String get state;
  @override
  List<int> get data;
  @override
  String get meshNodeUuid;
  @override
  _$MeshProvisioningStatusDataCopyWith<_MeshProvisioningStatusData>
      get copyWith;
}
