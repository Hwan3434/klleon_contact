import 'package:di/di.dart';
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/screen/contact/contact_list_state.dart';

/// TODO contactListProvider -> contactProvider 로 변경
/// 이유는 얘는 리스트 뿐만아니라 삽입, 삭제 수정까지 앱 전역에서 이쪽으로 접근 해야하기 때문
final contactListProvider =
    StateNotifierProvider<ContactListNotifier, ContactListState>((ref) {
      final c = getIt<CreateContactUseCase>();
      final r = getIt<GetContactsUseCase>();
      final u = getIt<UpdateContactUseCase>();
      return ContactListNotifier(c, r, u);
    });

class ContactListNotifier extends StateNotifier<ContactListState> {
  final CreateContactUseCase _createContactUseCase;
  final UpdateContactUseCase _updateContactUseCase;
  final GetContactsUseCase _getContactsUseCase;

  ContactListNotifier(
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

    await Future.delayed(Duration(seconds: 2));

    _getContactsUseCase.call(filter: state.filter).then((result) {
      result.when(
        success: (contacts) {
          if (contacts.isEmpty) {
            state = state.copyWith(hasMore: false, isLoading: false);
            return;
          }
          final more = contacts.length == state.filter.pageSize;
          state = state.copyWith(
            contacts: [...state.contacts, ...contacts],
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
        state = state.copyWith(contacts: [...state.contacts, contact]);
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
