import 'package:celebrated/app.swatch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static ThemeData themeData = ThemeData(
      colorScheme:
      ColorScheme.fromSwatch(primarySwatch: AppSwatch.primary,accentColor: AppSwatch.primaryAccent).copyWith(
        //accentColor: AppSwatch.primary.shade500
         // background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        //   secondary: const Color(0xFFAF0149),
        // primary: Colors.white,
        // onPrimary: Colors.black,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppSwatch.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              primary: Colors.black,
              // backgroundColor: const Color(0xFFCDBA57)
          )
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              // primary:            const Color(0xFFCDBA57),
              onPrimary: Colors.black)
      ),
      buttonTheme:
      const ButtonThemeData(             /* const Color(0xFFCDBA57)*/),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppSwatch.primary.shade500,
      ),
      textTheme: TextTheme(
        headline1: GoogleFonts.inter(
            fontSize: 93,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            letterSpacing: -1.5),
        headline2: GoogleFonts.inter(
            fontSize: 58,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            letterSpacing: -0.5),
        headline3: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 46,
            fontWeight: FontWeight.w400),
        headline4: GoogleFonts.inter(
            fontSize: 33,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.25),
        headline5: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w400),
        headline6: GoogleFonts.inter(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            letterSpacing: 0.15),
        subtitle1: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.15),
        subtitle2: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            letterSpacing: 0.1),
        bodyText1: GoogleFonts.lato(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.5),
        bodyText2: GoogleFonts.lato(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.25),
        button: GoogleFonts.lato(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            letterSpacing: 1.25),
        caption: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.4),
        overline: GoogleFonts.lato(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 1.5),
      ));
}