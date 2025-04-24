import 'package:flutter/material.dart';
import 'package:presentation/contact_screen.dart';

class ContactRoot extends StatelessWidget {
  final GoContactDetailCallback? onPressed;
  const ContactRoot({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ContactScreen(onPressed: onPressed);
  }
}
