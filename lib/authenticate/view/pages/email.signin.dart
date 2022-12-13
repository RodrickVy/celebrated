import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/pages/task.stage.pages.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';


class CompleteEmailSignIn extends AdaptiveUI {
  static String emailLink = '';
  static String email = '';

   CompleteEmailSignIn({super.key}){
     FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.auth, isOn: true);
  }

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {



    return FutureBuilder(
      future: authService.completeEmailSign(email, emailLink),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      if(snapshot.hasData){
        FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.auth, isOn: false);
      }
      if(snapshot.hasData && snapshot.data == true && FeedbackService.appNotification.value == null){
        FeedbackService.announce(notification: AppNotification(title: "Sign in failed, you dont have an account created.",message: "Sign in failed, you dont have an account created.",));
      }
      return FeedbackSpinner(
        spinnerKey: FeedbackSpinKeys.auth,
        child: Container(
          height: adapter.height,
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          width: adapter.width,
          color: Colors.white,
          child: SizedBox(
            width: 340,
            height: Get.height,
            child: ListView(padding: const EdgeInsets.all(12), children: [
              if(snapshot.hasData && snapshot.data == true)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your email has been verified",
                  style: adapter.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              if((snapshot.hasData && snapshot.data != true )|| snapshot.hasError)
                const TaskFailed(title: "Oops! No luck , try another sign in method",image: "assets/intro/server_error.png",),
              if(!snapshot.hasData && !snapshot.hasError)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "verifying",
                    style: adapter.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              )
            ]),
          ),
        ),
      );
    },);


  }

}

class InitiateEmailSignIn extends AdaptiveUI {
  const InitiateEmailSignIn({Key? key}) : super(key: key);

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
                  "A link has been sent to ${UIFormState.email}, Check spam folder if you can't find it. Click that link to sign in. ",
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
                
                isTextButton:true,
                onPressed: () async {
                  navService.back();
                },

                child: Text(
                  "back",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                loadStateKey:FeedbackSpinKeys.auth ,
                isTextButton: true,
                onPressed: () async {

                  await authService.sendSignInLink(UIFormState.email);

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
              UIFormState.emailField,
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              AppButton(
                minWidth: Get.width,
                loadStateKey: FeedbackSpinKeys.auth,
                onPressed: () async {
                  bool success = await authService.sendSignInLink(UIFormState.email);
                  if(success){
                    navService.routeToParameter('stage', '1');
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
                minWidth: Get.width,
                onPressed: () async {
                  navService.routeKeepNext(AppRoutes.authSignIn);
                },
                isTextButton: true,
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
        minWidth: Get.width,
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