import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';

@freezed
class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String name,
    required String phone,
  }) = _Contact;

  const Contact._(); // 반드시 필요!

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact && runtimeType == other.runtimeType && id == other.id);

  @override
  int get hashCode => id.hashCode;
}
