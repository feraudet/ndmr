import 'package:freezed_annotation/freezed_annotation.dart';

import 'channel.dart';
import 'contact.dart';
import 'radio_settings.dart';
import 'scan_list.dart';
import 'zone.dart';

part 'codeplug.freezed.dart';
part 'codeplug.g.dart';

@freezed
sealed class Codeplug with _$Codeplug {
  const Codeplug._();

  const factory Codeplug({
    required String id,
    @Default('New Codeplug') String name,
    @Default('Anytone AT-D878UV') String radioModel,
    @Default([]) List<Channel> channels,
    @Default([]) List<Zone> zones,
    @Default([]) List<Contact> contacts,
    @Default([]) List<ScanList> scanLists,
    @Default(RadioSettings()) RadioSettings settings,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) = _Codeplug;

  factory Codeplug.fromJson(Map<String, dynamic> json) =>
      _$CodeplugFromJson(json);

  Channel? channelById(String id) =>
      channels.where((c) => c.id == id).firstOrNull;

  Contact? contactById(String id) =>
      contacts.where((c) => c.id == id).firstOrNull;

  Zone? zoneById(String id) => zones.where((z) => z.id == id).firstOrNull;

  ScanList? scanListById(String id) =>
      scanLists.where((s) => s.id == id).firstOrNull;
}
