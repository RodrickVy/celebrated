import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/view/afro_spinner.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/interface/auth.controller.interface.dart';
import 'package:bremind/authenticate/view/form.submit.button.dart';
import 'package:bremind/authenticate/view/form.text.field.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/support/view/notification.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class RecoverPasswordView extends StatelessWidget {
  final IAuthController controller = Get.find<AuthController>();

  final TextEditingController emailTextController = TextEditingController();

  RecoverPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320,
        child: SpinnerView(
            onSpinEnd: () {},
            spinnerKey: AfroSpinKeys.passResetForm,
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
                      FormTextField(
                        fieldIcon: Icons.email,
                        label: "Email",
                        hint: "eg. john@email.com",
                        controller: emailTextController,
                        formValidator: (value) {},
                        key: UniqueKey(),
                        keyboardType: TextInputType.emailAddress,
                        autoFillHints: const [AutofillHints.email],
                      ),
                      const SizedBox(height: 10),
                      const NotificatonsView( ),
                      FormSubmitButton(
                        key: UniqueKey(),

                        child: Text(
                          "Recover-Password",
                          style: GoogleFonts.mavenPro(),
                        ),
                        onPressed: () async {
                          FeedbackController.spinnerUpdateState(
                              key: AfroSpinKeys.passResetForm,
                              isOn: true);
                          await controller.sendPasswordResetEmail(
                            email: emailTextController.value.text,
                          );
                          FeedbackController.spinnerUpdateState(
                              key: AfroSpinKeys.passResetForm,
                              isOn: false);
                        },
                      ),
                    ]),
              ),
            )),
      ),
    );
  }
}
