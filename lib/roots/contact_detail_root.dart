import 'package:flutter/material.dart';
import 'package:presentation/contact_detail_screen.dart';

class ContactDetailRoot extends StatelessWidget {
  final VoidCallback? onPressed;
  const ContactDetailRoot({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ContactDetailScreen(onPressed: onPressed);
  }
}
