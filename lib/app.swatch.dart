import 'package:flutter/material.dart';

class AppSwatch {
  const AppSwatch();

  static const MaterialColor appswatch =
      MaterialColor(_appswatchPrimaryValue, <int, Color>{
    50: Color(0xFFFFF8E4),
    100: Color(0xFFFEEDBB),
    200: Color(0xFFFEE18D),
    300: Color(0xFFFDD45F),
    400: Color(0xFFFCCB3D),
    500: Color(_appswatchPrimaryValue),
    600: Color(0xFFFCBC18),
    700: Color(0xFFFBB414),
    800: Color(0xFFFBAC10),
    900: Color(0xFFFA9F08),
  });
  static const int _appswatchPrimaryValue = 0xFFFCC21B;

  static const MaterialColor appswatchAccent =
      MaterialColor(_appswatchAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_appswatchAccentValue),
    400: Color(0xFFFFE3BC),
    700: Color(0xFFFFD9A2),
  });
  static const int _appswatchAccentValue = 0xFFFFF8EF;
}
