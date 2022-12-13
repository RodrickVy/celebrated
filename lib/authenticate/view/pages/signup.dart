import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Heading("Lets sign you up",textAlign: TextAlign.center,),
              const SizedBox(
                height: 40,
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Container(
                    margin: const EdgeInsets.only(top: 20,bottom: 20),
                    width: 200,
                    height: 0.5,
                    color: Colors.black12,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              signInButton,
              const SizedBox(
                height: 10,
              ),
            ]);
      case 1:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               Heading(" Hey  ${UIFormState.signUpFormData.name} \n What's ur email?",textAlign: TextAlign.center,),
              const SizedBox(
                height: 40,
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Container(
                    margin: const EdgeInsets.only(top: 20,bottom: 20),
                    width: 200,
                    height: 0.5,
                    color: Colors.black12,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              signInButton,
              const SizedBox(
                height: 10,
              ),
            ]);
      case 2:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Heading("Set a password",textAlign: TextAlign.center,),
              const SizedBox(
                height: 40,
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Container(
                    margin: const EdgeInsets.only(top: 20,bottom: 20),
                    width: 200,
                    height: 0.5,
                    color: Colors.black12,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              signInButton,
              const SizedBox(
                height: 10,
              ),
            ]);
      case 3:
      default:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              const Heading("Almost done!",textAlign: TextAlign.center,),
              const SizedBox(
                height: 40,
              ),
              const BodyText("when's your birthday",textAlign: TextAlign.center,),
              UIFormState.dateField(),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: const [
                  BodyText("(optional)",textAlign: TextAlign.start,),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              UIFormState.phoneField,
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              signUpButton,
              backButton,
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Container(
                    margin: const EdgeInsets.only(top: 20,bottom: 20),
                    width: 200,
                    height: 0.5,
                    color: Colors.black12,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              signInButton,
              const SizedBox(
                height: 10,
              ),
            ]);
      // case 4:
      // default:
      //   return Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: <Widget>[
      //       const Heading("Set your phone number (optional)"),
      //
      //       const NotificationsView(),
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       signUpButton,
      //       backButton,
      //       const SizedBox(
      //         height: 20,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children:  [
      //           Container(
      //             margin: const EdgeInsets.only(top: 20,bottom: 20),
      //             width: 200,
      //             height: 0.5,
      //             color: Colors.black12,
      //           ),
      //         ],
      //       ),
      //       const SizedBox(
      //         height: 15,
      //       ),
      //       signInButton,
      //       const SizedBox(
      //         height: 10,
      //       ),
      //     ]);

    }
  }




  AppButton get nextButton {

    return AppButton(
      minWidth: Get.width,
      onPressed: () async {
        if (currentIndex < 4) {
          if(validateCurrentStage() == null){
            navService.routeToParameter('stage','${currentIndex + 1}');
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
      minWidth: Get.width,
      isTextButton: true,
      child: Text(
        "Back",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      onPressed: () async {
        if (currentIndex > 0) {
          navService.routeToParameter('stage','${currentIndex - 1}');
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
        return Validators.birthdayValidator.announceValidation(UIFormState.birthdate);

      case 4:
        return Validators.phoneValidator.announceValidation(UIFormState.phoneNumber.value);
    }
    return null;
  }


  static AppButton get signInButton {
    return AppButton(
      minWidth: Get.width,
      isTextButton: true,
      onPressed: () async {
        navService.routeKeepNext(AppRoutes.authSignIn);
      },
      child: Text(
        "Have an account? sign in",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
    );
  }

  static AppButton get signUpButton {
    return AppButton(
      minWidth: Get.width,
      loadStateKey: FeedbackSpinKeys.auth,
      onPressed: () async {
        await authService.signUp(UIFormState.signUpFormData);
      },
      child: const Text(
        "Sign Up",
      ),
    );
  }


}
