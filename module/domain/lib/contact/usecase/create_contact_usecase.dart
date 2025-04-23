import 'package:domain/contact/common/k_result.dart';
import 'package:domain/contact/entity/contact.dart';
import 'package:domain/contact/repository/contact_repository.dart';

class CreateContactUseCase {
  final ContactRepository repository;

  CreateContactUseCase(this.repository);

  Future<KResult<void>> call(Contact contact) async {
    try {
      await repository.createContact(contact);
      return KResult.success(null);
    } catch (e) {
      return KResult.failure(e);
    }
  }
}
