// 뷰모델 클래스
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contact_list_state.dart';

class ContactViewModel extends StateNotifier<ContactListState> {
  final CreateContactUseCase _createContactUseCase;
  final UpdateContactUseCase _updateContactUseCase;
  final GetContactsUseCase _getContactsUseCase;

  ContactViewModel(
    this._createContactUseCase,
    this._getContactsUseCase,
    this._updateContactUseCase,
  ) : super(
        ContactListState(
          contacts: [],
          isLoading: false,
          hasMore: true,
          filter: ContactFilter(pageNumber: 1, pageSize: 20),
        ),
      ) {
    _fetch();
  }

  void _fetch() {
    more();
  }

  void more() async {
    if (!state.hasMore) {
      logger.w("더 이상 데이터가 없습니다.");
      return;
    }
    if (state.isLoading) {
      logger.w("이미 로딩 중입니다.");
      return;
    }

    state = state.copyWith(isLoading: true);

    _getContactsUseCase.call(filter: state.filter).then((result) {
      result.when(
        success: (contacts) {
          if (contacts.isEmpty) {
            state = state.copyWith(hasMore: false, isLoading: false);
            return;
          }
          final more = contacts.length < state.filter.pageSize;
          state = state.copyWith(
            contacts: contacts,
            hasMore: more,
            isLoading: false,
            filter: state.filter.copyWith(
              pageNumber: state.filter.pageNumber + 1,
            ),
          );
        },
        failure: (error) {
          // 에러 처리 로직 추가 가능
          state = state.copyWith(isLoading: false);
        },
      );
    });
  }

  void createContact(Contact contact) async {
    final result = await _createContactUseCase(contact);
    result.when(
      success: (_) {
        // 성공 시 UI 업데이트 로직 추가 가능
        logger.d('Contact created successfully');
      },
      failure: (error) {
        // 에러 처리 로직 추가 가능
        logger.e('Failed to create contact: $error');
      },
    );
  }

  void updateContact(Contact contact) async {
    final result = await _updateContactUseCase(contact);
    result.when(
      success: (_) {
        // 성공 시 UI 업데이트 로직 추가 가능
        logger.d('Contact updated successfully');
        state = state.copyWith(
          contacts:
              state.contacts.map((c) {
                if (c.id == contact.id) {
                  return contact;
                }
                return c;
              }).toList(),
        );
      },
      failure: (error) {
        // 에러 처리 로직 추가 가능
        logger.e('Failed to update contact: $error');
      },
    );
  }
}
