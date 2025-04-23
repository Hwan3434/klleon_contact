import 'package:domain/contact/common/k_result.dart';
import 'package:domain/contact/entity/contact.dart';
import 'package:domain/contact/repository/contact_repository.dart';

class UpdateContactUseCase {
  final ContactRepository repository;

  UpdateContactUseCase(this.repository);

  Future<KResult<void>> call(Contact contact) async {
    try {
      await repository.updateContact(contact);
      return KResult.success(null);
    } catch (e) {
      return KResult.failure(e);
    }
  }
}
