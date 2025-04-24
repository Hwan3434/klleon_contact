import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback? onPressed;
  const SplashScreen({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: onPressed,
          child: const Text('App Start'),
        ),
      ),
    );
  }
}
