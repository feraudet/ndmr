// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Channel _$ChannelFromJson(Map<String, dynamic> json) => _Channel(
  id: json['id'] as String,
  name: json['name'] as String,
  rxFrequency: (json['rxFrequency'] as num).toDouble(),
  txFrequency: (json['txFrequency'] as num).toDouble(),
  mode:
      $enumDecodeNullable(_$ChannelModeEnumMap, json['mode']) ??
      ChannelMode.digital,
  power: $enumDecodeNullable(_$PowerEnumMap, json['power']) ?? Power.high,
  bandwidth:
      $enumDecodeNullable(_$BandwidthEnumMap, json['bandwidth']) ??
      Bandwidth.narrow,
  timeslot: (json['timeslot'] as num?)?.toInt() ?? 1,
  colorCode: (json['colorCode'] as num?)?.toInt() ?? 1,
  contactId: json['contactId'] as String?,
  rxTone: (json['rxTone'] as num?)?.toDouble(),
  txTone: (json['txTone'] as num?)?.toDouble(),
  scanListId: json['scanListId'] as String?,
  zoneId: json['zoneId'] as String?,
);

Map<String, dynamic> _$ChannelToJson(_Channel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'rxFrequency': instance.rxFrequency,
  'txFrequency': instance.txFrequency,
  'mode': _$ChannelModeEnumMap[instance.mode]!,
  'power': _$PowerEnumMap[instance.power]!,
  'bandwidth': _$BandwidthEnumMap[instance.bandwidth]!,
  'timeslot': instance.timeslot,
  'colorCode': instance.colorCode,
  'contactId': instance.contactId,
  'rxTone': instance.rxTone,
  'txTone': instance.txTone,
  'scanListId': instance.scanListId,
  'zoneId': instance.zoneId,
};

const _$ChannelModeEnumMap = {
  ChannelMode.analog: 'analog',
  ChannelMode.digital: 'digital',
};

const _$PowerEnumMap = {
  Power.low: 'low',
  Power.medium: 'medium',
  Power.high: 'high',
  Power.turbo: 'turbo',
};

const _$BandwidthEnumMap = {Bandwidth.narrow: 'narrow', Bandwidth.wide: 'wide'};
