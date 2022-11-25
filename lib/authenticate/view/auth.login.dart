import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/domain/view/app.text.field.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';

import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth.button.dart';

/// a login form , for authentication
/// Uses the feedback spinner for actions as well as local [NotificatonsView] for errors,warning.
// ignore: must_be_immutable
class SignInPage extends AppStateView<AuthController> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  SignInPage({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 320,
        height: Get.height,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AppTextField(
                          fieldIcon: Icons.email,
                          label: "Email",
                          hint: "eg. john@email.com",
                          controller: emailTextController,
                          key: UniqueKey(),
                          keyboardType: TextInputType.emailAddress,
                          autoFillHints: const [AutofillHints.email,AutofillHints.username],
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
                        const SizedBox(
                          height: 10,
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
                        const SizedBox(
                          height: 10,
                        ),
                        AppButton(
                          key: UniqueKey(),
                          isTextButton: true,
                          onPressed: () async {
                            Get.toNamed(AppRoutes.authSignUp);
                          },
                          child: Text(
                            "create account",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
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
