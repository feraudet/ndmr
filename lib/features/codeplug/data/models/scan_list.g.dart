// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanList _$ScanListFromJson(Map<String, dynamic> json) => _ScanList(
  id: json['id'] as String,
  name: json['name'] as String,
  channelIds:
      (json['channelIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  priorityChannelId: json['priorityChannelId'] as String?,
);

Map<String, dynamic> _$ScanListToJson(_ScanList instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'channelIds': instance.channelIds,
  'priorityChannelId': instance.priorityChannelId,
};
