import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:presentation/common/contect_control_event_provider.dart';
import 'package:presentation/screen/contact_detail/contact_detail_provider.dart';
import 'package:presentation/screen/contact_detail/contact_detail_screen_type.dart';
import 'package:uuid/uuid.dart';

const createContactId = "new";

class ContactDetailScreen extends ConsumerStatefulWidget {
  final String? contactId;
  const ContactDetailScreen({super.key, required this.contactId});

  @override
  ConsumerState<ContactDetailScreen> createState() =>
      _ContactDetailScreenState();
}

class _ContactDetailScreenState extends ConsumerState<ContactDetailScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  /// DB 이벤트 변화 구독
  void changedContactEvent() {
    ref.listen(
      contactControlEventProvider.select((event) {
        return event;
      }),
      (previous, next) {
        final event = next;
        if (event != null) {
          event.when(
            createSuccess: (Contact contact) {
              context.pop();
            },
            createFailure: (Object error) {},
            updateSuccess: (Contact contact) {
              context.pop();
            },
            updateFailure: (Object error) {},
            deleteSuccess: (String contactId) {
              context.pop();
            },
            deleteFailure: (Object error) {},
          );
        }
      },
    );
  }

  void contactDetailListener() {
    final id = widget.contactId ?? createContactId;
    ref.listen(
      contactDetailProvider(id).select((value) {
        return value.event;
      }),
      (previous, next) {
        final event = next;
        if (event != null) {
          event.when(
            fetchSuccess: (contact) {
              nameController.text = contact.name;
              phoneController.text = contact.phone;
            },
            fetchError: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("새로운 연락처 만들기")));
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    changedContactEvent();
    contactDetailListener();

    final contactDetailState = ref.watch(
      contactDetailProvider(widget.contactId ?? createContactId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(contactDetailState.mode.appTitle),
        actions: [
          if (contactDetailState.mode == ContactDetailScreenType.update)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (contactDetailState.id != createContactId) {
                  final deleteId = contactDetailState.id;
                  ref
                      .read(contactDetailProvider(deleteId).notifier)
                      .deleteContact(ref, deleteId);
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
              if (widget.contactId == null) {
                ref
                    .read(contactDetailProvider(createContactId).notifier)
                    .createContact(
                      ref,
                      Contact(
                        id: Uuid().v4(),
                        name: nameController.text,
                        phone: phoneController.text,
                      ),
                    );
              } else {
                ref
                    .read(contactDetailProvider(widget.contactId!).notifier)
                    .updateContact(
                      ref,
                      Contact(
                        id: widget.contactId!,
                        name: nameController.text,
                        phone: phoneController.text,
                      ),
                    );
              }
            },
            child: Text(contactDetailState.mode.submitButtonText),
          ),
        ],
      ),
    );
  }
}
