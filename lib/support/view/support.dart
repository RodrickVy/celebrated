import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/domain/view/page.view.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportView extends AppView<AuthController> {
   SupportView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptives adapter}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Support",
          style: GoogleFonts.caveat(
            fontSize: 38,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "coming soon...",
            style: GoogleFonts.caveat(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),

      ],
    );
  }
}
