import 'package:flutter/material.dart';

class ContactDetailScreen extends StatelessWidget {
  final VoidCallback? onPressed;
  const ContactDetailScreen({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: onPressed,
          child: const Text('ContactDetailRoot'),
        ),
      ),
    );
  }
}
