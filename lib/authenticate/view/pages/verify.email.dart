import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
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

/// a login form , for authentication
/// Uses the feedback spinner for actions as well as local [NotificationsView] for errors,warning.
// ignore: must_be_immutable
class VerifyEmail extends AdaptiveUI {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return  Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 320,
        height: Get.height,
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            FeedbackSpinner(
              spinnerKey: FeedbackSpinKeys.signInForm,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: stageView(adapter),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int get currentIndex => int.parse(Get.parameters['stage'] ?? '0');

  AppTextField get emailField => AppTextField(
    fieldIcon: Icons.email,
    label: "Email",
    hint: "eg. example@gmail.com",
    autoFocus: true,
    controller: TextEditingController(text: UIFormState.signInFormData.email),
    onChanged: (data) {
      UIFormState.email(data?.trim());
    },
    key: UniqueKey(),
    keyboardType: TextInputType.emailAddress,
    autoFillHints: const [AutofillHints.email, AutofillHints.username],
  );

  Column stageView(Adaptive adapter) {
    switch (currentIndex) {
      case 1:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              heading("Email Link Sent!", adapter),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                'assets/intro/email.png',
                width: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "A link has been sent to ${UIFormState.email.value}, click that link to sign in. Check spam folder if you can't find it.",
                  style: adapter.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                key: UniqueKey(),
                child: Text(
                  "Resend Link",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                onPressed: () async {
                  navService.to('${AppRoutes.verifyEmail}?stage=0');
                },
              ),
              signUpButton
            ]);
      case 0:
      default:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading("Lets verify your email", adapter),
              const SizedBox(
                height: 10,
              ),
              emailField,
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              AppButton(
                key: UniqueKey(),
                onPressed: () async {
                  FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: true);
                 //bool success = await authService.sendSignInLink(UIFormState.email.value);
                  // if (success) {
                  //   navService.to("${AppRoutes.verifyEmail}?stage=1");
                  // }
                  bool success =   await authService.sendVerificationCode();
                  Get.log("Sending was success: $success");
                  FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: false);
                },
                child: Text(
                  "Send Confirmation Link",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
              signUpButton
            ]);
    }
  }


  Widget get signUpButton {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: AppButton(
        key: UniqueKey(),
        isTextButton: true,
        onPressed: () async {
          navService.to(AppRoutes.authSignUp);
        },
        child: Text(
          "Or create account",
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ),
    );
  }

  Widget heading(String title, adapter) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: adapter.textTheme.headlineSmall),
    );
  }
}
