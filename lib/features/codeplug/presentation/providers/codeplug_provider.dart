import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/models.dart';

part 'codeplug_provider.g.dart';

const _uuid = Uuid();

@riverpod
class CodeplugNotifier extends _$CodeplugNotifier {
  @override
  Codeplug? build() => null;

  void createNew({
    String? radioModel,
    int? dmrId,
    String? callsign,
    bool addDefaultContacts = true,
  }) {
    state = Codeplug(
      id: _uuid.v4(),
      name: 'Nouvelle configuration',
      radioModel: radioModel ?? 'Anytone AT-D878UV',
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
      contacts: addDefaultContacts ? _defaultContacts : [],
      settings: RadioSettings(
        dmrId: dmrId ?? 0,
        callsign: callsign ?? '',
      ),
    );
  }

  static final _defaultContacts = [
    Contact(id: _uuid.v4(), name: 'Local', dmrId: 9, callType: CallType.group),
    Contact(id: _uuid.v4(), name: 'France', dmrId: 208, callType: CallType.group),
    Contact(id: _uuid.v4(), name: 'Francophonie', dmrId: 2080, callType: CallType.group),
    Contact(id: _uuid.v4(), name: 'Europe', dmrId: 92, callType: CallType.group),
    Contact(id: _uuid.v4(), name: 'Mondial', dmrId: 91, callType: CallType.group),
    Contact(id: _uuid.v4(), name: 'Echo Test', dmrId: 9990, callType: CallType.private),
  ];

  void load(Codeplug codeplug) {
    state = codeplug;
  }

  void updateName(String name) {
    if (state == null) return;
    state = state!.copyWith(name: name, modifiedAt: DateTime.now());
  }

  void updateSettings(RadioSettings settings) {
    if (state == null) return;
    state = state!.copyWith(settings: settings, modifiedAt: DateTime.now());
  }

  // Channel operations
  void addChannel(Channel channel) {
    if (state == null) return;
    state = state!.copyWith(
      channels: [...state!.channels, channel],
      modifiedAt: DateTime.now(),
    );
  }

  void updateChannel(Channel channel) {
    if (state == null) return;
    state = state!.copyWith(
      channels: state!.channels.map((c) => c.id == channel.id ? channel : c).toList(),
      modifiedAt: DateTime.now(),
    );
  }

  void deleteChannel(String id) {
    if (state == null) return;
    state = state!.copyWith(
      channels: state!.channels.where((c) => c.id != id).toList(),
      modifiedAt: DateTime.now(),
    );
  }

  void reorderChannels(int oldIndex, int newIndex) {
    if (state == null) return;
    final channels = List<Channel>.from(state!.channels);
    if (newIndex > oldIndex) newIndex--;
    final channel = channels.removeAt(oldIndex);
    channels.insert(newIndex, channel);
    state = state!.copyWith(
      channels: channels,
      modifiedAt: DateTime.now(),
    );
  }

  // Contact operations
  void addContact(Contact contact) {
    if (state == null) return;
    state = state!.copyWith(
      contacts: [...state!.contacts, contact],
      modifiedAt: DateTime.now(),
    );
  }

  void updateContact(Contact contact) {
    if (state == null) return;
    state = state!.copyWith(
      contacts: state!.contacts.map((c) => c.id == contact.id ? contact : c).toList(),
      modifiedAt: DateTime.now(),
    );
  }

  void deleteContact(String id) {
    if (state == null) return;
    state = state!.copyWith(
      contacts: state!.contacts.where((c) => c.id != id).toList(),
      modifiedAt: DateTime.now(),
    );
  }

  // Zone operations
  void addZone(Zone zone) {
    if (state == null) return;
    state = state!.copyWith(
      zones: [...state!.zones, zone],
      modifiedAt: DateTime.now(),
    );
  }

  void updateZone(Zone zone) {
    if (state == null) return;
    state = state!.copyWith(
      zones: state!.zones.map((z) => z.id == zone.id ? zone : z).toList(),
      modifiedAt: DateTime.now(),
    );
  }

  void deleteZone(String id) {
    if (state == null) return;
    state = state!.copyWith(
      zones: state!.zones.where((z) => z.id != id).toList(),
      modifiedAt: DateTime.now(),
    );
  }

  // ScanList operations
  void addScanList(ScanList scanList) {
    if (state == null) return;
    state = state!.copyWith(
      scanLists: [...state!.scanLists, scanList],
      modifiedAt: DateTime.now(),
    );
  }

  void updateScanList(ScanList scanList) {
    if (state == null) return;
    state = state!.copyWith(
      scanLists: state!.scanLists.map((s) => s.id == scanList.id ? scanList : s).toList(),
      modifiedAt: DateTime.now(),
    );
  }

  void deleteScanList(String id) {
    if (state == null) return;
    state = state!.copyWith(
      scanLists: state!.scanLists.where((s) => s.id != id).toList(),
      modifiedAt: DateTime.now(),
    );
  }
}
