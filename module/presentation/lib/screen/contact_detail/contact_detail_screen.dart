import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:presentation/screen/contact/contact_detail_provider.dart';
import 'package:presentation/screen/contact/contact_provider.dart';
import 'package:uuid/uuid.dart';

class ContactDetailScreen extends ConsumerWidget {
  final String? contactId;
  const ContactDetailScreen({super.key, this.contactId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact =
        contactId != null ? ref.watch(contactDetailProvider(contactId!)) : null;

    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController = TextEditingController(text: contact?.phone ?? '');

    return Scaffold(
      appBar: AppBar(title: Text(contactId == null ? '새 연락처' : '연락처 수정')),
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
              context.pop();
            },
            child: Text(contactId == null ? '추가하기' : '수정하기'),
          ),
        ],
      ),
    );
  }
}
