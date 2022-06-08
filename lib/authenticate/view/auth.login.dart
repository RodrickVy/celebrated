import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/view/afro_spinner.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/interface/auth.controller.interface.dart';
import 'package:bremind/authenticate/models/auth.with.dart';
import 'package:bremind/authenticate/view/auth.password.recovery.view.dart';
import 'package:bremind/authenticate/view/form.submit.button.dart';
import 'package:bremind/authenticate/view/form.text.field.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:bremind/support/view/notification.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth.button.dart';

// ignore: must_be_immutable
class LoginFormView extends StatelessWidget {

  final IAuthController controller = Get.find<AuthController>();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  LoginFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320,
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            ProviderButtons(
              key: UniqueKey(),
            ),
            SpinnerView(
              spinnerKey: AfroSpinKeys.signInForm,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
                          formValidator: (value) {
                            return  controller.emailFormValidator.validate(value);
                          },
                          key: UniqueKey(),
                          keyboardType: TextInputType.emailAddress,
                          autoFillHints: const [AutofillHints.email],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FormTextField(
                          fieldIcon: Icons.vpn_key,
                          label: "Password",
                          hint: "minimum 6 characters",
                          controller: passwordTextController,
                          obscureText: true,
                          key: UniqueKey(),
                          keyboardType: TextInputType.visiblePassword,
                          autoFillHints: const [AutofillHints.password],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const NotificatonsView( ),
                        FormSubmitButton(
                          key: UniqueKey(),

                          child: Text(
                            "Sign In",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          onPressed: () async {
                            FeedbackController.spinnerUpdateState(
                                key: AfroSpinKeys.signInForm, isOn: true);
                            await controller.signInWithEmail(
                                email: emailTextController.value.text,
                                password: passwordTextController.value.text);
                            FeedbackController.spinnerUpdateState(
                                key: AfroSpinKeys.signInForm, isOn: false);
                          },
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
