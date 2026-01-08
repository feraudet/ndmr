// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RadioSettings _$RadioSettingsFromJson(Map<String, dynamic> json) =>
    _RadioSettings(
      dmrId: (json['dmrId'] as num?)?.toInt() ?? 0,
      callsign: json['callsign'] as String? ?? '',
      introLine1: json['introLine1'] as String? ?? 'Ndmr',
      introLine2: json['introLine2'] as String? ?? '',
      keyTone: json['keyTone'] as bool? ?? true,
      backlightTimeout: (json['backlightTimeout'] as num?)?.toInt() ?? 5,
      squelchLevel: (json['squelchLevel'] as num?)?.toInt() ?? 3,
      voxLevel: (json['voxLevel'] as num?)?.toInt() ?? 5,
      voxEnabled: json['voxEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$RadioSettingsToJson(_RadioSettings instance) =>
    <String, dynamic>{
      'dmrId': instance.dmrId,
      'callsign': instance.callsign,
      'introLine1': instance.introLine1,
      'introLine2': instance.introLine2,
      'keyTone': instance.keyTone,
      'backlightTimeout': instance.backlightTimeout,
      'squelchLevel': instance.squelchLevel,
      'voxLevel': instance.voxLevel,
      'voxEnabled': instance.voxEnabled,
    };
