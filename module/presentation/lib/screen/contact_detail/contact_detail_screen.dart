import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:presentation/screen/contact/contact_detail_provider.dart';
import 'package:presentation/screen/contact/contact_provider.dart';
import 'package:uuid/uuid.dart';

enum ContactDetailMode { create, edit }

class ContactDetailScreen extends ConsumerStatefulWidget {
  final String? contactId;
  final ContactDetailMode mode;
  const ContactDetailScreen({super.key, required this.contactId})
    : mode =
          contactId == null ? ContactDetailMode.create : ContactDetailMode.edit;

  @override
  ConsumerState<ContactDetailScreen> createState() =>
      _ContactDetailScreenState();
}

class _ContactDetailScreenState extends ConsumerState<ContactDetailScreen> {
  Contact? contact;
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ref.watch는 여기서 사용 가능!
    if (widget.contactId != null) {
      final contact = ref.watch(contactDetailProvider(widget.contactId!));
      if (contact != null) {
        nameController.text = contact.name;
        phoneController.text = contact.phone;
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contact =
        widget.contactId == null
            ? null
            : ref.watch(contactDetailProvider(widget.contactId!));

    if (widget.contactId != null && contact == null) {
      return Scaffold(body: Center(child: Text("알 수 없는 연락처 입니다.")));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == ContactDetailMode.create ? '새 연락처' : '연락처 수정',
        ),
        actions: [
          if (widget.mode == ContactDetailMode.edit)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (widget.contactId != null) {
                  ref
                      .read(contactProvider.notifier)
                      .deleteContact(widget.contactId!);
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
                id: widget.contactId ?? uuid.v4(),
                name: nameController.text,
                phone: phoneController.text,
              );
              if (widget.contactId == null) {
                ref.read(contactProvider.notifier).createContact(newContact);
                context.pop();
              } else {
                ref.read(contactProvider.notifier).updateContact(newContact);
                context.pop();
              }
            },
            child: Text(
              widget.mode == ContactDetailMode.create ? '추가하기' : '수정하기',
            ),
          ),
        ],
      ),
    );
  }
}
