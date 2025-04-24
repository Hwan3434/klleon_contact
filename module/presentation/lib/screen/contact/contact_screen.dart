import 'package:domain/domain.dart';
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
  Widget build(BuildContext context) {
    final contactCount = ref.watch(
      contactProvider.select((s) => s.contacts.length),
    );

    logger.d("_ContactScreenState build");

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
          logger.d("Temper build");
          final isLoading = ref.watch(
            contactProvider.select((s) => s.isLoading),
          );
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
              logger.d("Item build");
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
    logger.d("_ContactItem build : ${contactId}");
    ref.listen<Contact?>(contactDetailProvider(contactId), (previous, next) {
      if (previous != null && next != null) {
        if (previous.name != next.name) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${previous.name} → ${next.name} 변경됨')),
          );
        }
      }
    });
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
