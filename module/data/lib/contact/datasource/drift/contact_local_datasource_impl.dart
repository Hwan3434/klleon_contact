import 'package:data/contact/common/drift/app_database.dart';
import 'package:data/contact/common/drift/contact_dao.dart';
import 'package:data/contact/datasource/contact_local_datasource.dart';
import 'package:data/contact/dto/contact_dto.dart';
import 'package:domain/contact/entity/contact_filter.dart';
import 'package:drift/drift.dart';

class ContactLocalDatasourceImpl implements ContactLocalDatasource {
  final ContactDao _contactDao;

  ContactLocalDatasourceImpl(this._contactDao);

  @override
  Future<List<ContactDTO>> getContacts(ContactFilter filter) async {
    return await _contactDao
        .getContactsWithPaging(
          query: filter.query,
          page: filter.page,
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
        createdAt: Value(DateTime.now()), // 새로 생성할 때는 현재 시간
        updatedAt: const Value.absent(), // 기본값 null
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
        createdAt: Value(DateTime.now()), // 새로 생성할 때는 현재 시간
        updatedAt: const Value.absent(), // 기본값 null
      ),
    );
  }

  @override
  Future<void> deleteContact(int id) {
    return _contactDao.deleteContact(id);
  }
}
