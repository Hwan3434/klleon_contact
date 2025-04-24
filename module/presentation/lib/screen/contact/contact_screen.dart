import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/screen/contact/contact_detail_provider.dart';

import 'contact_list_provider.dart';

typedef GoContactDetailCallback = void Function(int contactId);

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
        ref.read(contactListProvider.notifier).more();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // contact 정보 구독
    final vm = ref.watch(contactListProvider);
    return Scaffold(
      appBar: AppBar(title: Text('연락처')),
      body: Builder(
        builder: (context) {
          // 연락처가 없을때
          if (vm.contacts.isEmpty) {
            // 최초 연락처 불러오기 중
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            // 에러로 떨어져도 isLoading을 false로 바꿔주기 때문에 여기선 가져온 연락처가 없음
            return Center(child: Text("연락처가 없습니다."));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: vm.contacts.length + (vm.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              // 더 불러오는 중 위젯
              if (index == vm.contacts.length && vm.hasMore) {
                return const Center(child: CircularProgressIndicator());
              }
              final id = vm.contacts[index].id;
              final contact = ref.watch(contactDetailProvider(id));
              return ListTile(
                key: ValueKey(contact.id),
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                onTap: () => widget.onPressed?.call(contact.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logger.d("FloatingActionButton clicked");
        },
      ),
    );
  }
}
