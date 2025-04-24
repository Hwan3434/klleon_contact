import 'package:domain/contact/entity/contact.dart';
import 'package:domain/contact/entity/contact_filter.dart';

abstract class ContactRepository {
  Future<List<Contact>> getContacts(ContactFilter filter);
  Future<void> createContact(Contact contact);
  Future<void> updateContact(Contact contact);
  Future<void> deleteContact(int id);
}
