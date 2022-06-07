import 'package:bremind/app.swatch.dart';
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
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(systemNavigationBarColor: AppSwatch.primary.shade700,statusBarColor:AppSwatch.primary.shade700),);
    return GetMaterialApp(
      title: 'breminder',
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: AppSwatch.primary),
          textTheme: TextTheme(
            headline1: GoogleFonts.inter(
                fontSize: 93, fontWeight: FontWeight.w300, letterSpacing: -1.5),
            headline2: GoogleFonts.inter(
                fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5),
            headline3:
                GoogleFonts.inter(fontSize: 46, fontWeight: FontWeight.w400),
            headline4: GoogleFonts.inter(
                fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            headline5:
                GoogleFonts.inter(fontSize: 23, fontWeight: FontWeight.w400),
            headline6: GoogleFonts.inter(
                fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
            subtitle1: GoogleFonts.inter(
                fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15),
            subtitle2: GoogleFonts.inter(
                fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
            bodyText1: GoogleFonts.lato(
                fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.5),
            bodyText2: GoogleFonts.lato(
                fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            button: GoogleFonts.lato(
                fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 1.25),
            caption: GoogleFonts.lato(
                fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
            overline: GoogleFonts.lato(
                fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
          )),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("breminder  "),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset("assets/b-reminder-full-logo.png",width: 150,),
        ),
      ),
    );
  }
}
