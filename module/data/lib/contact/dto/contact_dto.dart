import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_dto.freezed.dart';
part 'contact_dto.g.dart';

@freezed
class ContactDTO with _$ContactDTO {
  const factory ContactDTO({
    required int id,
    required String name,
    required String phoneNumber,
  }) = _ContactDTO;

  // JSON 변환 (Drift 쓸 때도 쓸 수 있음)
  factory ContactDTO.fromJson(Map<String, dynamic> json) =>
      _$ContactDTOFromJson(json);

  // Entity 변환
  factory ContactDTO.fromEntity(Contact contact) {
    return ContactDTO(
      id: contact.id,
      name: contact.name,
      phoneNumber: contact.phone,
    );
  }

  const ContactDTO._(); // fromEntity 등 커스텀 메서드용

  Contact toEntity() {
    return Contact(id: id, name: name, phone: phoneNumber);
  }
}
