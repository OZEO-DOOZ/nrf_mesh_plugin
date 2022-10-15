// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'mesh_provisioning_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UnprovisionedMeshNodeData _$UnprovisionedMeshNodeDataFromJson(Map<String, dynamic> json) {
  return _UnprovisionedMeshNodeData.fromJson(json);
}

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
abstract class _$$_UnprovisionedMeshNodeDataCopyWith<$Res> implements $UnprovisionedMeshNodeDataCopyWith<$Res> {
  factory _$$_UnprovisionedMeshNodeDataCopyWith(
          _$_UnprovisionedMeshNodeData value, $Res Function(_$_UnprovisionedMeshNodeData) then) =
      __$$_UnprovisionedMeshNodeDataCopyWithImpl<$Res>;
  @override
  $Res call({String uuid, List<int>? provisionerPublicKeyXY});
}

/// @nodoc
class __$$_UnprovisionedMeshNodeDataCopyWithImpl<$Res> extends _$UnprovisionedMeshNodeDataCopyWithImpl<$Res>
    implements _$$_UnprovisionedMeshNodeDataCopyWith<$Res> {
  __$$_UnprovisionedMeshNodeDataCopyWithImpl(
      _$_UnprovisionedMeshNodeData _value, $Res Function(_$_UnprovisionedMeshNodeData) _then)
      : super(_value, (v) => _then(v as _$_UnprovisionedMeshNodeData));

  @override
  _$_UnprovisionedMeshNodeData get _value => super._value as _$_UnprovisionedMeshNodeData;

  @override
  $Res call({
    Object? uuid = freezed,
    Object? provisionerPublicKeyXY = freezed,
  }) {
    return _then(_$_UnprovisionedMeshNodeData(
      uuid == freezed
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      provisionerPublicKeyXY: provisionerPublicKeyXY == freezed
          ? _value._provisionerPublicKeyXY
          : provisionerPublicKeyXY // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UnprovisionedMeshNodeData implements _UnprovisionedMeshNodeData {
  const _$_UnprovisionedMeshNodeData(this.uuid, {final List<int>? provisionerPublicKeyXY = const []})
      : _provisionerPublicKeyXY = provisionerPublicKeyXY;

  factory _$_UnprovisionedMeshNodeData.fromJson(Map<String, dynamic> json) =>
      _$$_UnprovisionedMeshNodeDataFromJson(json);

  @override
  final String uuid;
  final List<int>? _provisionerPublicKeyXY;
  @override
  @JsonKey()
  List<int>? get provisionerPublicKeyXY {
    final value = _provisionerPublicKeyXY;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UnprovisionedMeshNodeData(uuid: $uuid, provisionerPublicKeyXY: $provisionerPublicKeyXY)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UnprovisionedMeshNodeData &&
            const DeepCollectionEquality().equals(other.uuid, uuid) &&
            const DeepCollectionEquality().equals(other._provisionerPublicKeyXY, _provisionerPublicKeyXY));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(uuid),
      const DeepCollectionEquality().hash(_provisionerPublicKeyXY));

  @JsonKey(ignore: true)
  @override
  _$$_UnprovisionedMeshNodeDataCopyWith<_$_UnprovisionedMeshNodeData> get copyWith =>
      __$$_UnprovisionedMeshNodeDataCopyWithImpl<_$_UnprovisionedMeshNodeData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UnprovisionedMeshNodeDataToJson(
      this,
    );
  }
}

abstract class _UnprovisionedMeshNodeData implements UnprovisionedMeshNodeData {
  const factory _UnprovisionedMeshNodeData(final String uuid, {final List<int>? provisionerPublicKeyXY}) =
      _$_UnprovisionedMeshNodeData;

  factory _UnprovisionedMeshNodeData.fromJson(Map<String, dynamic> json) = _$_UnprovisionedMeshNodeData.fromJson;

  @override
  String get uuid;
  @override
  List<int>? get provisionerPublicKeyXY;
  @override
  @JsonKey(ignore: true)
  _$$_UnprovisionedMeshNodeDataCopyWith<_$_UnprovisionedMeshNodeData> get copyWith =>
      throw _privateConstructorUsedError;
}

ProvisionedMeshNodeData _$ProvisionedMeshNodeDataFromJson(Map<String, dynamic> json) {
  return _ProvisionedMeshNodeData.fromJson(json);
}

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
abstract class _$$_ProvisionedMeshNodeDataCopyWith<$Res> implements $ProvisionedMeshNodeDataCopyWith<$Res> {
  factory _$$_ProvisionedMeshNodeDataCopyWith(
          _$_ProvisionedMeshNodeData value, $Res Function(_$_ProvisionedMeshNodeData) then) =
      __$$_ProvisionedMeshNodeDataCopyWithImpl<$Res>;
  @override
  $Res call({String uuid});
}

/// @nodoc
class __$$_ProvisionedMeshNodeDataCopyWithImpl<$Res> extends _$ProvisionedMeshNodeDataCopyWithImpl<$Res>
    implements _$$_ProvisionedMeshNodeDataCopyWith<$Res> {
  __$$_ProvisionedMeshNodeDataCopyWithImpl(
      _$_ProvisionedMeshNodeData _value, $Res Function(_$_ProvisionedMeshNodeData) _then)
      : super(_value, (v) => _then(v as _$_ProvisionedMeshNodeData));

  @override
  _$_ProvisionedMeshNodeData get _value => super._value as _$_ProvisionedMeshNodeData;

  @override
  $Res call({
    Object? uuid = freezed,
  }) {
    return _then(_$_ProvisionedMeshNodeData(
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

  factory _$_ProvisionedMeshNodeData.fromJson(Map<String, dynamic> json) => _$$_ProvisionedMeshNodeDataFromJson(json);

  @override
  final String uuid;

  @override
  String toString() {
    return 'ProvisionedMeshNodeData(uuid: $uuid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProvisionedMeshNodeData &&
            const DeepCollectionEquality().equals(other.uuid, uuid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(uuid));

  @JsonKey(ignore: true)
  @override
  _$$_ProvisionedMeshNodeDataCopyWith<_$_ProvisionedMeshNodeData> get copyWith =>
      __$$_ProvisionedMeshNodeDataCopyWithImpl<_$_ProvisionedMeshNodeData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProvisionedMeshNodeDataToJson(
      this,
    );
  }
}

abstract class _ProvisionedMeshNodeData implements ProvisionedMeshNodeData {
  const factory _ProvisionedMeshNodeData(final String uuid) = _$_ProvisionedMeshNodeData;

  factory _ProvisionedMeshNodeData.fromJson(Map<String, dynamic> json) = _$_ProvisionedMeshNodeData.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(ignore: true)
  _$$_ProvisionedMeshNodeDataCopyWith<_$_ProvisionedMeshNodeData> get copyWith => throw _privateConstructorUsedError;
}

MeshProvisioningStatusData _$MeshProvisioningStatusDataFromJson(Map<String, dynamic> json) {
  return _MeshProvisioningStatusData.fromJson(json);
}

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
abstract class _$$_MeshProvisioningStatusDataCopyWith<$Res> implements $MeshProvisioningStatusDataCopyWith<$Res> {
  factory _$$_MeshProvisioningStatusDataCopyWith(
          _$_MeshProvisioningStatusData value, $Res Function(_$_MeshProvisioningStatusData) then) =
      __$$_MeshProvisioningStatusDataCopyWithImpl<$Res>;
  @override
  $Res call({String state, List<int> data, UnprovisionedMeshNodeData? meshNode});

  @override
  $UnprovisionedMeshNodeDataCopyWith<$Res>? get meshNode;
}

/// @nodoc
class __$$_MeshProvisioningStatusDataCopyWithImpl<$Res> extends _$MeshProvisioningStatusDataCopyWithImpl<$Res>
    implements _$$_MeshProvisioningStatusDataCopyWith<$Res> {
  __$$_MeshProvisioningStatusDataCopyWithImpl(
      _$_MeshProvisioningStatusData _value, $Res Function(_$_MeshProvisioningStatusData) _then)
      : super(_value, (v) => _then(v as _$_MeshProvisioningStatusData));

  @override
  _$_MeshProvisioningStatusData get _value => super._value as _$_MeshProvisioningStatusData;

  @override
  $Res call({
    Object? state = freezed,
    Object? data = freezed,
    Object? meshNode = freezed,
  }) {
    return _then(_$_MeshProvisioningStatusData(
      state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      data == freezed
          ? _value._data
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
  const _$_MeshProvisioningStatusData(this.state, final List<int> data, this.meshNode) : _data = data;

  factory _$_MeshProvisioningStatusData.fromJson(Map<String, dynamic> json) =>
      _$$_MeshProvisioningStatusDataFromJson(json);

  @override
  final String state;
  final List<int> _data;
  @override
  List<int> get data {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final UnprovisionedMeshNodeData? meshNode;

  @override
  String toString() {
    return 'MeshProvisioningStatusData(state: $state, data: $data, meshNode: $meshNode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MeshProvisioningStatusData &&
            const DeepCollectionEquality().equals(other.state, state) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality().equals(other.meshNode, meshNode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(state),
      const DeepCollectionEquality().hash(_data), const DeepCollectionEquality().hash(meshNode));

  @JsonKey(ignore: true)
  @override
  _$$_MeshProvisioningStatusDataCopyWith<_$_MeshProvisioningStatusData> get copyWith =>
      __$$_MeshProvisioningStatusDataCopyWithImpl<_$_MeshProvisioningStatusData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MeshProvisioningStatusDataToJson(
      this,
    );
  }
}

abstract class _MeshProvisioningStatusData implements MeshProvisioningStatusData {
  const factory _MeshProvisioningStatusData(
          final String state, final List<int> data, final UnprovisionedMeshNodeData? meshNode) =
      _$_MeshProvisioningStatusData;

  factory _MeshProvisioningStatusData.fromJson(Map<String, dynamic> json) = _$_MeshProvisioningStatusData.fromJson;

  @override
  String get state;
  @override
  List<int> get data;
  @override
  UnprovisionedMeshNodeData? get meshNode;
  @override
  @JsonKey(ignore: true)
  _$$_MeshProvisioningStatusDataCopyWith<_$_MeshProvisioningStatusData> get copyWith =>
      throw _privateConstructorUsedError;
}

MeshProvisioningCompletedData _$MeshProvisioningCompletedDataFromJson(Map<String, dynamic> json) {
  return _MeshProvisioningCompletedData.fromJson(json);
}

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
abstract class _$$_MeshProvisioningCompletedDataCopyWith<$Res> implements $MeshProvisioningCompletedDataCopyWith<$Res> {
  factory _$$_MeshProvisioningCompletedDataCopyWith(
          _$_MeshProvisioningCompletedData value, $Res Function(_$_MeshProvisioningCompletedData) then) =
      __$$_MeshProvisioningCompletedDataCopyWithImpl<$Res>;
  @override
  $Res call({String state, List<int> data, ProvisionedMeshNodeData? meshNode});

  @override
  $ProvisionedMeshNodeDataCopyWith<$Res>? get meshNode;
}

/// @nodoc
class __$$_MeshProvisioningCompletedDataCopyWithImpl<$Res> extends _$MeshProvisioningCompletedDataCopyWithImpl<$Res>
    implements _$$_MeshProvisioningCompletedDataCopyWith<$Res> {
  __$$_MeshProvisioningCompletedDataCopyWithImpl(
      _$_MeshProvisioningCompletedData _value, $Res Function(_$_MeshProvisioningCompletedData) _then)
      : super(_value, (v) => _then(v as _$_MeshProvisioningCompletedData));

  @override
  _$_MeshProvisioningCompletedData get _value => super._value as _$_MeshProvisioningCompletedData;

  @override
  $Res call({
    Object? state = freezed,
    Object? data = freezed,
    Object? meshNode = freezed,
  }) {
    return _then(_$_MeshProvisioningCompletedData(
      state == freezed
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      data == freezed
          ? _value._data
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
  const _$_MeshProvisioningCompletedData(this.state, final List<int> data, this.meshNode) : _data = data;

  factory _$_MeshProvisioningCompletedData.fromJson(Map<String, dynamic> json) =>
      _$$_MeshProvisioningCompletedDataFromJson(json);

  @override
  final String state;
  final List<int> _data;
  @override
  List<int> get data {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final ProvisionedMeshNodeData? meshNode;

  @override
  String toString() {
    return 'MeshProvisioningCompletedData(state: $state, data: $data, meshNode: $meshNode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MeshProvisioningCompletedData &&
            const DeepCollectionEquality().equals(other.state, state) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality().equals(other.meshNode, meshNode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(state),
      const DeepCollectionEquality().hash(_data), const DeepCollectionEquality().hash(meshNode));

  @JsonKey(ignore: true)
  @override
  _$$_MeshProvisioningCompletedDataCopyWith<_$_MeshProvisioningCompletedData> get copyWith =>
      __$$_MeshProvisioningCompletedDataCopyWithImpl<_$_MeshProvisioningCompletedData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MeshProvisioningCompletedDataToJson(
      this,
    );
  }
}

abstract class _MeshProvisioningCompletedData implements MeshProvisioningCompletedData {
  const factory _MeshProvisioningCompletedData(
          final String state, final List<int> data, final ProvisionedMeshNodeData? meshNode) =
      _$_MeshProvisioningCompletedData;

  factory _MeshProvisioningCompletedData.fromJson(Map<String, dynamic> json) =
      _$_MeshProvisioningCompletedData.fromJson;

  @override
  String get state;
  @override
  List<int> get data;
  @override
  ProvisionedMeshNodeData? get meshNode;
  @override
  @JsonKey(ignore: true)
  _$$_MeshProvisioningCompletedDataCopyWith<_$_MeshProvisioningCompletedData> get copyWith =>
      throw _privateConstructorUsedError;
}
