import 'package:flutter/material.dart';

class AppSwatch {
  const AppSwatch();

  static const MaterialColor primary =
      MaterialColor(primaryValue, <int, Color>{
    50: Color(0xFFFFF8E4),
    100: Color(0xFFFEEDBB),
    200: Color(0xFFFEE18D),
    300: Color(0xFFFDD45F),
    400: Color(0xFFFCCB3D),
    500: Color(primaryValue),
    600: Color(0xFFFCBC18),
    700: Color(0xFFFBB414),
    800: Color(0xFFFBAC10),
    900: Color(0xFFFA9F08),
  });
  static const int primaryValue = 0xFFFCC21B;

  static const MaterialColor appswatchAccent =
      MaterialColor(accentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(accentValue),
    400: Color(0xFFFFE3BC),
    700: Color(0xFFFFD9A2),
  });
  static const int accentValue = 0xFFF5E9C6;
}
