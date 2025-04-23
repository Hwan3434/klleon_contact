import 'package:flutter/material.dart';

class ContactDetailRoot extends StatelessWidget {
  final VoidCallback? onPressed;
  const ContactDetailRoot({required this.onPressed});

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
