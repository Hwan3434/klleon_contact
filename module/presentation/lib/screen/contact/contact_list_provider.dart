import 'package:di/di.dart';
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contact_list_state.dart';

typedef _OnContactsLoaded = void Function(List<Contact> data);
typedef _OnContactsLoadError = void Function(Object error);

final contactListProvider =
    StateNotifierProvider<ContactListNotifier, ContactListState>((ref) {
      final r = getIt<GetContactsUseCase>();
      return ContactListNotifier(r);
    });

class ContactListNotifier extends StateNotifier<ContactListState> {
  final GetContactsUseCase _getContactsUseCase;

  ContactListNotifier(this._getContactsUseCase)
    : super(
        ContactListState(
          contacts: [],
          isLoading: false,
          hasMore: true,
          filter: ContactFilter(pageNumber: 1, pageSize: 20),
        ),
      ) {
    _initialFetch();
  }

  /// 초기 데이터 가져오기
  Future<void> _initialFetch() async {
    state = state.copyWith(isLoading: true);

    _loadContactsAsync(
      (contacts) {
        logger.d("_initialFetch contacts size : ${contacts.length}");
        if (contacts.isEmpty) {
          state = state.copyWith(hasMore: false, isLoading: false);
          return;
        }
        state = state.copyWith(
          contacts: [...contacts],
          hasMore: contacts.length == state.filter.pageSize,
          isLoading: false,
          filter: state.filter.copyWith(
            pageNumber: state.filter.pageNumber + 1,
          ),
        );
      },
      (error) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  /// 데이터 가져오기
  Future<void> _loadContactsAsync(
    _OnContactsLoaded load,
    _OnContactsLoadError? errorCallback,
  ) async {
    await Future.delayed(Duration(seconds: 1));

    _getContactsUseCase.call(filter: state.filter).then((result) {
      result.when(
        success: (contacts) {
          final existingIds = state.contacts.map((c) => c.id).toSet();
          final filteredContacts =
              contacts.where((c) => !existingIds.contains(c.id)).toList();
          load(filteredContacts);
        },
        failure: (error) {
          // 에러 처리 로직 추가 가능
          errorCallback?.call(error);
        },
      );
    });
  }

  Future<void> more() async {
    if (!state.hasMore) {
      logger.w("더 이상 데이터가 없습니다.");
      return;
    }
    if (state.isLoading) {
      return;
    }
    logger.d("가져오기 more 2");

    state = state.copyWith(isLoading: true);

    _loadContactsAsync(
      (contacts) {
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
      (error) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  /// 연락처 추가시 정렬 문제로 refresh를 호출한다.
  void refresh() {
    state = state.copyWith(
      isLoading: true,
      contacts: [],
      filter: ContactFilter(pageNumber: 1, pageSize: 20),
    );
    _initialFetch();
  }

  Contact getContactByIndex(int index) {
    return state.contacts[index];
  }

  Contact getContactById(String id) {
    return state.contacts.firstWhere((contact) => contact.id == id);
  }

  /// 정렬 유지 문제로 제거
  // void create(Contact contact) {
  //   final exists = state.contacts.any((c) => c.id == contact.id);
  //   if (!exists) {
  //     state = state.copyWith(contacts: [...state.contacts, contact]);
  //   }
  // }

  void update(Contact contact) {
    state = state.copyWith(
      contacts:
          state.contacts.map((c) {
            if (c.id == contact.id) {
              return contact;
            }
            return c;
          }).toList(),
    );
  }

  void deleteById(String id) {
    state = state.copyWith(
      contacts: state.contacts.where((c) => c.id != id).toList(),
    );
  }
}
