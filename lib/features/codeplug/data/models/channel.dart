import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel.freezed.dart';
part 'channel.g.dart';

enum ChannelMode { analog, digital }

enum Power { low, medium, high, turbo }

enum Bandwidth { narrow, wide }

@freezed
sealed class Channel with _$Channel {
  const factory Channel({
    required String id,
    required String name,
    required double rxFrequency,
    required double txFrequency,
    @Default(ChannelMode.digital) ChannelMode mode,
    @Default(Power.high) Power power,
    @Default(Bandwidth.narrow) Bandwidth bandwidth,
    // DMR specific
    @Default(1) int timeslot,
    @Default(1) int colorCode,
    String? contactId,
    // Analog specific
    double? rxTone,
    double? txTone,
    // Optional
    String? scanListId,
    String? zoneId,
  }) = _Channel;

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
}
