import 'package:flutter/material.dart';
import 'package:klleon/router/contact_router.dart';

import 'klleon_theme_widget.dart';

// 라우터 관리 위젯
class KlleonRouterWidget extends StatelessWidget {
  final ThemeMode themeMode;
  const KlleonRouterWidget({required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: contactRouter,
      title: 'Flutter Demo',
      darkTheme: CustomThemeData.dark.copyWith(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      theme: CustomThemeData.light.copyWith(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      themeMode: themeMode,
    );
  }
}
