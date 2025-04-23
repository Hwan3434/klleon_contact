import 'package:flutter/material.dart';
import 'package:klleon/klleon_theme_widget.dart';
import 'package:logger/web.dart';

final logger = Logger();

void main() {
  runApp(KlleonApp());
}

class KlleonApp extends StatelessWidget {
  const KlleonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KlleonThemeWidget();
  }
}
