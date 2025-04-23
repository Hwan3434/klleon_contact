import 'package:data/contact/dto/contact_dto.dart';
import 'package:domain/contact/entity/contact_filter.dart';

abstract class ContactLocalDatasource {
  Future<List<ContactDTO>> getContacts(ContactFilter filter);
  Future<void> createContact(ContactDTO contact);
  Future<void> updateContact(ContactDTO contact);
  Future<void> deleteContact(int id);
}
