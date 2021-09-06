import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nordic_nrf_mesh/src/models/provisioner/range_addresses/allocated_group_range.dart';
import 'package:nordic_nrf_mesh/src/models/provisioner/range_addresses/allocated_scene_range.dart';
import 'package:nordic_nrf_mesh/src/models/provisioner/range_addresses/allocated_unicast_range.dart';

part 'provisioner.freezed.dart';
part 'provisioner.g.dart';

@freezed
class Provisioner with _$Provisioner {
  const factory Provisioner(
      String provisionerName,
      String provisionerUuid,
      int globalTtl,
      int provisionerAddress,
      List<AllocatedUnicastRange> allocatedUnicastRanges,
      List<AllocatedGroupRange> allocatedGroupRanges,
      List<AllocatedSceneRange> allocatedSceneRanges,
      bool lastSelected) = _Provisioner;

  factory Provisioner.fromJson(Map<String, dynamic> json) => _$ProvisionerFromJson(json);
}
