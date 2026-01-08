// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'codeplug.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Codeplug _$CodeplugFromJson(Map<String, dynamic> json) => _Codeplug(
  id: json['id'] as String,
  name: json['name'] as String? ?? 'New Codeplug',
  radioModel: json['radioModel'] as String? ?? 'Anytone AT-D878UV',
  channels:
      (json['channels'] as List<dynamic>?)
          ?.map((e) => Channel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  zones:
      (json['zones'] as List<dynamic>?)
          ?.map((e) => Zone.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  contacts:
      (json['contacts'] as List<dynamic>?)
          ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  scanLists:
      (json['scanLists'] as List<dynamic>?)
          ?.map((e) => ScanList.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  settings: json['settings'] == null
      ? const RadioSettings()
      : RadioSettings.fromJson(json['settings'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  modifiedAt: json['modifiedAt'] == null
      ? null
      : DateTime.parse(json['modifiedAt'] as String),
);

Map<String, dynamic> _$CodeplugToJson(_Codeplug instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'radioModel': instance.radioModel,
  'channels': instance.channels,
  'zones': instance.zones,
  'contacts': instance.contacts,
  'scanLists': instance.scanLists,
  'settings': instance.settings,
  'createdAt': instance.createdAt?.toIso8601String(),
  'modifiedAt': instance.modifiedAt?.toIso8601String(),
};
