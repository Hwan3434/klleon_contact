import 'package:domain/contact/common/k_result.dart';
import 'package:domain/contact/entity/contact.dart';
import 'package:domain/contact/repository/contact_repository.dart';

class GetContactsUseCase {
  final ContactRepository repository;

  GetContactsUseCase(this.repository);

  Future<KResult<List<Contact>>> call() async {
    try {
      final contacts = await repository.getAllContacts();
      return KResult.success(contacts);
    } catch (e) {
      return KResult.failure(e);
    }
  }
}
