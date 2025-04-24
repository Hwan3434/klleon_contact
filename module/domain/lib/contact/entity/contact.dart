import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';

@freezed
class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String name,
    required String phone,
  }) = _Contact;
}
