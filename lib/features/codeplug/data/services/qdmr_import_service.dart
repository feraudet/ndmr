import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:yaml/yaml.dart';

import '../models/models.dart';

const _uuid = Uuid();

/// Service for importing qdmr YAML codeplug files
class QdmrImportService {
  /// Import a qdmr YAML file and convert it to a Codeplug
  Future<Codeplug?> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['yaml', 'yml'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    String content;

    if (file.bytes != null) {
      content = String.fromCharCodes(file.bytes!);
    } else if (file.path != null) {
      content = await File(file.path!).readAsString();
    } else {
      return null;
    }

    return parseYaml(content, file.name);
  }

  /// Parse qdmr YAML content into a Codeplug
  Codeplug? parseYaml(String content, String fileName) {
    try {
      final yaml = loadYaml(content);
      if (yaml is! YamlMap) return null;

      // Parse settings
      final settings = _parseSettings(yaml);

      // Parse contacts
      final contacts = _parseContacts(yaml['contacts']);

      // Parse channels
      final channels = _parseChannels(yaml['channels']);

      // Parse zones
      final zones = _parseZones(yaml['zones'], channels);

      // Get codeplug name from filename
      final name = fileName.replaceAll(RegExp(r'\.(yaml|yml)$'), '');

      return Codeplug(
        id: _uuid.v4(),
        name: name,
        radioModel: 'Imported from qdmr',
        channels: channels,
        zones: zones,
        contacts: contacts,
        settings: settings,
        createdAt: DateTime.now(),
        modifiedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  RadioSettings _parseSettings(YamlMap yaml) {
    final settings = yaml['settings'];
    if (settings is! YamlMap) {
      return const RadioSettings();
    }

    // Try to get DMR ID from radioIDs section
    int dmrId = 0;
    final radioIds = yaml['radioIDs'];
    if (radioIds is YamlList && radioIds.isNotEmpty) {
      final firstId = radioIds.first;
      if (firstId is YamlMap) {
        dmrId = _parseInt(firstId['number']) ?? 0;
      }
    }

    return RadioSettings(
      dmrId: dmrId,
      callsign: '',
      introLine1: _parseString(settings['introLine1']) ?? 'Ndmr',
      introLine2: _parseString(settings['introLine2']) ?? '',
    );
  }

  List<Contact> _parseContacts(dynamic contactsYaml) {
    if (contactsYaml is! YamlList) return [];

    return contactsYaml
        .map((c) => _parseContact(c))
        .whereType<Contact>()
        .toList();
  }

  Contact? _parseContact(dynamic contactYaml) {
    if (contactYaml is! YamlMap) return null;

    final name = _parseString(contactYaml['name']);
    final dmrId = _parseInt(contactYaml['number']);

    if (name == null || dmrId == null) return null;

    // Parse call type
    final typeStr = _parseString(contactYaml['type'])?.toLowerCase() ?? '';
    final callType = switch (typeStr) {
      'groupcall' || 'group' => CallType.group,
      'privatecall' || 'private' => CallType.private,
      'allcall' || 'all' => CallType.allCall,
      _ => CallType.group,
    };

    return Contact(
      id: _uuid.v4(),
      name: name,
      dmrId: dmrId,
      callType: callType,
    );
  }

  List<Channel> _parseChannels(dynamic channelsYaml) {
    if (channelsYaml is! YamlList) return [];

    return channelsYaml
        .map((c) => _parseChannel(c))
        .whereType<Channel>()
        .toList();
  }

  Channel? _parseChannel(dynamic channelYaml) {
    if (channelYaml is! YamlMap) return null;

    // Check if it's a digital or analog channel
    final isDigital = channelYaml.containsKey('digital');
    final channelData =
        isDigital ? channelYaml['digital'] : channelYaml['analog'];

    if (channelData is! YamlMap) return null;

    final name = _parseString(channelData['name']);
    final rxFreq = _parseFrequency(channelData['rxFrequency']);
    final txFreq = _parseFrequency(channelData['txFrequency']);

    if (name == null || rxFreq == null || txFreq == null) return null;

    // Parse power
    final powerStr = _parseString(channelData['power'])?.toLowerCase() ?? '';
    final power = switch (powerStr) {
      'low' || 'min' => Power.low,
      'mid' || 'medium' => Power.medium,
      'max' || 'high' => Power.high,
      _ => Power.high,
    };

    if (isDigital) {
      // Digital channel
      final timeslot = _parseInt(channelData['timeslot']) ?? 1;
      final colorCode = _parseInt(channelData['colorCode']) ?? 1;

      return Channel(
        id: _uuid.v4(),
        name: name,
        rxFrequency: rxFreq,
        txFrequency: txFreq,
        mode: ChannelMode.digital,
        power: power,
        timeslot: timeslot,
        colorCode: colorCode,
      );
    } else {
      // Analog channel
      final rxTone = _parseTone(channelData['rxTone']);
      final txTone = _parseTone(channelData['txTone']);

      return Channel(
        id: _uuid.v4(),
        name: name,
        rxFrequency: rxFreq,
        txFrequency: txFreq,
        mode: ChannelMode.analog,
        power: power,
        rxTone: rxTone,
        txTone: txTone,
      );
    }
  }

  List<Zone> _parseZones(dynamic zonesYaml, List<Channel> channels) {
    if (zonesYaml is! YamlList) return [];

    // Create a map of channel names to IDs for reference lookup
    final channelNameToId = <String, String>{};
    for (final channel in channels) {
      channelNameToId[channel.name.toLowerCase()] = channel.id;
    }

    return zonesYaml.map((z) {
      if (z is! YamlMap) return null;

      final name = _parseString(z['name']);
      if (name == null) return null;

      // Parse channel references (can be A or B list)
      final channelIds = <String>[];

      // Try 'A' list first (common in qdmr)
      final aChannels = z['A'];
      if (aChannels is YamlList) {
        for (final channelName in aChannels) {
          final nameStr = channelName?.toString().toLowerCase();
          if (nameStr != null && channelNameToId.containsKey(nameStr)) {
            channelIds.add(channelNameToId[nameStr]!);
          }
        }
      }

      // Also try 'B' list
      final bChannels = z['B'];
      if (bChannels is YamlList) {
        for (final channelName in bChannels) {
          final nameStr = channelName?.toString().toLowerCase();
          if (nameStr != null && channelNameToId.containsKey(nameStr)) {
            channelIds.add(channelNameToId[nameStr]!);
          }
        }
      }

      // Also try 'channels' list
      final channelsList = z['channels'];
      if (channelsList is YamlList) {
        for (final channelName in channelsList) {
          final nameStr = channelName?.toString().toLowerCase();
          if (nameStr != null && channelNameToId.containsKey(nameStr)) {
            channelIds.add(channelNameToId[nameStr]!);
          }
        }
      }

      return Zone(
        id: _uuid.v4(),
        name: name,
        channelIds: channelIds,
      );
    }).whereType<Zone>().toList();
  }

  String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  double? _parseFrequency(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      // Handle frequency strings like "430.500 MHz" or "430500000"
      final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
      final freq = double.tryParse(cleaned);
      if (freq == null) return null;

      // If frequency is in Hz, convert to MHz
      if (freq > 1000000) {
        return freq / 1000000;
      }
      return freq;
    }
    return null;
  }

  double? _parseTone(dynamic value) {
    if (value == null) return null;

    // Handle CTCSS tone objects like {ctcss: 88.5}
    if (value is YamlMap) {
      if (value.containsKey('ctcss')) {
        return _parseDouble(value['ctcss']);
      }
    }

    return _parseDouble(value);
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
