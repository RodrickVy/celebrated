import 'package:celebrated/app.swatch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
      //accentColor: AppSwatch.primary.shade500
      colorScheme: ColorScheme.fromSwatch(primarySwatch: AppSwatch.primary, accentColor: AppSwatch.primaryAccent)
          .copyWith(
              primary: AppSwatch.primary[500],
              onPrimary: Colors.black,
              secondary: AppSwatch.primary[300],
              onSecondary: Colors.black,
              background: Colors.white,
              onBackground: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
              onError: Colors.black,
              error: Colors.red,
              shadow: Colors.black),
      tabBarTheme: const TabBarTheme(
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.black
      ),
      indicatorColor: AppSwatch.primary.shade300,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppSwatch.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        // backgroundColor: const Color(0xFFCDBA57)
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              // primary:            const Color(0xFFCDBA57),
              foregroundColor: Colors.black)),
      buttonTheme: const ButtonThemeData(/* const Color(0xFFCDBA57)*/),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppSwatch.primary.shade500,
      ),
      textTheme: TextTheme(
        headline1:
            GoogleFonts.inter(fontSize: 93, fontWeight: FontWeight.w300, color: Colors.black, letterSpacing: -1.5),
        headline2:
            GoogleFonts.inter(fontSize: 58, fontWeight: FontWeight.w300, color: Colors.black, letterSpacing: -0.5),
        headline3: GoogleFonts.playfairDisplay(color: Colors.black, fontSize: 46, fontWeight: FontWeight.w400),
        headline4: GoogleFonts.playfairDisplay(
            fontSize: 33, fontWeight: FontWeight.w400, color: Colors.black, letterSpacing: 0.25),
        headline5: GoogleFonts.playfairDisplay(color: Colors.black, fontSize: 23, fontWeight: FontWeight.w400),
        headline6:
            GoogleFonts.inter(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.black, letterSpacing: 0.15),
        subtitle1: GoogleFonts.playfairDisplay(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black, letterSpacing: 0.15),
        subtitle2:
            GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black, letterSpacing: 0.1),
        bodyText1:
            GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black, letterSpacing: 0.5),
        bodyText2:
            GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black, letterSpacing: 0.25),
        button: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black, letterSpacing: 1.25),
        caption: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black, letterSpacing: 0.4),
        overline: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black, letterSpacing: 1.5),
      ));

  static double borderRadius = 12;

  static double borderRadius2 = 24;

  static InputDecoration get inputDecoration => InputDecoration(
        focusColor: Colors.black12,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
        labelStyle: Get.theme.textTheme.bodyText2!.copyWith(color: Colors.black),
        contentPadding: const EdgeInsets.all(8).copyWith(left: 15),
        hintStyle: Get.theme.textTheme.bodyText2!.copyWith(color: Colors.black),
        //fillColor: Colors.green
      );

  static InputDecoration get inputDecorationNoBorder => inputDecoration.copyWith(
    border:  OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.zero),
    focusedBorder:  OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.zero),
  );

  static RoundedRectangleBorder get shape =>
      RoundedRectangleBorder(side: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(12)
          //fillColor: Colors.green
          );

  static BoxDecoration get boxDecoration =>
      BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.fromBorderSide(AppTheme.shape.side));
  static LinearGradient gradient = LinearGradient(colors: [AppSwatch.primary.shade600, AppSwatch.primary.shade400]);
  static LinearGradient lightGradient = LinearGradient(
      colors: [AppSwatch.primary.shade400, AppSwatch.primaryAccent.shade700],
      begin: Alignment.topCenter,
      end: Alignment.bottomRight);
  static LinearGradient darkGradient = LinearGradient(colors: [AppSwatch.primary.shade700, AppSwatch.primary.shade700]);
}
