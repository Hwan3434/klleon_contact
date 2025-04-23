import 'package:flutter/material.dart';

class SplashRoot extends StatelessWidget {
  final VoidCallback? onPressed;
  const SplashRoot({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: onPressed,
          child: const Text('Splash'),
        ),
      ),
    );
  }
}
