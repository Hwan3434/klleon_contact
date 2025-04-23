import 'package:data/contact/datasource/contact_local_datasource.dart';
import 'package:data/contact/dto/contact_dto.dart';
import 'package:domain/contact/entity/contact_filter.dart';
import 'package:domain/domain.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactLocalDatasource _localDatasource;

  ContactRepositoryImpl(this._localDatasource);

  @override
  Future<List<Contact>> getContacts(ContactFilter filter) async {
    final dtos = await _localDatasource.getContacts(filter);
    return dtos.map((dto) => dto.toEntity()).toList();
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
