import 'package:flutter/material.dart';
import 'package:klleon/klleon_router_widget.dart';

class CustomThemeData {
  static final ThemeData light = ThemeData.light().copyWith();
  static final ThemeData dark = ThemeData.dark().copyWith();
}

// 테마 관리 위젯
class KlleonThemeWidget extends StatelessWidget {
  const KlleonThemeWidget();

  @override
  Widget build(BuildContext context) {
    /// TODO Theme Riverpod 추가
    return KlleonRouterWidget(themeMode: ThemeMode.light);
  }
}
