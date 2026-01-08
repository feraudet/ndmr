// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  id: json['id'] as String,
  name: json['name'] as String,
  dmrId: (json['dmrId'] as num).toInt(),
  callType:
      $enumDecodeNullable(_$CallTypeEnumMap, json['callType']) ??
      CallType.group,
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dmrId': instance.dmrId,
  'callType': _$CallTypeEnumMap[instance.callType]!,
};

const _$CallTypeEnumMap = {
  CallType.group: 'group',
  CallType.private: 'private',
  CallType.allCall: 'allCall',
};
