import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_key.freezed.dart';
part 'network_key.g.dart';

/// {@template network_key}
/// A freezed data class used to hold a given Network Key data
/// {@endtemplate}
@freezed
class NetworkKey with _$NetworkKey {
  /// {@macro network_key}
  const factory NetworkKey(
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
    int timestamp,
  ) = _NetworkKey;

  /// Provide a constructor to get [NetworkKey] from JSON [Map].
  /// {@macro network_key}
  factory NetworkKey.fromJson(Map<String, dynamic> json) => _$NetworkKeyFromJson(json);
}
