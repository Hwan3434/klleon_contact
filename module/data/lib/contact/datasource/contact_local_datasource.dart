import 'package:data/contact/dto/contact_dto.dart';
import 'package:domain/contact/entity/contact_filter.dart';

abstract class ContactLocalDatasource {
  Future<ContactDTO> getContactById(String id);
  Future<List<ContactDTO>> getContacts(ContactFilter filter);
  Future<void> createContact(ContactDTO contact);
  Future<void> updateContact(ContactDTO contact);
  Future<void> deleteContact(String id);
}
