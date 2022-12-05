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
class EmailVerifier extends AdaptiveUI {
  const EmailVerifier({Key? key}) : super(key: key);

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

  AppTextField get codeField => AppTextField(
        fieldIcon: Icons.key_sharp,
        label: "Code",
        hint: "f43hkl",
        autoFocus: true,
        controller: TextEditingController(text: UIFormState.authCode.value),
        onChanged: (data) {
          UIFormState.authCode(data.trim());
        },
        key: UniqueKey(),
        keyboardType: TextInputType.visiblePassword,
        autoFillHints: const [AutofillHints.oneTimeCode],
      );

  Column stageView(Adaptive adapter) {
    switch (currentIndex) {
      case 1:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              heading("Code sent to your email", adapter),
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
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "A code has been sent to ${UIFormState.email.value}, Check spam folder if you can't find it. Paste that code below to verify your email. ",
                  style: adapter.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              codeField,
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                key: UniqueKey(),
                child: Text(
                  "Confirm",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                onPressed: () async {
                  FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: true);
                  //bool success = await authService.sendSignInLink(UIFormState.email.value);

                  bool success = await  authService.verifyEmailCode(UIFormState.authCode.value);
                  Get.log("Sending was success: $success");
                  if (success &&  !navService.toNextIfAny()) {
                    navService.to(AppRoutes.lists);
                  }
                  FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: false);

                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                key: UniqueKey(),
                isTextButton: true,
                onPressed: () async {
                  navService.to('${AppRoutes.verifyEmail}?stage=0');
                },
                child: Text(
                  "Resend it",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
              signUpButton
            ]);
      case 0:
      default:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              heading("Lets confirm your email", adapter),
              const SizedBox(
                height: 10,
              ),
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
              Obx(
                () => Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    authService.accountUser.value.email,
                    style: adapter.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              AppButton(
                key: UniqueKey(),
                onPressed: () async {
                  FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: true);
                  bool success = await authService.sendVerificationCode();
                  Get.log("Sending was success: $success");
                  FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: false);
                  if (success) {
                    navService.to("${AppRoutes.verifyEmail}?stage=1");
                  }
                },
                child: Text(
                  "Send Confirmation Code",
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
