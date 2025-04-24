import 'package:flutter/material.dart';
import 'package:presentation/screen/contact_detail/contact_detail_screen.dart';

class ContactDetailRoot extends StatelessWidget {
  final String? contactId;
  const ContactDetailRoot({required this.contactId});

  @override
  Widget build(BuildContext context) {
    return ContactDetailScreen(contactId: contactId);
  }
}
