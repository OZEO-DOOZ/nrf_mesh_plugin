// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'send_provisioning_pdu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SendProvisioningPduData _$SendProvisioningPduDataFromJson(Map<String, dynamic> json) {
  return _SendProvisioningPduData.fromJson(json);
}

/// @nodoc
mixin _$SendProvisioningPduData {
  List<int> get pdu => throw _privateConstructorUsedError;
  UnprovisionedMeshNode get meshNode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SendProvisioningPduDataCopyWith<SendProvisioningPduData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendProvisioningPduDataCopyWith<$Res> {
  factory $SendProvisioningPduDataCopyWith(SendProvisioningPduData value, $Res Function(SendProvisioningPduData) then) =
      _$SendProvisioningPduDataCopyWithImpl<$Res>;
  $Res call({List<int> pdu, UnprovisionedMeshNode meshNode});
}

/// @nodoc
class _$SendProvisioningPduDataCopyWithImpl<$Res> implements $SendProvisioningPduDataCopyWith<$Res> {
  _$SendProvisioningPduDataCopyWithImpl(this._value, this._then);

  final SendProvisioningPduData _value;
  // ignore: unused_field
  final $Res Function(SendProvisioningPduData) _then;

  @override
  $Res call({
    Object? pdu = freezed,
    Object? meshNode = freezed,
  }) {
    return _then(_value.copyWith(
      pdu: pdu == freezed
          ? _value.pdu
          : pdu // ignore: cast_nullable_to_non_nullable
              as List<int>,
      meshNode: meshNode == freezed
          ? _value.meshNode
          : meshNode // ignore: cast_nullable_to_non_nullable
              as UnprovisionedMeshNode,
    ));
  }
}

/// @nodoc
abstract class _$$_SendProvisioningPduDataCopyWith<$Res> implements $SendProvisioningPduDataCopyWith<$Res> {
  factory _$$_SendProvisioningPduDataCopyWith(
          _$_SendProvisioningPduData value, $Res Function(_$_SendProvisioningPduData) then) =
      __$$_SendProvisioningPduDataCopyWithImpl<$Res>;
  @override
  $Res call({List<int> pdu, UnprovisionedMeshNode meshNode});
}

/// @nodoc
class __$$_SendProvisioningPduDataCopyWithImpl<$Res> extends _$SendProvisioningPduDataCopyWithImpl<$Res>
    implements _$$_SendProvisioningPduDataCopyWith<$Res> {
  __$$_SendProvisioningPduDataCopyWithImpl(
      _$_SendProvisioningPduData _value, $Res Function(_$_SendProvisioningPduData) _then)
      : super(_value, (v) => _then(v as _$_SendProvisioningPduData));

  @override
  _$_SendProvisioningPduData get _value => super._value as _$_SendProvisioningPduData;

  @override
  $Res call({
    Object? pdu = freezed,
    Object? meshNode = freezed,
  }) {
    return _then(_$_SendProvisioningPduData(
      pdu == freezed
          ? _value._pdu
          : pdu // ignore: cast_nullable_to_non_nullable
              as List<int>,
      meshNode == freezed
          ? _value.meshNode
          : meshNode // ignore: cast_nullable_to_non_nullable
              as UnprovisionedMeshNode,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$_SendProvisioningPduData implements _SendProvisioningPduData {
  const _$_SendProvisioningPduData(final List<int> pdu, this.meshNode) : _pdu = pdu;

  factory _$_SendProvisioningPduData.fromJson(Map<String, dynamic> json) => _$$_SendProvisioningPduDataFromJson(json);

  final List<int> _pdu;
  @override
  List<int> get pdu {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pdu);
  }

  @override
  final UnprovisionedMeshNode meshNode;

  @override
  String toString() {
    return 'SendProvisioningPduData(pdu: $pdu, meshNode: $meshNode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SendProvisioningPduData &&
            const DeepCollectionEquality().equals(other._pdu, _pdu) &&
            const DeepCollectionEquality().equals(other.meshNode, meshNode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_pdu), const DeepCollectionEquality().hash(meshNode));

  @JsonKey(ignore: true)
  @override
  _$$_SendProvisioningPduDataCopyWith<_$_SendProvisioningPduData> get copyWith =>
      __$$_SendProvisioningPduDataCopyWithImpl<_$_SendProvisioningPduData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SendProvisioningPduDataToJson(
      this,
    );
  }
}

abstract class _SendProvisioningPduData implements SendProvisioningPduData {
  const factory _SendProvisioningPduData(final List<int> pdu, final UnprovisionedMeshNode meshNode) =
      _$_SendProvisioningPduData;

  factory _SendProvisioningPduData.fromJson(Map<String, dynamic> json) = _$_SendProvisioningPduData.fromJson;

  @override
  List<int> get pdu;
  @override
  UnprovisionedMeshNode get meshNode;
  @override
  @JsonKey(ignore: true)
  _$$_SendProvisioningPduDataCopyWith<_$_SendProvisioningPduData> get copyWith => throw _privateConstructorUsedError;
}
