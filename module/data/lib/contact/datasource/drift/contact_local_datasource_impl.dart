import 'package:data/contact/common/drift/contact_dao.dart';
import 'package:data/contact/common/drift/k_drift_database.dart';
import 'package:data/contact/datasource/contact_local_datasource.dart';
import 'package:data/contact/dto/contact_dto.dart';
import 'package:domain/contact/entity/contact_filter.dart';
import 'package:drift/drift.dart';

class ContactLocalDatasourceImpl implements ContactLocalDatasource {
  final ContactDao _contactDao;

  ContactLocalDatasourceImpl(this._contactDao);

  @override
  Stream<List<ContactDTO>> streamContacts(ContactFilter filter) {
    return _contactDao
        .watchContactsWithPaging(
          pageNumber: filter.pageNumber,
          pageSize: filter.pageSize,
          query: filter.query,
          sortOrder: filter.sortOrder,
        )
        .map((contacts) {
          return contacts.map((contact) {
            return ContactDTO(
              id: contact.id,
              name: contact.name,
              phoneNumber: contact.phone,
            );
          }).toList();
        });
  }

  @override
  Future<List<ContactDTO>> getContacts(ContactFilter filter) async {
    return await _contactDao
        .getContactsWithPaging(
          query: filter.query,
          pageNumber: filter.pageNumber,
          pageSize: filter.pageSize,
          sortOrder: filter.sortOrder,
        )
        .then(
          (contacts) =>
              contacts.map((contact) {
                return ContactDTO(
                  id: contact.id,
                  name: contact.name,
                  phoneNumber: contact.phone,
                );
              }).toList(),
        );
  }

  @override
  Future<void> createContact(ContactDTO contact) {
    return _contactDao.insertContact(
      ContactTableCompanion(
        id: Value(contact.id),
        name: Value(contact.name),
        phone: Value(contact.phoneNumber),
      ),
    );
  }

  @override
  Future<void> updateContact(ContactDTO contact) {
    return _contactDao.updateContact(
      ContactTableCompanion(
        id: Value(contact.id),
        name: Value(contact.name),
        phone: Value(contact.phoneNumber),
      ),
    );
  }

  @override
  Future<void> deleteContact(int id) {
    return _contactDao.deleteContact(id);
  }
}
