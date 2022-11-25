import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/domain/view/app.text.field.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class VerifyEmailView extends AppStateView<AuthController> {
  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.email_rounded),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("A link has been sent to your email,go open that link to verify your email."),
        ),
        AppButton(key: UniqueKey(),label: "Resend Link", onPressed: () {

        })
      ],
    );
  }
}
