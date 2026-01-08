import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

enum CallType { group, private, allCall }

@freezed
sealed class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String name,
    required int dmrId,
    @Default(CallType.group) CallType callType,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
