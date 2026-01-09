import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../models/models.dart';

const _uuid = Uuid();

/// Service for fetching repeater data from Repeaterbook.com
class RepeaterbookService {
  static const _baseUrlNorthAmerica = 'https://www.repeaterbook.com/api/export.php';
  static const _baseUrlWorld = 'https://www.repeaterbook.com/api/exportROW.php';
  static const _userAgent = 'Ndmr/1.0 (DMR Codeplug Editor)';

  /// Search for DMR repeaters by country code
  ///
  /// [countryCode] - ISO country code (e.g., 'fr' for France, 'us' for USA)
  /// [stateId] - Optional state/region ID (FIPS code for US/Canada)
  Future<List<Repeater>> searchDmrRepeaters({
    required String countryCode,
    String? stateId,
    String? city,
  }) async {
    final isNorthAmerica = ['us', 'ca', 'mx'].contains(countryCode.toLowerCase());
    final baseUrl = isNorthAmerica ? _baseUrlNorthAmerica : _baseUrlWorld;

    final params = <String, String>{
      'mode': 'dmr',
    };

    if (isNorthAmerica && stateId != null) {
      params['state_id'] = stateId;
    } else {
      params['country'] = countryCode.toUpperCase();
    }

    if (city != null && city.isNotEmpty) {
      params['city'] = city;
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: params);

    try {
      final response = await http.get(
        uri,
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode != 200) {
        throw RepeaterbookException('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }

      final data = json.decode(response.body);

      if (data is! Map || data['count'] == null) {
        return [];
      }

      final results = data['results'] as List?;
      if (results == null || results.isEmpty) {
        return [];
      }

      return results
          .map((r) => Repeater.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is RepeaterbookException) rethrow;
      throw RepeaterbookException('Network error: $e');
    }
  }

  /// Convert a list of repeaters to channels
  List<Channel> repeatersToChannels(List<Repeater> repeaters) {
    return repeaters.map((r) => r.toChannel()).toList();
  }
}

/// Exception thrown by RepeaterbookService
class RepeaterbookException implements Exception {
  final String message;
  RepeaterbookException(this.message);

  @override
  String toString() => 'RepeaterbookException: $message';
}

/// Represents a repeater from Repeaterbook
class Repeater {
  final String? callsign;
  final String? city;
  final String? state;
  final String? country;
  final double frequency;
  final double offset;
  final String? colorCode;
  final String? dmrId;
  final String? notes;
  final String? status;

  Repeater({
    this.callsign,
    this.city,
    this.state,
    this.country,
    required this.frequency,
    required this.offset,
    this.colorCode,
    this.dmrId,
    this.notes,
    this.status,
  });

  factory Repeater.fromJson(Map<String, dynamic> json) {
    final freq = double.tryParse(json['Frequency']?.toString() ?? '') ?? 0.0;
    final offset = double.tryParse(json['Input Freq']?.toString() ?? '') ?? freq;

    return Repeater(
      callsign: json['Callsign'] as String?,
      city: json['Nearest City'] as String?,
      state: json['State'] as String?,
      country: json['Country'] as String?,
      frequency: freq,
      offset: offset - freq,
      colorCode: json['DMR Color Code']?.toString(),
      dmrId: json['DMR ID']?.toString(),
      notes: json['Notes'] as String?,
      status: json['Operational Status'] as String?,
    );
  }

  /// Convert to a Channel model
  Channel toChannel() {
    final name = _buildChannelName();
    final txFreq = frequency + offset;
    final cc = int.tryParse(colorCode ?? '') ?? 1;

    return Channel(
      id: _uuid.v4(),
      name: name,
      rxFrequency: frequency,
      txFrequency: txFreq,
      mode: ChannelMode.digital,
      power: Power.high,
      timeslot: 1,
      colorCode: cc.clamp(0, 15),
    );
  }

  String _buildChannelName() {
    final parts = <String>[];

    if (callsign != null && callsign!.isNotEmpty) {
      parts.add(callsign!);
    }

    if (city != null && city!.isNotEmpty) {
      parts.add(city!);
    } else if (state != null && state!.isNotEmpty) {
      parts.add(state!);
    }

    if (parts.isEmpty) {
      return 'DMR ${frequency.toStringAsFixed(4)}';
    }

    // Limit name length
    final name = parts.join(' - ');
    return name.length > 16 ? name.substring(0, 16) : name;
  }

  bool get isOperational => status?.toLowerCase() == 'on-air';
}

/// Country data for Repeaterbook
class RepeaterbookCountry {
  final String code;
  final String name;
  final bool isNorthAmerica;

  const RepeaterbookCountry({
    required this.code,
    required this.name,
    this.isNorthAmerica = false,
  });
}

/// Common countries for DMR repeaters
const repeaterbookCountries = [
  RepeaterbookCountry(code: 'fr', name: 'France'),
  RepeaterbookCountry(code: 'de', name: 'Germany'),
  RepeaterbookCountry(code: 'gb', name: 'United Kingdom'),
  RepeaterbookCountry(code: 'es', name: 'Spain'),
  RepeaterbookCountry(code: 'it', name: 'Italy'),
  RepeaterbookCountry(code: 'be', name: 'Belgium'),
  RepeaterbookCountry(code: 'ch', name: 'Switzerland'),
  RepeaterbookCountry(code: 'nl', name: 'Netherlands'),
  RepeaterbookCountry(code: 'at', name: 'Austria'),
  RepeaterbookCountry(code: 'pl', name: 'Poland'),
  RepeaterbookCountry(code: 'us', name: 'United States', isNorthAmerica: true),
  RepeaterbookCountry(code: 'ca', name: 'Canada', isNorthAmerica: true),
];
