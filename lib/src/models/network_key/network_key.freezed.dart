// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'network_key.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NetworkKey _$NetworkKeyFromJson(Map<String, dynamic> json) {
  return _NetworkKey.fromJson(json);
}

/// @nodoc
class _$NetworkKeyTearOff {
  const _$NetworkKeyTearOff();

  _NetworkKey call(
      String name,
      int netKeyIndex,
      int phase,
      String phaseDescription,
      bool isMinSecurity,
      List<int> netKeyBytes,
      List<int>? oldNetKeyBytes,
      List<int> txNetworkKey,
      List<int> identityKey,
      List<int>? oldIdentityKey,
      String meshUuid,
      int timestamp) {
    return _NetworkKey(
      name,
      netKeyIndex,
      phase,
      phaseDescription,
      isMinSecurity,
      netKeyBytes,
      oldNetKeyBytes,
      txNetworkKey,
      identityKey,
      oldIdentityKey,
      meshUuid,
      timestamp,
    );
  }

  NetworkKey fromJson(Map<String, Object> json) {
    return NetworkKey.fromJson(json);
  }
}

/// @nodoc
const $NetworkKey = _$NetworkKeyTearOff();

/// @nodoc
mixin _$NetworkKey {
  String get name => throw _privateConstructorUsedError;
  int get netKeyIndex => throw _privateConstructorUsedError;
  int get phase => throw _privateConstructorUsedError;
  String get phaseDescription => throw _privateConstructorUsedError;
  bool get isMinSecurity => throw _privateConstructorUsedError;
  List<int> get netKeyBytes => throw _privateConstructorUsedError;
  List<int>? get oldNetKeyBytes => throw _privateConstructorUsedError;
  List<int> get txNetworkKey => throw _privateConstructorUsedError;
  List<int> get identityKey => throw _privateConstructorUsedError;
  List<int>? get oldIdentityKey => throw _privateConstructorUsedError;
  String get meshUuid => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkKeyCopyWith<NetworkKey> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkKeyCopyWith<$Res> {
  factory $NetworkKeyCopyWith(NetworkKey value, $Res Function(NetworkKey) then) = _$NetworkKeyCopyWithImpl<$Res>;
  $Res call(
      {String name,
      int netKeyIndex,
      int phase,
      String phaseDescription,
      bool isMinSecurity,
      List<int> netKeyBytes,
      List<int>? oldNetKeyBytes,
      List<int> txNetworkKey,
      List<int> identityKey,
      List<int>? oldIdentityKey,
      String meshUuid,
      int timestamp});
}

/// @nodoc
class _$NetworkKeyCopyWithImpl<$Res> implements $NetworkKeyCopyWith<$Res> {
  _$NetworkKeyCopyWithImpl(this._value, this._then);

  final NetworkKey _value;
  // ignore: unused_field
  final $Res Function(NetworkKey) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? netKeyIndex = freezed,
    Object? phase = freezed,
    Object? phaseDescription = freezed,
    Object? isMinSecurity = freezed,
    Object? netKeyBytes = freezed,
    Object? oldNetKeyBytes = freezed,
    Object? txNetworkKey = freezed,
    Object? identityKey = freezed,
    Object? oldIdentityKey = freezed,
    Object? meshUuid = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      netKeyIndex: netKeyIndex == freezed
          ? _value.netKeyIndex
          : netKeyIndex // ignore: cast_nullable_to_non_nullable
              as int,
      phase: phase == freezed
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as int,
      phaseDescription: phaseDescription == freezed
          ? _value.phaseDescription
          : phaseDescription // ignore: cast_nullable_to_non_nullable
              as String,
      isMinSecurity: isMinSecurity == freezed
          ? _value.isMinSecurity
          : isMinSecurity // ignore: cast_nullable_to_non_nullable
              as bool,
      netKeyBytes: netKeyBytes == freezed
          ? _value.netKeyBytes
          : netKeyBytes // ignore: cast_nullable_to_non_nullable
              as List<int>,
      oldNetKeyBytes: oldNetKeyBytes == freezed
          ? _value.oldNetKeyBytes
          : oldNetKeyBytes // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      txNetworkKey: txNetworkKey == freezed
          ? _value.txNetworkKey
          : txNetworkKey // ignore: cast_nullable_to_non_nullable
              as List<int>,
      identityKey: identityKey == freezed
          ? _value.identityKey
          : identityKey // ignore: cast_nullable_to_non_nullable
              as List<int>,
      oldIdentityKey: oldIdentityKey == freezed
          ? _value.oldIdentityKey
          : oldIdentityKey // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      meshUuid: meshUuid == freezed
          ? _value.meshUuid
          : meshUuid // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$NetworkKeyCopyWith<$Res> implements $NetworkKeyCopyWith<$Res> {
  factory _$NetworkKeyCopyWith(_NetworkKey value, $Res Function(_NetworkKey) then) = __$NetworkKeyCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      int netKeyIndex,
      int phase,
      String phaseDescription,
      bool isMinSecurity,
      List<int> netKeyBytes,
      List<int>? oldNetKeyBytes,
      List<int> txNetworkKey,
      List<int> identityKey,
      List<int>? oldIdentityKey,
      String meshUuid,
      int timestamp});
}

/// @nodoc
class __$NetworkKeyCopyWithImpl<$Res> extends _$NetworkKeyCopyWithImpl<$Res> implements _$NetworkKeyCopyWith<$Res> {
  __$NetworkKeyCopyWithImpl(_NetworkKey _value, $Res Function(_NetworkKey) _then)
      : super(_value, (v) => _then(v as _NetworkKey));

  @override
  _NetworkKey get _value => super._value as _NetworkKey;

  @override
  $Res call({
    Object? name = freezed,
    Object? netKeyIndex = freezed,
    Object? phase = freezed,
    Object? phaseDescription = freezed,
    Object? isMinSecurity = freezed,
    Object? netKeyBytes = freezed,
    Object? oldNetKeyBytes = freezed,
    Object? txNetworkKey = freezed,
    Object? identityKey = freezed,
    Object? oldIdentityKey = freezed,
    Object? meshUuid = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_NetworkKey(
      name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      netKeyIndex == freezed
          ? _value.netKeyIndex
          : netKeyIndex // ignore: cast_nullable_to_non_nullable
              as int,
      phase == freezed
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as int,
      phaseDescription == freezed
          ? _value.phaseDescription
          : phaseDescription // ignore: cast_nullable_to_non_nullable
              as String,
      isMinSecurity == freezed
          ? _value.isMinSecurity
          : isMinSecurity // ignore: cast_nullable_to_non_nullable
              as bool,
      netKeyBytes == freezed
          ? _value.netKeyBytes
          : netKeyBytes // ignore: cast_nullable_to_non_nullable
              as List<int>,
      oldNetKeyBytes == freezed
          ? _value.oldNetKeyBytes
          : oldNetKeyBytes // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      txNetworkKey == freezed
          ? _value.txNetworkKey
          : txNetworkKey // ignore: cast_nullable_to_non_nullable
              as List<int>,
      identityKey == freezed
          ? _value.identityKey
          : identityKey // ignore: cast_nullable_to_non_nullable
              as List<int>,
      oldIdentityKey == freezed
          ? _value.oldIdentityKey
          : oldIdentityKey // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      meshUuid == freezed
          ? _value.meshUuid
          : meshUuid // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NetworkKey implements _NetworkKey {
  const _$_NetworkKey(
      this.name,
      this.netKeyIndex,
      this.phase,
      this.phaseDescription,
      this.isMinSecurity,
      this.netKeyBytes,
      this.oldNetKeyBytes,
      this.txNetworkKey,
      this.identityKey,
      this.oldIdentityKey,
      this.meshUuid,
      this.timestamp);

  factory _$_NetworkKey.fromJson(Map<String, dynamic> json) => _$_$_NetworkKeyFromJson(json);

  @override
  final String name;
  @override
  final int netKeyIndex;
  @override
  final int phase;
  @override
  final String phaseDescription;
  @override
  final bool isMinSecurity;
  @override
  final List<int> netKeyBytes;
  @override
  final List<int>? oldNetKeyBytes;
  @override
  final List<int> txNetworkKey;
  @override
  final List<int> identityKey;
  @override
  final List<int>? oldIdentityKey;
  @override
  final String meshUuid;
  @override
  final int timestamp;

  @override
  String toString() {
    return 'NetworkKey(name: $name, netKeyIndex: $netKeyIndex, phase: $phase, phaseDescription: $phaseDescription, isMinSecurity: $isMinSecurity, netKeyBytes: $netKeyBytes, oldNetKeyBytes: $oldNetKeyBytes, txNetworkKey: $txNetworkKey, identityKey: $identityKey, oldIdentityKey: $oldIdentityKey, meshUuid: $meshUuid, timestamp: $timestamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _NetworkKey &&
            (identical(other.name, name) || const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.netKeyIndex, netKeyIndex) ||
                const DeepCollectionEquality().equals(other.netKeyIndex, netKeyIndex)) &&
            (identical(other.phase, phase) || const DeepCollectionEquality().equals(other.phase, phase)) &&
            (identical(other.phaseDescription, phaseDescription) ||
                const DeepCollectionEquality().equals(other.phaseDescription, phaseDescription)) &&
            (identical(other.isMinSecurity, isMinSecurity) ||
                const DeepCollectionEquality().equals(other.isMinSecurity, isMinSecurity)) &&
            (identical(other.netKeyBytes, netKeyBytes) ||
                const DeepCollectionEquality().equals(other.netKeyBytes, netKeyBytes)) &&
            (identical(other.oldNetKeyBytes, oldNetKeyBytes) ||
                const DeepCollectionEquality().equals(other.oldNetKeyBytes, oldNetKeyBytes)) &&
            (identical(other.txNetworkKey, txNetworkKey) ||
                const DeepCollectionEquality().equals(other.txNetworkKey, txNetworkKey)) &&
            (identical(other.identityKey, identityKey) ||
                const DeepCollectionEquality().equals(other.identityKey, identityKey)) &&
            (identical(other.oldIdentityKey, oldIdentityKey) ||
                const DeepCollectionEquality().equals(other.oldIdentityKey, oldIdentityKey)) &&
            (identical(other.meshUuid, meshUuid) || const DeepCollectionEquality().equals(other.meshUuid, meshUuid)) &&
            (identical(other.timestamp, timestamp) ||
                const DeepCollectionEquality().equals(other.timestamp, timestamp)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(netKeyIndex) ^
      const DeepCollectionEquality().hash(phase) ^
      const DeepCollectionEquality().hash(phaseDescription) ^
      const DeepCollectionEquality().hash(isMinSecurity) ^
      const DeepCollectionEquality().hash(netKeyBytes) ^
      const DeepCollectionEquality().hash(oldNetKeyBytes) ^
      const DeepCollectionEquality().hash(txNetworkKey) ^
      const DeepCollectionEquality().hash(identityKey) ^
      const DeepCollectionEquality().hash(oldIdentityKey) ^
      const DeepCollectionEquality().hash(meshUuid) ^
      const DeepCollectionEquality().hash(timestamp);

  @JsonKey(ignore: true)
  @override
  _$NetworkKeyCopyWith<_NetworkKey> get copyWith => __$NetworkKeyCopyWithImpl<_NetworkKey>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_NetworkKeyToJson(this);
  }
}

abstract class _NetworkKey implements NetworkKey {
  const factory _NetworkKey(
      String name,
      int netKeyIndex,
      int phase,
      String phaseDescription,
      bool isMinSecurity,
      List<int> netKeyBytes,
      List<int>? oldNetKeyBytes,
      List<int> txNetworkKey,
      List<int> identityKey,
      List<int>? oldIdentityKey,
      String meshUuid,
      int timestamp) = _$_NetworkKey;

  factory _NetworkKey.fromJson(Map<String, dynamic> json) = _$_NetworkKey.fromJson;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  int get netKeyIndex => throw _privateConstructorUsedError;
  @override
  int get phase => throw _privateConstructorUsedError;
  @override
  String get phaseDescription => throw _privateConstructorUsedError;
  @override
  bool get isMinSecurity => throw _privateConstructorUsedError;
  @override
  List<int> get netKeyBytes => throw _privateConstructorUsedError;
  @override
  List<int>? get oldNetKeyBytes => throw _privateConstructorUsedError;
  @override
  List<int> get txNetworkKey => throw _privateConstructorUsedError;
  @override
  List<int> get identityKey => throw _privateConstructorUsedError;
  @override
  List<int>? get oldIdentityKey => throw _privateConstructorUsedError;
  @override
  String get meshUuid => throw _privateConstructorUsedError;
  @override
  int get timestamp => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$NetworkKeyCopyWith<_NetworkKey> get copyWith => throw _privateConstructorUsedError;
}
