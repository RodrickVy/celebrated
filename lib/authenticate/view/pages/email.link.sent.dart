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
class EmailSignInForm extends AdaptiveUI {
  const EmailSignInForm({Key? key}) : super(key: key);

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
              spinnerKey: FeedbackSpinKeys.auth,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child:stageView(adapter),
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
      UIFormState.email(data.trim());
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
              heading("The Link has been sent", adapter),
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
                  "A link has been sent to ${UIFormState.email
                      .value}, Check spam folder if you can't find it. Click that link to sign in. ",
                  style: adapter.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
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
                  "back",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                onPressed: () async {
                  navService.back();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                key: UniqueKey(),
                isTextButton: true,
                onPressed: () async {
                  FeedbackService.spinnerDefineState(key: FeedbackSpinKeys.auth, isOn: true);
                  await authService.sendSignInLink(UIFormState.email.value);
                  FeedbackService.spinnerDefineState(key: FeedbackSpinKeys.auth, isOn: false);
                },
                child: Text(
                  "Resend Link it",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),

            ]);
      case 0:
      default:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              heading("Sign In with email Link", adapter),
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
                    () =>
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        authService.userLive.value.email,
                        style: adapter.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              emailField,
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              AppButton(
                key: UniqueKey(),
                onPressed: () async {
                  FeedbackService.spinnerDefineState(key: FeedbackSpinKeys.auth, isOn: true);
                  bool success = await authService.sendSignInLink(UIFormState.email.value);
                  FeedbackService.spinnerDefineState(key: FeedbackSpinKeys.auth, isOn: false);
                  if(success){
                    navService.withParam('stage', '1');
                  }
                },
                child: Text(
                  "Send Email Link",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AppButton(
                key: UniqueKey(),
                onPressed: () async {
                  navService.back();
                },
                child: Text(
                  "Back",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
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
          authService.logout();
        },
        child: Text(
          "Sign an as another account",
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