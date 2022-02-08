// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dooz_epoch_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DoozEpochStatusData _$_$_DoozEpochStatusDataFromJson(Map<String, dynamic> json) {
  return _$_DoozEpochStatusData(
    json['tzData'] as int,
    json['command'] as int,
    json['io'] as int,
    json['unused'] as int,
    json['epoch'] as int,
    json['correlation'] as int,
    json['extra'] as int,
    json['source'] as int,
    json['destination'] as int,
  );
}

Map<String, dynamic> _$_$_DoozEpochStatusDataToJson(_$_DoozEpochStatusData instance) => <String, dynamic>{
      'tzData': instance.tzData,
      'command': instance.command,
      'io': instance.io,
      'unused': instance.unused,
      'epoch': instance.epoch,
      'correlation': instance.correlation,
      'extra': instance.extra,
      'source': instance.source,
      'destination': instance.destination,
    };
