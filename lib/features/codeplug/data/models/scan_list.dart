import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_list.freezed.dart';
part 'scan_list.g.dart';

@freezed
sealed class ScanList with _$ScanList {
  const factory ScanList({
    required String id,
    required String name,
    @Default([]) List<String> channelIds,
    String? priorityChannelId,
  }) = _ScanList;

  factory ScanList.fromJson(Map<String, dynamic> json) =>
      _$ScanListFromJson(json);
}
