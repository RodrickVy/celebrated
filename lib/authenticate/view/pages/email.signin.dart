import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
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



class CompleteEmailSignIn extends AdaptiveUI {
  static String emailLink = '';
  static String email = '';

   CompleteEmailSignIn({super.key}){
     FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.auth, isOn: true);
  }

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {



    return FutureBuilder(
      future: authService.handleSignInLink(email, emailLink),
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
            width: 320,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Sorry, something went wrong",
                    style: adapter.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
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
              ),
              AppButton(
                key: UniqueKey(),
                child: Text(
                  "Continue",
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                onPressed: () async {
                  if(!navService.nextRouteExists){
                    navService.toNextRoute();
                  }else{
                    navService.to(AppRoutes.authSignIn);
                  }
                },
              ),
            ]),
          ),
        ),
      );
    },);


  }

}

