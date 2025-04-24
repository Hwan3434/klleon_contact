import 'package:flutter/material.dart';
import 'package:presentation/screen/contact_detail/contact_detail_screen.dart';

class ContactDetailRoot extends StatelessWidget {
  final int contactId;
  final VoidCallback? onPressed;
  const ContactDetailRoot({required this.contactId, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ContactDetailScreen(contactId: contactId, onPressed: onPressed);
  }
}
