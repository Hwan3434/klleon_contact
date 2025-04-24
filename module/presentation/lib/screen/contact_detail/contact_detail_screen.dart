import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:presentation/screen/contact/contact_detail_provider.dart';
import 'package:presentation/screen/contact/contact_provider.dart';
import 'package:uuid/uuid.dart';

enum ContactDetailMode { create, edit }

class ContactDetailScreen extends ConsumerWidget {
  final String? contactId;
  final ContactDetailMode mode;
  const ContactDetailScreen({super.key, required this.contactId})
    : mode =
          contactId == null ? ContactDetailMode.create : ContactDetailMode.edit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact =
        contactId == null ? null : ref.watch(contactDetailProvider(contactId!));

    if (contactId != null && contact == null) {
      return Scaffold(body: Center(child: Text("알 수 없는 연락처 입니다.")));
    }

    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController = TextEditingController(text: contact?.phone ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(mode == ContactDetailMode.create ? '새 연락처' : '연락처 수정'),
        actions: [
          if (mode == ContactDetailMode.edit)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (contactId != null) {
                  ref.read(contactProvider.notifier).deleteContact(contactId!);
                  context.pop();
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: '이름'),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: '전화번호'),
          ),
          ElevatedButton(
            onPressed: () {
              final uuid = Uuid();

              final newContact = Contact(
                id: contactId ?? uuid.v4(),
                name: nameController.text,
                phone: phoneController.text,
              );
              if (contactId == null) {
                ref.read(contactProvider.notifier).createContact(newContact);
              } else {
                ref.read(contactProvider.notifier).updateContact(newContact);
              }
            },
            child: Text(mode == ContactDetailMode.create ? '추가하기' : '수정하기'),
          ),
        ],
      ),
    );
  }
}
