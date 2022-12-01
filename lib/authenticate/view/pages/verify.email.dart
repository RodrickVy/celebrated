import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// page showing the users birthdays , and enables the user to update the lists.
class VerifyEmail extends AdaptiveUI {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        authService.accountUser.value;
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
              Obx(
                ()=> Container(
                  height: adapter.height,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.zero,
                  width: adapter.width,
                  color: Colors.white,
                  child: Center(
                    child: SizedBox(
                      width: adapter.adapt(phone: adapter.width, tablet: 600, desktop: 600),
                      child: ListView(padding: const EdgeInsets.all(12), children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Hey ${authService.accountUser.value.firstName},", style: adapter.textTheme.headlineSmall,textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Let's verify your email", style: adapter.textTheme.headlineSmall,textAlign: TextAlign.center,),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/intro/email.png',
                            width: 200,
                          ),
                        ),
                        if( UIFormState.emailVerificationLinkSent.isTrue)
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "a link has been sent to ${authService.accountUser.value.email}, click that link to verify ur email. Check spam folder if you can't find it.",
                            style: adapter.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if( UIFormState.emailVerificationLinkSent.isFalse)
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              authService.accountUser.value.email,
                              style: adapter.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        if( UIFormState.emailVerificationLinkSent.isFalse)
                          AppButton(
                            key: UniqueKey(),
                            child: Text(
                              "Send Verification Link",
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            onPressed: () async {
                              FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: true);
                              await authService.verifyUsersEmail();
                              UIFormState.emailVerificationLinkSent(true);
                              FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: false);
                            },
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        if( UIFormState.emailVerificationLinkSent.isTrue)
                          AppButton(
                            key: UniqueKey(),
                            isTextButton: true,
                            child: Text(
                              "Resend Link",
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            onPressed: () async {
                              FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: true);
                              await authService.verifyUsersEmail();
                              UIFormState.emailVerificationLinkSent(true);
                              FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: false);
                            },
                          ),


                        const Padding(
                          padding:  EdgeInsets.all(8.0),
                          child: Text("Not your email?",textAlign: TextAlign.center,),
                        ),
                        AppButton(
                          key: UniqueKey(),
                          child: Text(
                            "Sign Out",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          onPressed: () async {
                            FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: true);
                            await authService.verifyUsersEmail();
                            UIFormState.emailVerificationLinkSent(true);
                            FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: false);
                          },
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      },
    );

  }
}
