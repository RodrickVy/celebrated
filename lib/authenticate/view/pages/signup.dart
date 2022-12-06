import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/heading.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// auth sign up form , for authentication this is not a page just the form.
// ignore: must_be_immutable
class SignUpPage extends AdaptiveUI {
  const SignUpPage({Key? key}) : super(key: key);

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
              height: 50,
            ),
            FeedbackSpinner(
              spinnerKey: FeedbackSpinKeys.auth,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  child: stageView(adapter),
                ),
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
      case 0:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // AuthProviderButtons(key: UniqueKey()),
              const Heading("Lets sign up, Whats ur name?"),
              const SizedBox(
                height: 10,
              ),
              UIFormState.nameField,
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              nextButton,
              UIFormState.signInButton,

            ]);
      case 1:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("  Hey  ${UIFormState.signUpFormData.name}"),
              const Heading("What's ur email?"),
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
              backButton,
              UIFormState.signInButton
            ]);
      case 2:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Heading("Set a password"),
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
              nextButton,
              backButton,
              UIFormState.signInButton
            ]);
      case 3:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Heading("When's your birthday?"),
              const SizedBox(
                height: 10,
              ),
              UIFormState.dateField,
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              nextButton,
              backButton,
              UIFormState.signInButton
            ]);
      case 4:
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Heading("Set your phone number"),
            const SizedBox(
              height: 10,
            ),
            UIFormState.phoneField,
            const SizedBox(
              height: 10,
            ),
            const NotificationsView(),
            const SizedBox(
              height: 10,
            ),
            UIFormState.signUpButton,
            backButton,
            UIFormState.signInButton,
          ]);

    }
  }




  AppButton get nextButton {

    return AppButton(
      key: UniqueKey(),
      onPressed: () async {
        if (currentIndex < 4) {
          if(validateCurrentStage() == null){
            navService.withParameter('stage','${currentIndex + 1}');
          }else{

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


  String? validateCurrentStage() {
    switch (currentIndex) {
      case 0:
        return Validators.userNameValidator.announceValidation(UIFormState.name.value);

      case 1:

        return Validators.emailFormValidator.announceValidation(UIFormState.email.value);

      case 2:
        return Validators.passwordValidator.announceValidation(UIFormState.password.value);

      case 3:
        return Validators.birthdayValidator.announceValidation(UIFormState.birthdate.value);

      case 4:
        return Validators.phoneValidator.announceValidation(UIFormState.phoneNumber.value);
    }
    return null;
  }




}
