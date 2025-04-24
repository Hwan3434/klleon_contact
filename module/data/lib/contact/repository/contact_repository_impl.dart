import 'package:data/contact/datasource/contact_local_datasource.dart';
import 'package:data/contact/dto/contact_dto.dart';
import 'package:domain/domain.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactLocalDatasource _localDatasource;

  ContactRepositoryImpl(this._localDatasource);

  @override
  Stream<List<Contact>> streamContacts(ContactFilter filter) {
    if (filter.pageNumber < 1) {
      throw ArgumentError('페이지는 1부터 시작입니다. 1보다 작은 값은 허용되지 않습니다.');
    }
    return _localDatasource.streamContacts(filter).map((contactDTOs) {
      return contactDTOs.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<List<Contact>> getContacts(ContactFilter filter) async {
    if (filter.pageNumber < 1) {
      throw ArgumentError('페이지는 1부터 시작입니다. 1보다 작은 값은 허용되지 않습니다.');
    }
    final contactDTOs = await _localDatasource.getContacts(filter);
    return contactDTOs.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> createContact(Contact contact) async {
    final dto = ContactDTO.fromEntity(contact);
    await _localDatasource.createContact(dto);
  }

  @override
  Future<void> updateContact(Contact contact) async {
    final dto = ContactDTO.fromEntity(contact);
    await _localDatasource.updateContact(dto);
  }

  @override
  Future<void> deleteContact(int id) async {
    await _localDatasource.deleteContact(id);
  }
}
