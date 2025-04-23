import 'package:domain/contact/common/k_result.dart';
import 'package:domain/contact/repository/contact_repository.dart';

class DeleteContactUseCase {
  final ContactRepository repository;

  DeleteContactUseCase(this.repository);

  Future<KResult<void>> call(int id) async {
    try {
      await repository.deleteContact(id);
      return KResult.success(null);
    } catch (e) {
      return KResult.failure(e);
    }
  }
}
