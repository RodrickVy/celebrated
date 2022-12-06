import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/heading.dart';
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
class SignInPage extends AdaptiveUI {
  const SignInPage({Key? key}) : super(key: key);

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
              spinnerKey: FeedbackSpinKeys.auth,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child:stageView(adapter),

                //
                // Form(
                //   child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         AppTextField(
                //           fieldIcon: Icons.email,
                //           label: "Email",
                //           hint: "eg. john@email.com",
                //           controller: TextEditingController(text: UIFormState.signInFormData.email),
                //           onChanged: (data) {
                //             UIFormState.email(data.trim());
                //           },
                //           keyboardType: TextInputType.emailAddress,
                //           autoFillHints: const [AutofillHints.email, AutofillHints.username],
                //         ),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         AppTextField(
                //           fieldIcon: Icons.vpn_key,
                //           label: "Password",
                //           hint: "minimum 6 characters",
                //           controller: TextEditingController(text: UIFormState.signInFormData.password),
                //           onChanged: (data) {
                //             Get.log("Password : $data");
                //             UIFormState.password(data);
                //           },
                //           obscureOption: true,
                //           keyboardType: TextInputType.visiblePassword,
                //           autoFillHints: const [AutofillHints.password],
                //         ),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         const NotificationsView(),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.end,
                //           children: [
                //             AppButton(
                //                 label: "forgot password?",
                //                 isTextButton: true,
                //                 key: UniqueKey(),
                //                 onPressed: () {
                //                   navService.to(AppRoutes.authPasswordReset);
                //                 }),
                //           ],
                //         ),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         AppButton(
                //           key: UniqueKey(),
                //           child: Text(
                //             "Sign In",
                //             style: GoogleFonts.poppins(fontSize: 16),
                //           ),
                //           onPressed: () async {
                //             FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: true);
                //             await authService.signIn(UIFormState.signInFormData);
                //             FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: false);
                //           },
                //         ),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //       ]),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int get currentIndex => int.parse(Get.parameters['stage'] ?? '0');



  Column stageView(Adaptive adapter) {
    switch (currentIndex) {
      case 1:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Heading("Enter your password"),
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
                      key: UniqueKey(),
                      onPressed: () {
                        navService.to(AppRoutes.authPasswordReset);
                      }),
                ],
              ),
              UIFormState.signInButton,
              backButton,
            ]);

      case 0:
      default:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Heading("Lets sign you in, Whats ur email?"),
              const SizedBox(
                height: 10,
              ),
              UIFormState.emailField,
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              nextButton,
              const SizedBox(
                height: 10,
              ),
              UIFormState.emailLinkButton,
              const Padding(
                padding:  EdgeInsets.all(8.0),
                child:  Center(child: Text("or",textAlign: TextAlign.center,)),
              ),
              UIFormState.signUpButton,

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
      key: UniqueKey(),
      minWidth: Get.width,
      onPressed: () async {

        if (currentIndex < 2) {
          if (validateCurrentStage() == null) {
            navService.withParameter('stage','${currentIndex + 1}');
          } else {

          }
        }
      },
      child: Text(
        "next",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
    );
  }

  AppButton get backButton {
    return AppButton(
      key: UniqueKey(),
      isTextButton: true,
      child: Text(
        "Back",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      onPressed: () async {
        if (currentIndex > 0) {
          navService.withParameter('stage','${currentIndex - 1}');
        }
      },
    );
  }

}