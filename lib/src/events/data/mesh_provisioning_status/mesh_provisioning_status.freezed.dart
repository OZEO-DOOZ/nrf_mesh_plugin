// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'mesh_provisioning_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UnprovisionedMeshNodeData _$UnprovisionedMeshNodeDataFromJson(Map<String, dynamic> json) {
  return _UnprovisionedMeshNodeData.fromJson(json);
}

/// @nodoc
class _$UnprovisionedMeshNodeDataTearOff {
  const _$UnprovisionedMeshNodeDataTearOff();

  _UnprovisionedMeshNodeData call(String uuid, {List<int>? provisionerPublicKeyXY = const []}) {
    return _UnprovisionedMeshNodeData(
      uuid,
      provisionerPublicKeyXY: provisionerPublicKeyXY,
    );
  }

  UnprovisionedMeshNodeData fromJson(Map<String, Object> json) {
    return UnprovisionedMeshNodeData.fromJson(json);
  }
}

/// @nodoc
const $UnprovisionedMeshNodeData = _$UnprovisionedMeshNodeDataTearOff();

/// @nodoc
mixin _$UnprovisionedMeshNodeData {
  String get uuid => throw _privateConstructorUsedError;
  List<int>? get provisionerPublicKeyXY => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnprovisionedMeshNodeDataCopyWith<UnprovisionedMeshNodeData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnprovisionedMeshNodeDataCopyWith<$Res> {
  factory $UnprovisionedMeshNodeDataCopyWith(
          UnprovisionedMeshNodeData value, $Res Function(UnprovisionedMeshNodeData) then) =
      _$UnprovisionedMeshNodeDataCopyWithImpl<$Res>;
  $Res call({String uuid, List<int>? provisionerPublicKeyXY});
}

/// @nodoc
class _$UnprovisionedMeshNodeDataCopyWithImpl<$Res> implements $UnprovisionedMeshNodeDataCopyWith<$Res> {
  _$UnprovisionedMeshNodeDataCopyWithImpl(this._value, this._then);

  final UnprovisionedMeshNodeData _value;
  // ignore: unused_field
  final $Res Function(UnprovisionedMeshNodeData) _then;

  @override
  $Res call({
    Object? uuid = freezed,
    Object? provisionerPublicKeyXY = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: uuid == freezed
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      provisionerPublicKeyXY: provisionerPublicKeyXY == freezed
          ? _value.provisionerPublicKeyXY
          : provisionerPublicKeyXY // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc
abstract class _$UnprovisionedMeshNodeDataCopyWith<$Res> implements $UnprovisionedMeshNodeDataCopyWith<$Res> {
  factory _$UnprovisionedMeshNodeDataCopyWith(
          _UnprovisionedMeshNodeData value, $Res Function(_UnprovisionedMeshNodeData) then) =
      __$UnprovisionedMeshNodeDataCopyWithImpl<$Res>;
  @override
  $Res call({String uuid, List<int>? provisionerPublicKeyXY});
}

/// @nodoc
class __$UnprovisionedMeshNodeDataCopyWithImpl<$Res> extends _$UnprovisionedMeshNodeDataCopyWithImpl<$Res>
    implements _$UnprovisionedMeshNodeDataCopyWith<$Res> {
  __$UnprovisionedMeshNodeDataCopyWithImpl(
      _UnprovisionedMeshNodeData _value, $Res Function(_UnprovisionedMeshNodeData) _then)
      : super(_value, (v) => _then(v as _UnprovisionedMeshNodeData));

  @override
  _UnprovisionedMeshNodeData get _value => super._value as _UnprovisionedMeshNodeData;

  @override
  $Res call({
    Object? uuid = freezed,
    Object? provisionerPublicKeyXY = freezed,
  }) {
    return _then(_UnprovisionedMeshNodeData(
      uuid == freezed
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      provisionerPublicKeyXY: provisionerPublicKeyXY == freezed
          ? _value.provisionerPublicKeyXY
          : provisionerPublicKeyXY // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UnprovisionedMeshNodeData implements _UnprovisionedMeshNodeData {
  const _$_UnprovisionedMeshNodeData(this.uuid, {this.provisionerPublicKeyXY = const []});

  factory _$_UnprovisionedMeshNodeData.fromJson(Map<String, dynamic> json) =>
      _$_$_UnprovisionedMeshNodeDataFromJson(json);

  @override
  final String uuid;
  @JsonKey(defaultValue: const [])
  @override
  final List<int>? provisionerPublicKeyXY;

  @override
  String toString() {
    return 'UnprovisionedMeshNodeData(uuid: $uuid, provisionerPublicKeyXY: $provisionerPublicKeyXY)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UnprovisionedMeshNodeData &&
            (identical(other.uuid, uuid) || const DeepCollectionEquality().equals(other.uuid, uuid)) &&
            (identical(other.provisionerPublicKeyXY, provisionerPublicKeyXY) ||
                const DeepCollectionEquality().equals(other.provisionerPublicKeyXY, provisionerPublicKeyXY)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(uuid) ^
      const DeepCollectionEquality().hash(provisionerPublicKeyXY);

  @JsonKey(ignore: true)
  @override
  _$UnprovisionedMeshNodeDataCopyWith<_UnprovisionedMeshNodeData> get copyWith =>
      __$UnprovisionedMeshNodeDataCopyWithImpl<_UnprovisionedMeshNodeData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UnprovisionedMeshNodeDataToJson(this);
  }
}

abstract class _UnprovisionedMeshNodeData implements UnprovisionedMeshNodeData {
  const factory _UnprovisionedMeshNodeData(String uuid, {List<int>? provisionerPublicKeyXY}) =
      _$_UnprovisionedMeshNodeData;

  factory _UnprovisionedMeshNodeData.fromJson(Map<String, dynamic> json) = _$_UnprovisionedMeshNodeData.fromJson;

  @override
  String get uuid => throw _privateConstructorUsedError;
  @override
  List<int>? get provisionerPublicKeyXY => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UnprovisionedMeshNodeDataCopyWith<_UnprovisionedMeshNodeData> get copyWith => throw _privateConstructorUsedError;
}

ProvisionedMeshNodeData _$ProvisionedMeshNodeDataFromJson(Map<String, dynamic> json) {
  return _ProvisionedMeshNodeData.fromJson(json);
}

/// @nodoc
class _$ProvisionedMeshNodeDataTearOff {
  const _$ProvisionedMeshNodeDataTearOff();

  _ProvisionedMeshNodeData call(String uuid) {
    return _ProvisionedMeshNodeData(
      uuid,
    );
  }

  ProvisionedMeshNodeData fromJson(Map<String, Object> json) {
    return ProvisionedMeshNodeData.fromJson(json);
  }
}

/// @nodoc
const $ProvisionedMeshNodeData = _$ProvisionedMeshNodeDataTearOff();

/// @nodoc
mixin _$ProvisionedMeshNodeData {
  String get uuid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProvisionedMeshNodeDataCopyWith<ProvisionedMeshNodeData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProvisionedMeshNodeDataCopyWith<$Res> {
  factory $ProvisionedMeshNodeDataCopyWith(ProvisionedMeshNodeData value, $Res Function(ProvisionedMeshNodeData) then) =
      _$ProvisionedMeshNodeDataCopyWithImpl<$Res>;
  $Res call({String uuid});
}

/// @nodoc
class _$ProvisionedMeshNodeDataCopyWithImpl<$Res> implements $ProvisionedMeshNodeDataCopyWith<$Res> {
  _$ProvisionedMeshNodeDataCopyWithImpl(this._value, this._then);

  final ProvisionedMeshNodeData _value;
  // ignore: unused_field
  final $Res Function(ProvisionedMeshNodeData) _then;

  @override
  $Res call({
    Object? uuid = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: uuid == freezed
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$ProvisionedMeshNodeDataCopyWith<$Res> implements $ProvisionedMeshNodeDataCopyWith<$Res> {
  factory _$ProvisionedMeshNodeDataCopyWith(
          _ProvisionedMeshNodeData value, $Res Function(_ProvisionedMeshNodeData) then) =
      __$ProvisionedMeshNodeDataCopyWithImpl<$Res>;
  @override
  $Res call({String uuid});
}

/// @nodoc
class __$ProvisionedMeshNodeDataCopyWithImpl<$Res> extends _$ProvisionedMeshNodeDataCopyWithImpl<$Res>
    implements _$ProvisionedMeshNodeDataCopyWith<$Res> {
  __$ProvisionedMeshNodeDataCopyWithImpl(_ProvisionedMeshNodeData _value, $Res Function(_ProvisionedMeshNodeData) _then)
      : super(_value, (v) => _then(v as _ProvisionedMeshNodeData));

  @override
  _ProvisionedMeshNodeData get _value => super._value as _ProvisionedMeshNodeData;

  @override
  $Res call({
    Object? uuid = freezed,
  }) {
    return _then(_ProvisionedMeshNodeData(
      uuid == freezed
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ProvisionedMeshNodeData implements _ProvisionedMeshNodeData {
  const _$_ProvisionedMeshNodeData(this.uuid);

  factory _$_ProvisionedMeshNodeData.fromJson(Map<String, dynamic> json) => _$_$_ProvisionedMeshNodeDataFromJson(json);

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
            (identical(other.uuid, uuid) || const DeepCollectionEquality().equals(other.uuid, uuid)));
  }

  @override
  int get hashCode => runtimeType.hashCode ^ const DeepCollectionEquality().hash(uuid);

  @JsonKey(ignore: true)
  @override
  _$ProvisionedMeshNodeDataCopyWith<_ProvisionedMeshNodeData> get copyWith =>
      __$ProvisionedMeshNodeDataCopyWithImpl<_ProvisionedMeshNodeData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ProvisionedMeshNodeDataToJson(this);
  }
}

abstract class _ProvisionedMeshNodeData implements ProvisionedMeshNodeData {
  const factory _ProvisionedMeshNodeData(String uuid) = _$_ProvisionedMeshNodeData;

  factory _ProvisionedMeshNodeData.fromJson(Map<String, dynamic> json) = _$_ProvisionedMeshNodeData.fromJson;

  @override
  String get uuid => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ProvisionedMeshNodeDataCopyWith<_ProvisionedMeshNodeData> get copyWith => throw _privateConstructorUsedError;
}

MeshProvisioningStatusData _$MeshProvisioningStatusDataFromJson(Map<String, dynamic> json) {
  return _MeshProvisioningStatusData.fromJson(json);
}

/// @nodoc
class _$MeshProvisioningStatusDataTearOff {
  const _$MeshProvisioningStatusDataTearOff();

  _MeshProvisioningStatusData call(String state, List<int> data, UnprovisionedMeshNodeData? meshNode) {
    return _MeshProvisioningStatusData(
      state,
      data,
      meshNode,
    );
  }

  MeshProvisioningStatusData fromJson(Map<String, Object> json) {
    return MeshProvisioningStatusData.fromJson(json);
  }
}

/// @nodoc
const $MeshProvisioningStatusData = _$MeshProvisioningStatusDataTearOff();

/// @nodoc
mixin _$MeshProvisioningStatusData {
  String get state => throw _privateConstructorUsedError;
  List<int> get data => throw _privateConstructorUsedError;
  UnprovisionedMeshNodeData? get meshNode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeshProvisioningStatusDataCopyWith<MeshProvisioningStatusData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeshProvisioningStatusDataCopyWith<$Res> {
  factory $MeshProvisioningStatusDataCopyWith(
          MeshProvisioningStatusData value, $Res Function(MeshProvisioningStatusData) then) =
      _$MeshProvisioningStatusDataCopyWithImpl<$Res>;
  $Res call({String state, List<int> data, UnprovisionedMeshNodeData? meshNode});

  $UnprovisionedMeshNodeDataCopyWith<$Res>? get meshNode;
}

/// @nodoc
class _$MeshProvisioningStatusDataCopyWithImpl<$Res> implements $MeshProvisioningStatusDataCopyWith<$Res> {
  _$MeshProvisioningStatusDataCopyWithImpl(this._value, this._then);

  final MeshProvisioningStatusData _value;
  // ignore: unused_field
  final $Res Function(MeshProvisioningStatusData) _then;

  @override
  $Res call({
    Object? state = freezed,
    Object? data = freezed,
    Object? meshNode = freezed,
  }) {
    return _then(_value.copyWith(
      state: state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<int>,
      meshNode: meshNode == freezed
          ? _value.meshNode
          : meshNode // ignore: cast_nullable_to_non_nullable
              as UnprovisionedMeshNodeData?,
    ));
  }

  @override
  $UnprovisionedMeshNodeDataCopyWith<$Res>? get meshNode {
    if (_value.meshNode == null) {
      return null;
    }

    return $UnprovisionedMeshNodeDataCopyWith<$Res>(_value.meshNode!, (value) {
      return _then(_value.copyWith(meshNode: value));
    });
  }
}

/// @nodoc
abstract class _$MeshProvisioningStatusDataCopyWith<$Res> implements $MeshProvisioningStatusDataCopyWith<$Res> {
  factory _$MeshProvisioningStatusDataCopyWith(
          _MeshProvisioningStatusData value, $Res Function(_MeshProvisioningStatusData) then) =
      __$MeshProvisioningStatusDataCopyWithImpl<$Res>;
  @override
  $Res call({String state, List<int> data, UnprovisionedMeshNodeData? meshNode});

  @override
  $UnprovisionedMeshNodeDataCopyWith<$Res>? get meshNode;
}

/// @nodoc
class __$MeshProvisioningStatusDataCopyWithImpl<$Res> extends _$MeshProvisioningStatusDataCopyWithImpl<$Res>
    implements _$MeshProvisioningStatusDataCopyWith<$Res> {
  __$MeshProvisioningStatusDataCopyWithImpl(
      _MeshProvisioningStatusData _value, $Res Function(_MeshProvisioningStatusData) _then)
      : super(_value, (v) => _then(v as _MeshProvisioningStatusData));

  @override
  _MeshProvisioningStatusData get _value => super._value as _MeshProvisioningStatusData;

  @override
  $Res call({
    Object? state = freezed,
    Object? data = freezed,
    Object? meshNode = freezed,
  }) {
    return _then(_MeshProvisioningStatusData(
      state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<int>,
      meshNode == freezed
          ? _value.meshNode
          : meshNode // ignore: cast_nullable_to_non_nullable
              as UnprovisionedMeshNodeData?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$_MeshProvisioningStatusData implements _MeshProvisioningStatusData {
  const _$_MeshProvisioningStatusData(this.state, this.data, this.meshNode);

  factory _$_MeshProvisioningStatusData.fromJson(Map<String, dynamic> json) =>
      _$_$_MeshProvisioningStatusDataFromJson(json);

  @override
  final String state;
  @override
  final List<int> data;
  @override
  final UnprovisionedMeshNodeData? meshNode;

  @override
  String toString() {
    return 'MeshProvisioningStatusData(state: $state, data: $data, meshNode: $meshNode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MeshProvisioningStatusData &&
            (identical(other.state, state) || const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.data, data) || const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.meshNode, meshNode) || const DeepCollectionEquality().equals(other.meshNode, meshNode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(meshNode);

  @JsonKey(ignore: true)
  @override
  _$MeshProvisioningStatusDataCopyWith<_MeshProvisioningStatusData> get copyWith =>
      __$MeshProvisioningStatusDataCopyWithImpl<_MeshProvisioningStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MeshProvisioningStatusDataToJson(this);
  }
}

abstract class _MeshProvisioningStatusData implements MeshProvisioningStatusData {
  const factory _MeshProvisioningStatusData(String state, List<int> data, UnprovisionedMeshNodeData? meshNode) =
      _$_MeshProvisioningStatusData;

  factory _MeshProvisioningStatusData.fromJson(Map<String, dynamic> json) = _$_MeshProvisioningStatusData.fromJson;

  @override
  String get state => throw _privateConstructorUsedError;
  @override
  List<int> get data => throw _privateConstructorUsedError;
  @override
  UnprovisionedMeshNodeData? get meshNode => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MeshProvisioningStatusDataCopyWith<_MeshProvisioningStatusData> get copyWith => throw _privateConstructorUsedError;
}

MeshProvisioningCompletedData _$MeshProvisioningCompletedDataFromJson(Map<String, dynamic> json) {
  return _MeshProvisioningCompletedData.fromJson(json);
}

/// @nodoc
class _$MeshProvisioningCompletedDataTearOff {
  const _$MeshProvisioningCompletedDataTearOff();

  _MeshProvisioningCompletedData call(String state, List<int> data, ProvisionedMeshNodeData? meshNode) {
    return _MeshProvisioningCompletedData(
      state,
      data,
      meshNode,
    );
  }

  MeshProvisioningCompletedData fromJson(Map<String, Object> json) {
    return MeshProvisioningCompletedData.fromJson(json);
  }
}

/// @nodoc
const $MeshProvisioningCompletedData = _$MeshProvisioningCompletedDataTearOff();

/// @nodoc
mixin _$MeshProvisioningCompletedData {
  String get state => throw _privateConstructorUsedError;
  List<int> get data => throw _privateConstructorUsedError;
  ProvisionedMeshNodeData? get meshNode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeshProvisioningCompletedDataCopyWith<MeshProvisioningCompletedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeshProvisioningCompletedDataCopyWith<$Res> {
  factory $MeshProvisioningCompletedDataCopyWith(
          MeshProvisioningCompletedData value, $Res Function(MeshProvisioningCompletedData) then) =
      _$MeshProvisioningCompletedDataCopyWithImpl<$Res>;
  $Res call({String state, List<int> data, ProvisionedMeshNodeData? meshNode});

  $ProvisionedMeshNodeDataCopyWith<$Res>? get meshNode;
}

/// @nodoc
class _$MeshProvisioningCompletedDataCopyWithImpl<$Res> implements $MeshProvisioningCompletedDataCopyWith<$Res> {
  _$MeshProvisioningCompletedDataCopyWithImpl(this._value, this._then);

  final MeshProvisioningCompletedData _value;
  // ignore: unused_field
  final $Res Function(MeshProvisioningCompletedData) _then;

  @override
  $Res call({
    Object? state = freezed,
    Object? data = freezed,
    Object? meshNode = freezed,
  }) {
    return _then(_value.copyWith(
      state: state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<int>,
      meshNode: meshNode == freezed
          ? _value.meshNode
          : meshNode // ignore: cast_nullable_to_non_nullable
              as ProvisionedMeshNodeData?,
    ));
  }

  @override
  $ProvisionedMeshNodeDataCopyWith<$Res>? get meshNode {
    if (_value.meshNode == null) {
      return null;
    }

    return $ProvisionedMeshNodeDataCopyWith<$Res>(_value.meshNode!, (value) {
      return _then(_value.copyWith(meshNode: value));
    });
  }
}

/// @nodoc
abstract class _$MeshProvisioningCompletedDataCopyWith<$Res> implements $MeshProvisioningCompletedDataCopyWith<$Res> {
  factory _$MeshProvisioningCompletedDataCopyWith(
          _MeshProvisioningCompletedData value, $Res Function(_MeshProvisioningCompletedData) then) =
      __$MeshProvisioningCompletedDataCopyWithImpl<$Res>;
  @override
  $Res call({String state, List<int> data, ProvisionedMeshNodeData? meshNode});

  @override
  $ProvisionedMeshNodeDataCopyWith<$Res>? get meshNode;
}

/// @nodoc
class __$MeshProvisioningCompletedDataCopyWithImpl<$Res> extends _$MeshProvisioningCompletedDataCopyWithImpl<$Res>
    implements _$MeshProvisioningCompletedDataCopyWith<$Res> {
  __$MeshProvisioningCompletedDataCopyWithImpl(
      _MeshProvisioningCompletedData _value, $Res Function(_MeshProvisioningCompletedData) _then)
      : super(_value, (v) => _then(v as _MeshProvisioningCompletedData));

  @override
  _MeshProvisioningCompletedData get _value => super._value as _MeshProvisioningCompletedData;

  @override
  $Res call({
    Object? state = freezed,
    Object? data = freezed,
    Object? meshNode = freezed,
  }) {
    return _then(_MeshProvisioningCompletedData(
      state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<int>,
      meshNode == freezed
          ? _value.meshNode
          : meshNode // ignore: cast_nullable_to_non_nullable
              as ProvisionedMeshNodeData?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$_MeshProvisioningCompletedData implements _MeshProvisioningCompletedData {
  const _$_MeshProvisioningCompletedData(this.state, this.data, this.meshNode);

  factory _$_MeshProvisioningCompletedData.fromJson(Map<String, dynamic> json) =>
      _$_$_MeshProvisioningCompletedDataFromJson(json);

  @override
  final String state;
  @override
  final List<int> data;
  @override
  final ProvisionedMeshNodeData? meshNode;

  @override
  String toString() {
    return 'MeshProvisioningCompletedData(state: $state, data: $data, meshNode: $meshNode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MeshProvisioningCompletedData &&
            (identical(other.state, state) || const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.data, data) || const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.meshNode, meshNode) || const DeepCollectionEquality().equals(other.meshNode, meshNode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(meshNode);

  @JsonKey(ignore: true)
  @override
  _$MeshProvisioningCompletedDataCopyWith<_MeshProvisioningCompletedData> get copyWith =>
      __$MeshProvisioningCompletedDataCopyWithImpl<_MeshProvisioningCompletedData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MeshProvisioningCompletedDataToJson(this);
  }
}

abstract class _MeshProvisioningCompletedData implements MeshProvisioningCompletedData {
  const factory _MeshProvisioningCompletedData(String state, List<int> data, ProvisionedMeshNodeData? meshNode) =
      _$_MeshProvisioningCompletedData;

  factory _MeshProvisioningCompletedData.fromJson(Map<String, dynamic> json) =
      _$_MeshProvisioningCompletedData.fromJson;

  @override
  String get state => throw _privateConstructorUsedError;
  @override
  List<int> get data => throw _privateConstructorUsedError;
  @override
  ProvisionedMeshNodeData? get meshNode => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MeshProvisioningCompletedDataCopyWith<_MeshProvisioningCompletedData> get copyWith =>
      throw _privateConstructorUsedError;
}
