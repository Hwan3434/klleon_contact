import 'package:di/di.dart';
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contact_event.dart';

/// DB 변화 이벤트 제공
final contactControlEventProvider =
    StateNotifierProvider<ContactController, ContactEvent?>((ref) {
      final c = getIt<CreateContactUseCase>();
      final u = getIt<UpdateContactUseCase>();
      final d = getIt<DeleteContactUseCase>();
      return ContactController(c, u, d);
    });

class ContactController extends StateNotifier<ContactEvent?> {
  final CreateContactUseCase _create;
  final UpdateContactUseCase _update;
  final DeleteContactUseCase _delete;

  ContactController(this._create, this._update, this._delete) : super(null);

  Future<void> createContact(Contact contact) async {
    final result = await _create(contact);
    result.when(
      success: (_) {
        state = ContactEvent.createSuccess(contact);
      },
      failure: (error) {
        state = ContactEvent.createFailure(error);
      },
    );
  }

  Future<void> updateContact(Contact contact) async {
    final result = await _update(contact);
    result.when(
      success: (_) {
        state = ContactEvent.updateSuccess(contact);
      },
      failure: (error) {
        state = ContactEvent.updateFailure(error);
      },
    );
  }

  Future<void> deleteContact(String id) async {
    final result = await _delete.call(id);
    result.when(
      success: (_) {
        state = ContactEvent.deleteSuccess(id);
      },
      failure: (error) {
        state = ContactEvent.deleteFailure(error);
      },
    );
  }
}
