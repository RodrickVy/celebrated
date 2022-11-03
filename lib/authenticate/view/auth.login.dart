import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.state.view.dart';
import 'package:bremind/domain/view/app.text.field.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/view/feedback.spinner.dart';

import 'package:bremind/support/view/notification.view.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth.button.dart';

/// a login form , for authentication
/// Uses the feedback spinner for actions as well as local [NotificatonsView] for errors,warning.
// ignore: must_be_immutable
class LoginFormView extends AppStateView<AuthController> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  LoginFormView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: SizedBox(
        width: 320,
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            // ProviderButtons(
            //   key: UniqueKey(),
            // ),
            FeedbackSpinner(
              spinnerKey: FeedbackSpinKeys.signInForm,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          fieldIcon: Icons.vpn_key,
                          label: "Password",
                          hint: "minimum 6 characters",
                          controller: passwordTextController,
                          key: UniqueKey(),
                          obscureOption: true,
                          keyboardType: TextInputType.visiblePassword,
                          autoFillHints: const [AutofillHints.password],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const NotificatonsView(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppButton(
                                label: "forgot password?",
                                isTextButton: true,
                                key: UniqueKey(),
                                onPressed: () {
                                  NavController.instance
                                      .to(AppRoutes.authPasswordReset);
                                }),
                          ],
                        ),
                        AppButton(
                          key: UniqueKey(),
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          onPressed: () async {
                            FeedbackService.spinnerUpdateState(
                                key: FeedbackSpinKeys.signInForm, isOn: true);
                            await controller.signInWithEmail(
                                email: emailTextController.value.text,
                                password: passwordTextController.value.text);
                            FeedbackService.spinnerUpdateState(
                                key: FeedbackSpinKeys.signInForm, isOn: false);
                          },
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
