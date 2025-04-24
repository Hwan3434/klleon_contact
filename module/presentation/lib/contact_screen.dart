import 'package:flutter/material.dart';

typedef GoContactDetailCallback = void Function(String contactId);

class ContactScreen extends StatelessWidget {
  final GoContactDetailCallback? onPressed;
  const ContactScreen({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {},
          child: const Text('ContactScreen'),
        ),
      ),
    );
  }
}
