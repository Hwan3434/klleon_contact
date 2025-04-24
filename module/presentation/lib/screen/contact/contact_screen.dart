import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/screen/contact/contact_detail_provider.dart';

import 'contact_provider.dart';

typedef GoContactDetailCallback = void Function(String? contactId);

class ContactScreen extends ConsumerStatefulWidget {
  final GoContactDetailCallback? onPressed;
  const ContactScreen({super.key, this.onPressed});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // 바닥 근처 도달 시 다음 페이지 요청
        ref.read(contactProvider.notifier).more();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      contactProvider.select((value) {
        return value.event;
      }),
      (prev, next) {
        final event = next;
        if (event != null) {
          event.when(
            createSuccess: (contact) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("생성 성공")));
            },
            createFailure: (error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("생성 실패")));
            },
            deleteSuccess: (contact) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("삭제 성공")));
            },
            deleteFailure: (error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("삭제 실패")));
            },
            updateSuccess: (contact) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("수정 성공")));
            },
            updateFailure: (error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("수정 실패")));
            },
          );
        }
        // 다른 이벤트 핸들링
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('연락처'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              widget.onPressed?.call(null);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          // 아이템 수정시에는 ListView 다시 그리지않도록 length 구독
          final contactCount = ref.watch(
            contactProvider.select((s) => s.contacts.length),
          );

          // 로딩중 상태 구독
          final isLoading = ref.watch(
            contactProvider.select((s) => s.isLoading),
          );

          // 더 불러올게 있는 상태인지 구독
          final hasMore = ref.watch(contactProvider.select((s) => s.hasMore));
          if (isLoading && contactCount == 0) {
            // 초기 로딩 중
            return const Center(child: CircularProgressIndicator());
          }
          if (contactCount == 0) {
            // 연락처가 없을 때
            return const Center(child: Text('연락처가 없습니다.'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: contactCount + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == contactCount) {
                // 더 불러오기 중 위젯
                return const Center(child: CircularProgressIndicator());
              }

              final contact = ref
                  .read(contactProvider.notifier)
                  .getContact(index);

              return _ContactItem(
                key: ValueKey(contact.id),
                contactId: contact.id,
                onPressed: widget.onPressed,
              );
            },
          );
        },
      ),
    );
  }
}

class _ContactItem extends ConsumerWidget {
  final GoContactDetailCallback? onPressed;
  final String contactId;

  const _ContactItem({super.key, required this.contactId, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(contactDetailProvider(contactId))!;
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
              onPressed?.call(contact.id);
            },
          ),
        ],
      ),
    );
  }
}
