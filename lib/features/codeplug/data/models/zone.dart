import 'package:freezed_annotation/freezed_annotation.dart';

part 'zone.freezed.dart';
part 'zone.g.dart';

@freezed
sealed class Zone with _$Zone {
  const factory Zone({
    required String id,
    required String name,
    @Default([]) List<String> channelIds,
  }) = _Zone;

  factory Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);
}
