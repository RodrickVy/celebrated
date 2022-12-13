import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// view for recovering password,
// ignore: must_be_immutable
class PasswordResetPage extends AdaptiveUI{


  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: SizedBox(
        width: 320,
        child: FeedbackSpinner(
            onSpinEnd: () {},
            spinnerKey: FeedbackSpinKeys.auth,
            onSpinStart: () {},
            child: Container(
              padding: const EdgeInsets.all(10 / 2),
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Form(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppTextField(
                        fieldIcon: Icons.email,
                        label: "Email",
                        hint: "eg. john@email.com",
                        controller: TextEditingController(text: UIFormState.email),
                        onChanged: (data) {

                          UIFormState.email =data.trim();
                        },
                        autoFocus: true,
                        keyboardType: TextInputType.emailAddress,
                        autoFillHints: const [AutofillHints.email],
                      ),
                      const SizedBox(height: 10),
                      const NotificationsView(),
                      AppButton(
                        
                        loadStateKey: FeedbackSpinKeys.auth,
                        onPressed: () async {

                          await authService.sendPasswordResetEmail(
                            email: UIFormState.email,
                          );
                        },

                        child: Text(
                          "Reset-Password",
                          style: GoogleFonts.mavenPro(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        
                        isTextButton: true,
                        onPressed: ()  {
                          navService.routeKeepNext(AppRoutes.authSignIn);
                        },
                        child: Text(
                          "sign in",
                          style: GoogleFonts.mavenPro(),
                        ),
                      ),
                    ]),
              ),
            )),
      ),
    );
  }
}
