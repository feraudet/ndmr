import 'package:freezed_annotation/freezed_annotation.dart';

part 'radio_settings.freezed.dart';
part 'radio_settings.g.dart';

@freezed
sealed class RadioSettings with _$RadioSettings {
  const factory RadioSettings({
    @Default(0) int dmrId,
    @Default('') String callsign,
    @Default('Ndmr') String introLine1,
    @Default('') String introLine2,
    @Default(true) bool keyTone,
    @Default(5) int backlightTimeout,
    @Default(3) int squelchLevel,
    @Default(5) int voxLevel,
    @Default(false) bool voxEnabled,
  }) = _RadioSettings;

  factory RadioSettings.fromJson(Map<String, dynamic> json) =>
      _$RadioSettingsFromJson(json);
}
