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

// enum ActionsMode { resetPassword, recoverEmail, verifyEmail, unknown }
// final Rx<bool?> emailVerificationSuccessful = Rx<bool?>(null);
// /// page showing the users birthdays , and enables the user to update the lists.
// class AuthActionsHandler extends AdaptiveUI {
//    AuthActionsHandler({Key? key}) : super(key: key){
//     // if(mode == ActionsMode.verifyEmail){
//     //   authService.handleSignInLink(code, continueUrl).then((value) {
//     //     emailVerificationSuccessful(value);
//     //   });
//     // }
//
//   }
//
//   ActionsMode get mode {
//     // Handle the user management action.
//     switch (Get.parameters['mode']) {
//       case 'resetPassword':
//         return ActionsMode.resetPassword;
//       case 'recoverEmail':
//         return ActionsMode.recoverEmail;
//       case 'verifyEmail':
//         return ActionsMode.verifyEmail;
//       default:
//         return ActionsMode.unknown;
//     }
//   }
//
//   String get code => Get.parameters['oobCode'] ?? '';
//
//   // (Optional) Get the continue URL from the query parameter if available.
//   static const String continueUrl = 'https://celebratedapp.com/sign_in';
//   // static final dynamicLinkParams = DynamicLinkParameters(
//   //   link: Uri.parse("https://celebratedapp.com/sign_in"),
//   //   uriPrefix: "https://celebratedapp.com/link",
//   //   androidParameters: const AndroidParameters(packageName: "com.rodrickvy.celebrated"),
//   //   iosParameters: const IOSParameters(bundleId: "com.rodrickvy.celebrated"),
//   // );
//
//   static Future<Uri> get dynamicLink async => Uri.parse('https://celebratedapp.com/sign_in');
//
//   //
//   // await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
//   @override
//   Widget view({required BuildContext ctx, required Adaptive adapter}) {
//     switch (mode) {
//       case ActionsMode.resetPassword:
//         return PasswordResetHandler(code: code, continueUrl: continueUrl);
//       case ActionsMode.recoverEmail:
//         return const ComingSoon(
//             image: "assets/intro/data_not_found.png",
//             title: "Email Recovery Not Yet Implemented",
//             description: "This feature is coming soon.");
//       case ActionsMode.verifyEmail:
//         // return CompleteSignInHandler(code: code, continueUrl: continueUrl);
//       case ActionsMode.unknown:
//         return const NotFoundView();
//     }
//   }
// }

class CompleteEmailVerification extends AdaptiveUI {
  static String emailLink = '';
  static String email = '';

   CompleteEmailVerification({super.key}){
     FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: true);
  }

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {



    return FutureBuilder(
      future: authService.handleSignInLink(email, emailLink),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      if(snapshot.hasData){
        FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: false);
      }
      if(snapshot.hasData && snapshot.data == true && FeedbackService.appNotification.value == null){
        FeedbackService.announce(notification: AppNotification(title: "Sign in failed, you dont have an account created.",message: "Sign in failed, you dont have an account created.",));
      }
      return FeedbackSpinner(
        spinnerKey: FeedbackSpinKeys.signInForm,
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
                  if(!navService.toNextIfAny()){
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
//
// enum PassResetState { loading, form, success, error }
//
// class PasswordResetHandler extends AdaptiveUI {
//   final String code;
//
//   // (Optional) Get the continue URL from the query parameter if available.
//   final String continueUrl;
//
//   final Rx<PassResetState> passResetState = PassResetState.loading.obs;
//
//   PasswordResetHandler({required this.code, required this.continueUrl, super.key});
//
//   @override
//   Widget view({required BuildContext ctx, required Adaptive adapter}) {
//     return Container(
//       height: adapter.height,
//       alignment: Alignment.topCenter,
//       padding: EdgeInsets.zero,
//       width: adapter.width,
//       color: Colors.white,
//       child: Center(
//         child: SizedBox(
//           width: 320,
//           height: Get.height,
//           child: Obx(
//             () {
//               switch (passResetState.value) {
//                 case PassResetState.loading:
//                 case PassResetState.form:
//                   return form(adapter);
//                 case PassResetState.success:
//                   return success(adapter);
//                 case PassResetState.error:
//                   return error(adapter);
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget loading(adapter) {
//     return FeedbackSpinner(defaultState: true, spinnerKey: const Key('reset-password'), child: success(adapter));
//   }
//
//   ListView error(adapter) {
//     return ListView(padding: const EdgeInsets.all(12), children: [
//       const SizedBox(
//         height: 20,
//       ),
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           "Looks like something went wrong",
//           style: adapter.textTheme.headlineSmall,
//           textAlign: TextAlign.center,
//         ),
//       ),
//       const NotificationsView(),
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           "please try resending the password reset link again.",
//           style: adapter.textTheme.headlineSmall,
//           textAlign: TextAlign.center,
//         ),
//       ),
//       const SizedBox(
//         height: 20,
//       ),
//       AppButton(
//         key: UniqueKey(),
//         child: Text(
//           "Resend reset link",
//           style: GoogleFonts.poppins(fontSize: 16),
//         ),
//         onPressed: () async {
//           Get.toNamed(AppRoutes.authPasswordReset);
//         },
//       ),
//     ]);
//   }
//
//   Widget form(adapter) {
//     return FeedbackSpinner(
//       spinnerKey: FeedbackSpinKeys.passResetForm,
//       child: ListView(padding: const EdgeInsets.all(12), children: [
//         const SizedBox(
//           height: 20,
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             "Lets Reset Your Password!",
//             style: adapter.textTheme.headlineSmall,
//             textAlign: TextAlign.center,
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset(
//             'assets/intro/pass_forgot.png',
//             width: 200,
//           ),
//         ),
//         AppTextField(
//           fieldIcon: Icons.vpn_key,
//           label: "New password",
//           autoFocus: true,
//           hint: "minimum 6 characters",
//           onChanged: (data) {
//             UIFormState.password(data);
//           },
//           obscureOption: true,
//           key: UniqueKey(),
//           keyboardType: TextInputType.visiblePassword,
//           autoFillHints: const [AutofillHints.password],
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         AppButton(
//           key: UniqueKey(),
//           child: Text(
//             "Reset ",
//             style: GoogleFonts.poppins(fontSize: 16),
//           ),
//           onPressed: () async {
//             FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.passResetForm, isOn: true);
//
//             bool result = await authService.handlePasswordReset(code, continueUrl, UIFormState.password.value);
//             if (result) {
//               passResetState(PassResetState.success);
//             } else {
//               passResetState(PassResetState.error);
//             }
//             FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.passResetForm, isOn: false);
//           },
//         ),
//       ]),
//     );
//   }
//
//   ListView success(adapter) {
//     return ListView(padding: const EdgeInsets.all(12), children: [
//       const SizedBox(
//         height: 20,
//       ),
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           "Your password has been reset!",
//           style: adapter.textTheme.headlineSmall,
//           textAlign: TextAlign.center,
//         ),
//       ),
//       const SizedBox(
//         height: 20,
//       ),
//       Container(
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(8.0),
//         child: Image.asset(
//           'assets/intro/pass_forgot.png',
//           width: 200,
//         ),
//       ),
//       AppButton(
//         key: UniqueKey(),
//         child: Text(
//           "Continue",
//           style: GoogleFonts.poppins(fontSize: 16),
//         ),
//         onPressed: () async {
//           if (authService.isAuthenticated.isTrue) {
//             Get.toNamed(AppRoutes.lists);
//           } else {
//             Get.toNamed(AppRoutes.authSignIn);
//           }
//         },
//       ),
//     ]);
//   }
// }
