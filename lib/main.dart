import 'package:bremind/app.bindings.dart';
import 'package:bremind/app.swatch.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/navigation/views/app.bottom.nav.bar.dart';
import 'package:bremind/splash/controller/splash.controller.dart';
import 'package:bremind/splash/view/splash.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: AppSwatch.primary.shade700,
          statusBarColor: AppSwatch.primary.shade700),
    );
    AppBindings().dependencies();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          GetMaterialApp(
            title: 'breminder',
            theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: AppSwatch.primary),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: AppSwatch.primary,
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black
                  )
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
                )),
            initialBinding: AppBindings(),
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            getPages: [
              GetPage(name: "/", page: () => AppIntro<IntroScreenController>()),
            ],
          ),
        ],
      ),
    );
  }
}
