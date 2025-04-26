import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:presentation/common/contect_control_event_provider.dart';
import 'package:presentation/common/screen_path.dart';
import 'package:presentation/util/klleon_snack_bar.dart';

import 'contact_list_provider.dart';

class ContactListScreen extends ConsumerStatefulWidget {
  const ContactListScreen({super.key});

  @override
  ConsumerState<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends ConsumerState<ContactListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // 바닥 근처 도달 시 다음 페이지 요청
        ref.read(contactListProvider.notifier).more();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void contactListener() {
    ref.listen(
      contactControlEventProvider.select((event) {
        return event;
      }),
      (prev, next) {
        final event = next;
        if (event != null) {
          event.when(
            createSuccess: (contact) {
              ref.read(contactListProvider.notifier).refresh();
              KlleonSnackBar.show(context, "생성 성공");
            },
            createFailure: (error) {
              KlleonSnackBar.show(context, "생성 실패");
            },
            deleteSuccess: (id) {
              ref.read(contactListProvider.notifier).deleteById(id);
              KlleonSnackBar.show(context, "삭제 성공");
            },
            deleteFailure: (error) {
              KlleonSnackBar.show(context, "삭제 실패");
            },
            updateSuccess: (contact) {
              ref.read(contactListProvider.notifier).update(contact);
              KlleonSnackBar.show(context, "수정 성공");
            },
            updateFailure: (error) {
              KlleonSnackBar.show(context, "수정 실패");
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    contactListener();
    return Scaffold(
      appBar: AppBar(
        title: Text('연락처'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go("${ScreenPath.contact}/new");
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          // 아이템 수정시에는 ListView 전체를 다시 그리지않도록 length를 구독
          final contactCount = ref.watch(
            contactListProvider.select((s) => s.contacts.length),
          );

          // 로딩중 상태 구독
          final isLoading = ref.watch(
            contactListProvider.select((s) => s.isLoading),
          );

          // 더 불러올게 있는 상태인지 구독
          final hasMore = ref.watch(
            contactListProvider.select((s) => s.hasMore),
          );
          if (isLoading && contactCount == 0) {
            // 초기 로딩 중
            return const Center(child: CircularProgressIndicator());
          }
          if (contactCount == 0) {
            // 연락처가 하나도 없을 때
            return const Center(child: Text('연락처가 없습니다.'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: contactCount + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == contactCount) {
                // 리스트 가장 하단 더 불러오기 중 위젯
                return const Center(child: CircularProgressIndicator());
              }

              final contact = ref
                  .read(contactListProvider.notifier)
                  .getContactByIndex(index);

              return _ContactItem(
                key: ValueKey(contact.id),
                contactId: contact.id,
              );
            },
          );
        },
      ),
    );
  }
}

class _ContactItem extends ConsumerWidget {
  final String contactId;

  const _ContactItem({super.key, required this.contactId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(
      contactListProvider.select((value) {
        return value.contacts.singleWhereOrNull(
          (element) => element.id == contactId,
        );
      }),
    );

    if (contact == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(contact.name), Text(contact.phone)],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.go("${ScreenPath.contact}/${contact.id}");
            },
          ),
        ],
      ),
    );
  }
}
