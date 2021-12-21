import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_key.freezed.dart';
part 'network_key.g.dart';

@freezed
class NetworkKey with _$NetworkKey {
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

  factory NetworkKey.fromJson(Map<String, dynamic> json) => _$NetworkKeyFromJson(json);
}
