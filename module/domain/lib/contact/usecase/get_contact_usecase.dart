import 'package:domain/contact/common/k_result.dart';
import 'package:domain/contact/entity/contact.dart';
import 'package:domain/contact/entity/contact_filter.dart';
import 'package:domain/contact/repository/contact_repository.dart';

class GetContactsUseCase {
  final ContactRepository repository;

  GetContactsUseCase(this.repository);

  Future<KResult<List<Contact>>> call({required ContactFilter filter}) async {
    try {
      final contacts = await repository.getContacts(filter);
      return KResult.success(contacts);
    } catch (e) {
      return KResult.failure(e);
    }
  }

  Future<KResult<Contact>> callById({required String id}) async {
    try {
      final contact = await repository.getContactById(id);
      return KResult.success(contact);
    } catch (e) {
      return KResult.failure(e);
    }
  }
}
