import 'package:domain/contact/entity/contact.dart';

abstract class ContactRepository {
  Future<List<Contact>> getAllContacts();
  Future<void> createContact(Contact contact);
  Future<void> updateContact(Contact contact);
  Future<void> deleteContact(int id);
}
