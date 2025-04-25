import 'package:di/di.dart';
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/common/contect_control_event_provider.dart';
import 'package:presentation/screen/contact_detail/contact_detail_event.dart';

import 'contact_detail_screen.dart';
import 'contact_detail_screen_type.dart';
import 'contact_detail_state.dart';

final contactDetailProvider = StateNotifierProvider.family
    .autoDispose<ContactDetailNotifier, ContactDetailScreenState, String?>((
      ref,
      contactId,
    ) {
      final r = getIt<GetContactsUseCase>();
      return ContactDetailNotifier(contactId ?? createContactId, r);
    });

class ContactDetailNotifier extends StateNotifier<ContactDetailScreenState> {
  final String id;
  final GetContactsUseCase _getContactsUseCase;
  ContactDetailNotifier(this.id, this._getContactsUseCase)
    : super(
        ContactDetailScreenState(
          id: id,
          name: "",
          phone: "",
          mode: ContactDetailScreenType.loading,
        ),
      ) {
    _fetch();
  }

  Future<void> _fetch() async {
    final result = await _getContactsUseCase.callById(id: id);
    result.when(
      success: (contact) {
        state = state.copyWith(
          id: contact.id,
          name: contact.name,
          phone: contact.phone,
          mode: ContactDetailScreenType.update,
          event: ContactDetailEvent.fetchSuccess(contact),
        );
      },
      failure: (error) {
        state = state.copyWith(
          mode: ContactDetailScreenType.create,
          event: ContactDetailEvent.fetchError(error),
        );
      },
    );
  }

  void createContact(WidgetRef ref, Contact contact) {
    if (contact.name.isEmpty) {
      state = state.copyWith(event: ContactDetailEvent.validate("이름을 입력해주세요."));
      return;
    }
    if (!contact.phone._isPhoneNumber) {
      state = state.copyWith(
        event: ContactDetailEvent.validate("전화번호가 올바르지않습니다."),
      );
      return;
    }
    ref.read(contactControlEventProvider.notifier).createContact(contact);
  }

  void updateContact(WidgetRef ref, Contact contact) {
    if (contact.name.isEmpty) {
      state = state.copyWith(event: ContactDetailEvent.validate("이름을 입력해주세요."));
      return;
    }
    if (!contact.phone._isPhoneNumber) {
      state = state.copyWith(
        event: ContactDetailEvent.validate("전화번호가 올바르지않습니다."),
      );
      return;
    }
    ref.read(contactControlEventProvider.notifier).updateContact(contact);
  }

  void deleteContact(WidgetRef ref, String id) {
    ref.read(contactControlEventProvider.notifier).deleteContact(id);
  }
}

extension PhoneNumberValidation on String {
  bool get _isPhoneNumber {
    final phoneRegExp = RegExp(
      r'^(01[0|1|6|7|8|9])[-]?[0-9]{3,4}[-]?[0-9]{4}$',
    );
    return phoneRegExp.hasMatch(this);
  }
}
