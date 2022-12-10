import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/authenticate/view/components/provider.buttons.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/text.dart';
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
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synchronized_keyboard_listener/synchronized_keyboard_listener.dart';

/// a login form , for authentication
/// Uses the feedback spinner for actions as well as local [NotificationsView] for errors,warning.
// ignore: must_be_immutable
class SignInPage extends AdaptiveUI {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 340,
        height: Get.height,
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            FeedbackSpinner(
              spinnerKey: FeedbackSpinKeys.auth,
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

  void nextStage() {
    if (currentIndex < 2) {
      if (validateCurrentStage() == null) {
        navService.routeToParameter('stage', '${currentIndex + 1}');
      } else {}
    }
  }

  void previousStage() {
    if (currentIndex > 0) {
      navService.routeToParameter('stage', '${currentIndex - 1}');
    }
  }

  Column stageView(Adaptive adapter) {
    switch (currentIndex) {
      case 1:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              const Heading("Sign in"),
              const SizedBox(
                height: 10,
              ),
              UIFormState.passwordField,
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                      label: "forgot password?",
                      isTextButton: true,
                      onPressed: () {
                        navService.routeKeepNext(AppRoutes.authPasswordReset);
                      }),
                ],
              ),
              signInButton,
              const SizedBox(
                height: 8,
              ),
              backButton,
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    width: 200,
                    height: 0.5,
                    color: Colors.black12,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              if (GetPlatform.isDesktop) UIFormState.emailLinkButton,
              const SizedBox(
                height: 5,
              ),
              signUpButton,
              const SizedBox(
                height: 20,
              ),
            ]);

      case 0:
      default:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Heading(
                "Sign in",
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UIFormState.emailField,
              ),
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              nextButton,
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    width: 200,
                    height: 0.5,
                    color: Colors.black12,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              if (GetPlatform.isDesktop) UIFormState.emailLinkButton,
              const SizedBox(
                height: 10,
              ),
              signUpButton,
              const SizedBox(
                height: 5,
              ),
            ]);
    }
  }

  String? validateCurrentStage() {
    switch (currentIndex) {
      case 0:
        return Validators.emailFormValidator.announceValidation(UIFormState.email.value);

      case 1:
        return Validators.passwordValidator.announceValidation(UIFormState.password.value);
    }
    return null;
  }

  AppButton get nextButton {
    return AppButton(
      minWidth: Get.width,
      onPressed: () async {
        nextStage();
      },
      child: Text(
        "next",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
    );
  }

  AppButton get backButton {
    return AppButton(
      minWidth: Get.width,
      isTextButton: true,
      child: Text(
        "Back",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      onPressed: () async {
        previousStage();
      },
    );
  }

  static AppButton get signInButton {
    return AppButton(
      minWidth: Get.width,
      loadStateKey: FeedbackSpinKeys.auth,
      onPressed: () async {
        await authService.signIn(UIFormState.signInFormData);
      },
      child: Text(
        "Sign in",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
    );
  }

  static AppButton get signUpButton {
    return AppButton(
      minWidth: Get.width,
      isTextButton: true,
      onPressed: () async {
        navService.routeKeepNext(AppRoutes.authSignUp);
      },
      child: const Text(
        "Create an account",
      ),
    );
  }
}
