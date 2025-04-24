import 'package:flutter/material.dart';
import 'package:presentation/screen/splash/splash_screen.dart';

class SplashRoot extends StatelessWidget {
  final VoidCallback? onPressed;
  const SplashRoot({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(onPressed: onPressed);
  }
}
