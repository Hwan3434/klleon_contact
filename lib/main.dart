import 'package:di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klleon/klleon_theme_widget.dart';

void main() {
  setupDi();
  runApp(ProviderScope(child: const KlleonApp()));
}

class KlleonApp extends StatelessWidget {
  const KlleonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KlleonThemeWidget();
  }
}
