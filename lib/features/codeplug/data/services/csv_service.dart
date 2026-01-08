import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/channel.dart';

const _uuid = Uuid();

/// Service for importing and exporting channels as CSV
class CsvService {
  static const _headers = [
    'Name',
    'RX Frequency',
    'TX Frequency',
    'Mode',
    'Power',
    'Timeslot',
    'Color Code',
    'Bandwidth',
    'RX Tone',
    'TX Tone',
  ];

  /// Export channels to CSV file
  Future<bool> exportChannels(List<Channel> channels) async {
    final rows = <List<dynamic>>[
      _headers,
      ...channels.map(_channelToRow),
    ];

    final csv = const ListToCsvConverter().convert(rows);

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Export channels as CSV',
      fileName: 'channels.csv',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) return false;

    final file = File(result);
    await file.writeAsString(csv);
    return true;
  }

  /// Import channels from CSV file
  Future<List<Channel>?> importChannels() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
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

    final rows = const CsvToListConverter().convert(content);
    if (rows.isEmpty) return null;

    // Skip header row if it looks like headers
    final firstRow = rows.first;
    final hasHeader = firstRow.isNotEmpty &&
        firstRow[0].toString().toLowerCase().contains('name');
    final dataRows = hasHeader && rows.length > 1 ? rows.sublist(1) : rows;

    return dataRows.map(_rowToChannel).whereType<Channel>().toList();
  }

  List<dynamic> _channelToRow(Channel channel) => [
        channel.name,
        channel.rxFrequency,
        channel.txFrequency,
        channel.mode.name.toUpperCase(),
        channel.power.name.toUpperCase(),
        channel.timeslot,
        channel.colorCode,
        channel.bandwidth.name.toUpperCase(),
        channel.rxTone ?? '',
        channel.txTone ?? '',
      ];

  Channel? _rowToChannel(List<dynamic> row) {
    if (row.length < 3) return null;

    try {
      final name = row[0]?.toString() ?? '';
      final rxFreq = _parseDouble(row[1]);
      final txFreq = _parseDouble(row[2]);

      if (rxFreq == null || txFreq == null) return null;

      final mode = _parseMode(row.length > 3 ? row[3]?.toString() : null);
      final power = _parsePower(row.length > 4 ? row[4]?.toString() : null);
      final timeslot = _parseInt(row.length > 5 ? row[5] : null) ?? 1;
      final colorCode = _parseInt(row.length > 6 ? row[6] : null) ?? 1;
      final bandwidth =
          _parseBandwidth(row.length > 7 ? row[7]?.toString() : null);
      final rxTone = row.length > 8 ? _parseDouble(row[8]) : null;
      final txTone = row.length > 9 ? _parseDouble(row[9]) : null;

      return Channel(
        id: _uuid.v4(),
        name: name,
        rxFrequency: rxFreq,
        txFrequency: txFreq,
        mode: mode,
        power: power,
        timeslot: timeslot,
        colorCode: colorCode,
        bandwidth: bandwidth,
        rxTone: rxTone,
        txTone: txTone,
      );
    } catch (e) {
      return null;
    }
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final cleaned = value.trim();
      if (cleaned.isEmpty) return null;
      return double.tryParse(cleaned.replaceAll(',', '.'));
    }
    return null;
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final cleaned = value.trim();
      if (cleaned.isEmpty) return null;
      return int.tryParse(cleaned);
    }
    return null;
  }

  ChannelMode _parseMode(String? value) {
    if (value == null) return ChannelMode.digital;
    final lower = value.toLowerCase().trim();
    if (lower == 'analog' || lower == 'analogique' || lower == 'fm') {
      return ChannelMode.analog;
    }
    return ChannelMode.digital;
  }

  Power _parsePower(String? value) {
    if (value == null) return Power.high;
    final lower = value.toLowerCase().trim();
    return switch (lower) {
      'low' || 'faible' || 'l' => Power.low,
      'medium' || 'moyen' || 'mid' || 'm' => Power.medium,
      'turbo' || 't' => Power.turbo,
      _ => Power.high,
    };
  }

  Bandwidth _parseBandwidth(String? value) {
    if (value == null) return Bandwidth.narrow;
    final lower = value.toLowerCase().trim();
    if (lower == 'wide' || lower == 'large' || lower == '25' || lower == 'w') {
      return Bandwidth.wide;
    }
    return Bandwidth.narrow;
  }
}
