import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/screen/contact/contact_detail_provider.dart';

class ContactDetailScreen extends ConsumerWidget {
  final int contactId;
  final VoidCallback? onPressed;
  const ContactDetailScreen({required this.contactId, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(contactDetailProvider(contactId));
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: onPressed,
          child: Text('${contact.name}'),
        ),
      ),
    );
  }
}
