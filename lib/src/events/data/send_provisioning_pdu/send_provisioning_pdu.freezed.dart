// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'send_provisioning_pdu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SendProvisioningPduData _$SendProvisioningPduDataFromJson(Map<String, dynamic> json) {
  return _SendProvisioningPduData.fromJson(json);
}

/// @nodoc
class _$SendProvisioningPduDataTearOff {
  const _$SendProvisioningPduDataTearOff();

  _SendProvisioningPduData call(List<int> pdu, UnprovisionedMeshNode meshNode) {
    return _SendProvisioningPduData(
      pdu,
      meshNode,
    );
  }

  SendProvisioningPduData fromJson(Map<String, Object> json) {
    return SendProvisioningPduData.fromJson(json);
  }
}

/// @nodoc
const $SendProvisioningPduData = _$SendProvisioningPduDataTearOff();

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
abstract class _$SendProvisioningPduDataCopyWith<$Res> implements $SendProvisioningPduDataCopyWith<$Res> {
  factory _$SendProvisioningPduDataCopyWith(
          _SendProvisioningPduData value, $Res Function(_SendProvisioningPduData) then) =
      __$SendProvisioningPduDataCopyWithImpl<$Res>;
  @override
  $Res call({List<int> pdu, UnprovisionedMeshNode meshNode});
}

/// @nodoc
class __$SendProvisioningPduDataCopyWithImpl<$Res> extends _$SendProvisioningPduDataCopyWithImpl<$Res>
    implements _$SendProvisioningPduDataCopyWith<$Res> {
  __$SendProvisioningPduDataCopyWithImpl(_SendProvisioningPduData _value, $Res Function(_SendProvisioningPduData) _then)
      : super(_value, (v) => _then(v as _SendProvisioningPduData));

  @override
  _SendProvisioningPduData get _value => super._value as _SendProvisioningPduData;

  @override
  $Res call({
    Object? pdu = freezed,
    Object? meshNode = freezed,
  }) {
    return _then(_SendProvisioningPduData(
      pdu == freezed
          ? _value.pdu
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
  const _$_SendProvisioningPduData(this.pdu, this.meshNode);

  factory _$_SendProvisioningPduData.fromJson(Map<String, dynamic> json) => _$_$_SendProvisioningPduDataFromJson(json);

  @override
  final List<int> pdu;
  @override
  final UnprovisionedMeshNode meshNode;

  @override
  String toString() {
    return 'SendProvisioningPduData(pdu: $pdu, meshNode: $meshNode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SendProvisioningPduData &&
            (identical(other.pdu, pdu) || const DeepCollectionEquality().equals(other.pdu, pdu)) &&
            (identical(other.meshNode, meshNode) || const DeepCollectionEquality().equals(other.meshNode, meshNode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(pdu) ^ const DeepCollectionEquality().hash(meshNode);

  @JsonKey(ignore: true)
  @override
  _$SendProvisioningPduDataCopyWith<_SendProvisioningPduData> get copyWith =>
      __$SendProvisioningPduDataCopyWithImpl<_SendProvisioningPduData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_SendProvisioningPduDataToJson(this);
  }
}

abstract class _SendProvisioningPduData implements SendProvisioningPduData {
  const factory _SendProvisioningPduData(List<int> pdu, UnprovisionedMeshNode meshNode) = _$_SendProvisioningPduData;

  factory _SendProvisioningPduData.fromJson(Map<String, dynamic> json) = _$_SendProvisioningPduData.fromJson;

  @override
  List<int> get pdu => throw _privateConstructorUsedError;
  @override
  UnprovisionedMeshNode get meshNode => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$SendProvisioningPduDataCopyWith<_SendProvisioningPduData> get copyWith => throw _privateConstructorUsedError;
}
