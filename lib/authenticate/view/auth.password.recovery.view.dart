import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.state.view.dart';
import 'package:bremind/domain/view/app.text.field.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/view/feedback.spinner.dart';

import 'package:bremind/support/view/notification.view.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// view for recovering password,
// ignore: must_be_immutable
class RecoverPasswordView extends AppStateView<AuthController> {
  final TextEditingController emailTextController = TextEditingController();

  RecoverPasswordView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: SizedBox(
        width: 320,
        child: FeedbackSpinner(
            onSpinEnd: () {},
            spinnerKey: FeedbackSpinKeys.passResetForm,
            onSpinStart: () {},
            child: Container(
              padding: const EdgeInsets.all(10 / 2),
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Form(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppTextField(
                        fieldIcon: Icons.email,
                        label: "Email",
                        hint: "eg. john@email.com",
                        controller: emailTextController,
                        key: UniqueKey(),
                        keyboardType: TextInputType.emailAddress,
                        autoFillHints: const [AutofillHints.email],
                      ),
                      const SizedBox(height: 10),
                      const NotificatonsView(),
                      AppButton(
                        key: UniqueKey(),
                        child: Text(
                          "Reset-Password",
                          style: GoogleFonts.mavenPro(),
                        ),
                        onPressed: () async {
                          FeedbackService.spinnerUpdateState(
                              key: FeedbackSpinKeys.passResetForm, isOn: true);
                          await controller.sendPasswordResetEmail(
                            email: emailTextController.value.text,
                          );

                          FeedbackService.spinnerUpdateState(
                              key: FeedbackSpinKeys.passResetForm, isOn: false);
                        },
                      ),
                    ]),
              ),
            )),
      ),
    );
  }
}
