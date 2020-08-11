// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'mesh_provisioning_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
UnprovisionedMeshNodeData _$UnprovisionedMeshNodeDataFromJson(
    Map<String, dynamic> json) {
  return _UnprovisionedMeshNodeData.fromJson(json);
}

class _$UnprovisionedMeshNodeDataTearOff {
  const _$UnprovisionedMeshNodeDataTearOff();

// ignore: unused_element
  _UnprovisionedMeshNodeData call(
      {@required String uuid,
      @nullable List<int> provisionerPublicKeyXY = const []}) {
    return _UnprovisionedMeshNodeData(
      uuid: uuid,
      provisionerPublicKeyXY: provisionerPublicKeyXY,
    );
  }
}

// ignore: unused_element
const $UnprovisionedMeshNodeData = _$UnprovisionedMeshNodeDataTearOff();

mixin _$UnprovisionedMeshNodeData {
  String get uuid;
  @nullable
  List<int> get provisionerPublicKeyXY;

  Map<String, dynamic> toJson();
  $UnprovisionedMeshNodeDataCopyWith<UnprovisionedMeshNodeData> get copyWith;
}

abstract class $UnprovisionedMeshNodeDataCopyWith<$Res> {
  factory $UnprovisionedMeshNodeDataCopyWith(UnprovisionedMeshNodeData value,
          $Res Function(UnprovisionedMeshNodeData) then) =
      _$UnprovisionedMeshNodeDataCopyWithImpl<$Res>;
  $Res call({String uuid, @nullable List<int> provisionerPublicKeyXY});
}

class _$UnprovisionedMeshNodeDataCopyWithImpl<$Res>
    implements $UnprovisionedMeshNodeDataCopyWith<$Res> {
  _$UnprovisionedMeshNodeDataCopyWithImpl(this._value, this._then);

  final UnprovisionedMeshNodeData _value;
  // ignore: unused_field
  final $Res Function(UnprovisionedMeshNodeData) _then;

  @override
  $Res call({
    Object uuid = freezed,
    Object provisionerPublicKeyXY = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: uuid == freezed ? _value.uuid : uuid as String,
      provisionerPublicKeyXY: provisionerPublicKeyXY == freezed
          ? _value.provisionerPublicKeyXY
          : provisionerPublicKeyXY as List<int>,
    ));
  }
}

abstract class _$UnprovisionedMeshNodeDataCopyWith<$Res>
    implements $UnprovisionedMeshNodeDataCopyWith<$Res> {
  factory _$UnprovisionedMeshNodeDataCopyWith(_UnprovisionedMeshNodeData value,
          $Res Function(_UnprovisionedMeshNodeData) then) =
      __$UnprovisionedMeshNodeDataCopyWithImpl<$Res>;
  @override
  $Res call({String uuid, @nullable List<int> provisionerPublicKeyXY});
}

class __$UnprovisionedMeshNodeDataCopyWithImpl<$Res>
    extends _$UnprovisionedMeshNodeDataCopyWithImpl<$Res>
    implements _$UnprovisionedMeshNodeDataCopyWith<$Res> {
  __$UnprovisionedMeshNodeDataCopyWithImpl(_UnprovisionedMeshNodeData _value,
      $Res Function(_UnprovisionedMeshNodeData) _then)
      : super(_value, (v) => _then(v as _UnprovisionedMeshNodeData));

  @override
  _UnprovisionedMeshNodeData get _value =>
      super._value as _UnprovisionedMeshNodeData;

  @override
  $Res call({
    Object uuid = freezed,
    Object provisionerPublicKeyXY = freezed,
  }) {
    return _then(_UnprovisionedMeshNodeData(
      uuid: uuid == freezed ? _value.uuid : uuid as String,
      provisionerPublicKeyXY: provisionerPublicKeyXY == freezed
          ? _value.provisionerPublicKeyXY
          : provisionerPublicKeyXY as List<int>,
    ));
  }
}

@JsonSerializable()
class _$_UnprovisionedMeshNodeData implements _UnprovisionedMeshNodeData {
  const _$_UnprovisionedMeshNodeData(
      {@required this.uuid, @nullable this.provisionerPublicKeyXY = const []})
      : assert(uuid != null);

  factory _$_UnprovisionedMeshNodeData.fromJson(Map<String, dynamic> json) =>
      _$_$_UnprovisionedMeshNodeDataFromJson(json);

  @override
  final String uuid;
  @JsonKey(defaultValue: const [])
  @override
  @nullable
  final List<int> provisionerPublicKeyXY;

  @override
  String toString() {
    return 'UnprovisionedMeshNodeData(uuid: $uuid, provisionerPublicKeyXY: $provisionerPublicKeyXY)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UnprovisionedMeshNodeData &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.provisionerPublicKeyXY, provisionerPublicKeyXY) ||
                const DeepCollectionEquality().equals(
                    other.provisionerPublicKeyXY, provisionerPublicKeyXY)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(provisionerPublicKeyXY);

  @override
  _$UnprovisionedMeshNodeDataCopyWith<_UnprovisionedMeshNodeData>
      get copyWith =>
          __$UnprovisionedMeshNodeDataCopyWithImpl<_UnprovisionedMeshNodeData>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UnprovisionedMeshNodeDataToJson(this);
  }
}

abstract class _UnprovisionedMeshNodeData implements UnprovisionedMeshNodeData {
  const factory _UnprovisionedMeshNodeData(
          {@required String uuid, @nullable List<int> provisionerPublicKeyXY}) =
      _$_UnprovisionedMeshNodeData;

  factory _UnprovisionedMeshNodeData.fromJson(Map<String, dynamic> json) =
      _$_UnprovisionedMeshNodeData.fromJson;

  @override
  String get uuid;
  @override
  @nullable
  List<int> get provisionerPublicKeyXY;
  @override
  _$UnprovisionedMeshNodeDataCopyWith<_UnprovisionedMeshNodeData> get copyWith;
}

ProvisionedMeshNodeData _$ProvisionedMeshNodeDataFromJson(
    Map<String, dynamic> json) {
  return _ProvisionedMeshNodeData.fromJson(json);
}

class _$ProvisionedMeshNodeDataTearOff {
  const _$ProvisionedMeshNodeDataTearOff();

// ignore: unused_element
  _ProvisionedMeshNodeData call({@required String uuid}) {
    return _ProvisionedMeshNodeData(
      uuid: uuid,
    );
  }
}

// ignore: unused_element
const $ProvisionedMeshNodeData = _$ProvisionedMeshNodeDataTearOff();

mixin _$ProvisionedMeshNodeData {
  String get uuid;

  Map<String, dynamic> toJson();
  $ProvisionedMeshNodeDataCopyWith<ProvisionedMeshNodeData> get copyWith;
}

abstract class $ProvisionedMeshNodeDataCopyWith<$Res> {
  factory $ProvisionedMeshNodeDataCopyWith(ProvisionedMeshNodeData value,
          $Res Function(ProvisionedMeshNodeData) then) =
      _$ProvisionedMeshNodeDataCopyWithImpl<$Res>;
  $Res call({String uuid});
}

class _$ProvisionedMeshNodeDataCopyWithImpl<$Res>
    implements $ProvisionedMeshNodeDataCopyWith<$Res> {
  _$ProvisionedMeshNodeDataCopyWithImpl(this._value, this._then);

  final ProvisionedMeshNodeData _value;
  // ignore: unused_field
  final $Res Function(ProvisionedMeshNodeData) _then;

  @override
  $Res call({
    Object uuid = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: uuid == freezed ? _value.uuid : uuid as String,
    ));
  }
}

abstract class _$ProvisionedMeshNodeDataCopyWith<$Res>
    implements $ProvisionedMeshNodeDataCopyWith<$Res> {
  factory _$ProvisionedMeshNodeDataCopyWith(_ProvisionedMeshNodeData value,
          $Res Function(_ProvisionedMeshNodeData) then) =
      __$ProvisionedMeshNodeDataCopyWithImpl<$Res>;
  @override
  $Res call({String uuid});
}

class __$ProvisionedMeshNodeDataCopyWithImpl<$Res>
    extends _$ProvisionedMeshNodeDataCopyWithImpl<$Res>
    implements _$ProvisionedMeshNodeDataCopyWith<$Res> {
  __$ProvisionedMeshNodeDataCopyWithImpl(_ProvisionedMeshNodeData _value,
      $Res Function(_ProvisionedMeshNodeData) _then)
      : super(_value, (v) => _then(v as _ProvisionedMeshNodeData));

  @override
  _ProvisionedMeshNodeData get _value =>
      super._value as _ProvisionedMeshNodeData;

  @override
  $Res call({
    Object uuid = freezed,
  }) {
    return _then(_ProvisionedMeshNodeData(
      uuid: uuid == freezed ? _value.uuid : uuid as String,
    ));
  }
}

@JsonSerializable()
class _$_ProvisionedMeshNodeData implements _ProvisionedMeshNodeData {
  const _$_ProvisionedMeshNodeData({@required this.uuid})
      : assert(uuid != null);

  factory _$_ProvisionedMeshNodeData.fromJson(Map<String, dynamic> json) =>
      _$_$_ProvisionedMeshNodeDataFromJson(json);

  @override
  final String uuid;

  @override
  String toString() {
    return 'ProvisionedMeshNodeData(uuid: $uuid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ProvisionedMeshNodeData &&
            (identical(other.uuid, uuid) ||
                const DeepCollectionEquality().equals(other.uuid, uuid)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(uuid);

  @override
  _$ProvisionedMeshNodeDataCopyWith<_ProvisionedMeshNodeData> get copyWith =>
      __$ProvisionedMeshNodeDataCopyWithImpl<_ProvisionedMeshNodeData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ProvisionedMeshNodeDataToJson(this);
  }
}

abstract class _ProvisionedMeshNodeData implements ProvisionedMeshNodeData {
  const factory _ProvisionedMeshNodeData({@required String uuid}) =
      _$_ProvisionedMeshNodeData;

  factory _ProvisionedMeshNodeData.fromJson(Map<String, dynamic> json) =
      _$_ProvisionedMeshNodeData.fromJson;

  @override
  String get uuid;
  @override
  _$ProvisionedMeshNodeDataCopyWith<_ProvisionedMeshNodeData> get copyWith;
}

MeshProvisioningStatusData _$MeshProvisioningStatusDataFromJson(
    Map<String, dynamic> json) {
  return _MeshProvisioningStatusData.fromJson(json);
}

class _$MeshProvisioningStatusDataTearOff {
  const _$MeshProvisioningStatusDataTearOff();

// ignore: unused_element
  _MeshProvisioningStatusData call(String state, List<int> data,
      @nullable UnprovisionedMeshNodeData meshNode) {
    return _MeshProvisioningStatusData(
      state,
      data,
      meshNode,
    );
  }
}

// ignore: unused_element
const $MeshProvisioningStatusData = _$MeshProvisioningStatusDataTearOff();

mixin _$MeshProvisioningStatusData {
  String get state;
  List<int> get data;
  @nullable
  UnprovisionedMeshNodeData get meshNode;

  Map<String, dynamic> toJson();
  $MeshProvisioningStatusDataCopyWith<MeshProvisioningStatusData> get copyWith;
}

abstract class $MeshProvisioningStatusDataCopyWith<$Res> {
  factory $MeshProvisioningStatusDataCopyWith(MeshProvisioningStatusData value,
          $Res Function(MeshProvisioningStatusData) then) =
      _$MeshProvisioningStatusDataCopyWithImpl<$Res>;
  $Res call(
      {String state,
      List<int> data,
      @nullable UnprovisionedMeshNodeData meshNode});

  $UnprovisionedMeshNodeDataCopyWith<$Res> get meshNode;
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
    Object meshNode = freezed,
  }) {
    return _then(_value.copyWith(
      state: state == freezed ? _value.state : state as String,
      data: data == freezed ? _value.data : data as List<int>,
      meshNode: meshNode == freezed
          ? _value.meshNode
          : meshNode as UnprovisionedMeshNodeData,
    ));
  }

  @override
  $UnprovisionedMeshNodeDataCopyWith<$Res> get meshNode {
    if (_value.meshNode == null) {
      return null;
    }
    return $UnprovisionedMeshNodeDataCopyWith<$Res>(_value.meshNode, (value) {
      return _then(_value.copyWith(meshNode: value));
    });
  }
}

abstract class _$MeshProvisioningStatusDataCopyWith<$Res>
    implements $MeshProvisioningStatusDataCopyWith<$Res> {
  factory _$MeshProvisioningStatusDataCopyWith(
          _MeshProvisioningStatusData value,
          $Res Function(_MeshProvisioningStatusData) then) =
      __$MeshProvisioningStatusDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String state,
      List<int> data,
      @nullable UnprovisionedMeshNodeData meshNode});

  @override
  $UnprovisionedMeshNodeDataCopyWith<$Res> get meshNode;
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
    Object meshNode = freezed,
  }) {
    return _then(_MeshProvisioningStatusData(
      state == freezed ? _value.state : state as String,
      data == freezed ? _value.data : data as List<int>,
      meshNode == freezed
          ? _value.meshNode
          : meshNode as UnprovisionedMeshNodeData,
    ));
  }
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$_MeshProvisioningStatusData implements _MeshProvisioningStatusData {
  const _$_MeshProvisioningStatusData(
      this.state, this.data, @nullable this.meshNode)
      : assert(state != null),
        assert(data != null);

  factory _$_MeshProvisioningStatusData.fromJson(Map<String, dynamic> json) =>
      _$_$_MeshProvisioningStatusDataFromJson(json);

  @override
  final String state;
  @override
  final List<int> data;
  @override
  @nullable
  final UnprovisionedMeshNodeData meshNode;

  @override
  String toString() {
    return 'MeshProvisioningStatusData(state: $state, data: $data, meshNode: $meshNode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MeshProvisioningStatusData &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.meshNode, meshNode) ||
                const DeepCollectionEquality()
                    .equals(other.meshNode, meshNode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(meshNode);

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
  const factory _MeshProvisioningStatusData(String state, List<int> data,
          @nullable UnprovisionedMeshNodeData meshNode) =
      _$_MeshProvisioningStatusData;

  factory _MeshProvisioningStatusData.fromJson(Map<String, dynamic> json) =
      _$_MeshProvisioningStatusData.fromJson;

  @override
  String get state;
  @override
  List<int> get data;
  @override
  @nullable
  UnprovisionedMeshNodeData get meshNode;
  @override
  _$MeshProvisioningStatusDataCopyWith<_MeshProvisioningStatusData>
      get copyWith;
}

MeshProvisioningCompletedData _$MeshProvisioningCompletedDataFromJson(
    Map<String, dynamic> json) {
  return _MeshProvisioningCompletedData.fromJson(json);
}

class _$MeshProvisioningCompletedDataTearOff {
  const _$MeshProvisioningCompletedDataTearOff();

// ignore: unused_element
  _MeshProvisioningCompletedData call(String state, List<int> data,
      @nullable ProvisionedMeshNodeData meshNode) {
    return _MeshProvisioningCompletedData(
      state,
      data,
      meshNode,
    );
  }
}

// ignore: unused_element
const $MeshProvisioningCompletedData = _$MeshProvisioningCompletedDataTearOff();

mixin _$MeshProvisioningCompletedData {
  String get state;
  List<int> get data;
  @nullable
  ProvisionedMeshNodeData get meshNode;

  Map<String, dynamic> toJson();
  $MeshProvisioningCompletedDataCopyWith<MeshProvisioningCompletedData>
      get copyWith;
}

abstract class $MeshProvisioningCompletedDataCopyWith<$Res> {
  factory $MeshProvisioningCompletedDataCopyWith(
          MeshProvisioningCompletedData value,
          $Res Function(MeshProvisioningCompletedData) then) =
      _$MeshProvisioningCompletedDataCopyWithImpl<$Res>;
  $Res call(
      {String state,
      List<int> data,
      @nullable ProvisionedMeshNodeData meshNode});

  $ProvisionedMeshNodeDataCopyWith<$Res> get meshNode;
}

class _$MeshProvisioningCompletedDataCopyWithImpl<$Res>
    implements $MeshProvisioningCompletedDataCopyWith<$Res> {
  _$MeshProvisioningCompletedDataCopyWithImpl(this._value, this._then);

  final MeshProvisioningCompletedData _value;
  // ignore: unused_field
  final $Res Function(MeshProvisioningCompletedData) _then;

  @override
  $Res call({
    Object state = freezed,
    Object data = freezed,
    Object meshNode = freezed,
  }) {
    return _then(_value.copyWith(
      state: state == freezed ? _value.state : state as String,
      data: data == freezed ? _value.data : data as List<int>,
      meshNode: meshNode == freezed
          ? _value.meshNode
          : meshNode as ProvisionedMeshNodeData,
    ));
  }

  @override
  $ProvisionedMeshNodeDataCopyWith<$Res> get meshNode {
    if (_value.meshNode == null) {
      return null;
    }
    return $ProvisionedMeshNodeDataCopyWith<$Res>(_value.meshNode, (value) {
      return _then(_value.copyWith(meshNode: value));
    });
  }
}

abstract class _$MeshProvisioningCompletedDataCopyWith<$Res>
    implements $MeshProvisioningCompletedDataCopyWith<$Res> {
  factory _$MeshProvisioningCompletedDataCopyWith(
          _MeshProvisioningCompletedData value,
          $Res Function(_MeshProvisioningCompletedData) then) =
      __$MeshProvisioningCompletedDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String state,
      List<int> data,
      @nullable ProvisionedMeshNodeData meshNode});

  @override
  $ProvisionedMeshNodeDataCopyWith<$Res> get meshNode;
}

class __$MeshProvisioningCompletedDataCopyWithImpl<$Res>
    extends _$MeshProvisioningCompletedDataCopyWithImpl<$Res>
    implements _$MeshProvisioningCompletedDataCopyWith<$Res> {
  __$MeshProvisioningCompletedDataCopyWithImpl(
      _MeshProvisioningCompletedData _value,
      $Res Function(_MeshProvisioningCompletedData) _then)
      : super(_value, (v) => _then(v as _MeshProvisioningCompletedData));

  @override
  _MeshProvisioningCompletedData get _value =>
      super._value as _MeshProvisioningCompletedData;

  @override
  $Res call({
    Object state = freezed,
    Object data = freezed,
    Object meshNode = freezed,
  }) {
    return _then(_MeshProvisioningCompletedData(
      state == freezed ? _value.state : state as String,
      data == freezed ? _value.data : data as List<int>,
      meshNode == freezed
          ? _value.meshNode
          : meshNode as ProvisionedMeshNodeData,
    ));
  }
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$_MeshProvisioningCompletedData
    implements _MeshProvisioningCompletedData {
  const _$_MeshProvisioningCompletedData(
      this.state, this.data, @nullable this.meshNode)
      : assert(state != null),
        assert(data != null);

  factory _$_MeshProvisioningCompletedData.fromJson(
          Map<String, dynamic> json) =>
      _$_$_MeshProvisioningCompletedDataFromJson(json);

  @override
  final String state;
  @override
  final List<int> data;
  @override
  @nullable
  final ProvisionedMeshNodeData meshNode;

  @override
  String toString() {
    return 'MeshProvisioningCompletedData(state: $state, data: $data, meshNode: $meshNode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MeshProvisioningCompletedData &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.meshNode, meshNode) ||
                const DeepCollectionEquality()
                    .equals(other.meshNode, meshNode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(meshNode);

  @override
  _$MeshProvisioningCompletedDataCopyWith<_MeshProvisioningCompletedData>
      get copyWith => __$MeshProvisioningCompletedDataCopyWithImpl<
          _MeshProvisioningCompletedData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MeshProvisioningCompletedDataToJson(this);
  }
}

abstract class _MeshProvisioningCompletedData
    implements MeshProvisioningCompletedData {
  const factory _MeshProvisioningCompletedData(String state, List<int> data,
          @nullable ProvisionedMeshNodeData meshNode) =
      _$_MeshProvisioningCompletedData;

  factory _MeshProvisioningCompletedData.fromJson(Map<String, dynamic> json) =
      _$_MeshProvisioningCompletedData.fromJson;

  @override
  String get state;
  @override
  List<int> get data;
  @override
  @nullable
  ProvisionedMeshNodeData get meshNode;
  @override
  _$MeshProvisioningCompletedDataCopyWith<_MeshProvisioningCompletedData>
      get copyWith;
}
