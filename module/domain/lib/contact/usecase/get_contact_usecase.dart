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

  Stream<KResult<List<Contact>>> stream({
    required ContactFilter filter,
  }) async* {
    try {
      await for (final contacts in repository.streamContacts(filter)) {
        yield KResult.success(contacts);
      }
    } catch (e) {
      yield KResult.failure(e);
    }
  }
}
