import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/view/afro_spinner.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/interface/auth.controller.interface.dart';
import 'package:bremind/authenticate/view/form.submit.button.dart';
import 'package:bremind/authenticate/view/form.text.field.dart';
import 'package:bremind/support/view/notification.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth.button.dart';

// ignore: must_be_immutable
class SignUpFormView extends StatelessWidget {
  final IAuthController controller = Get.find<AuthController>();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  SignUpFormView({Key? key}) : super(key: key);

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
              spinnerKey: AfroSpinKeys.signUpForm,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FormTextField(
                          fieldIcon: Icons.email,
                          label: "Name",
                          hint: "eg. mpatso",
                          controller: nameTextController,
                          formValidator: (value) {

                            return controller.userNameValidator.validate(value);

                          },
                          key: UniqueKey(),
                          keyboardType: TextInputType.name,
                          autoFillHints: const [AutofillHints.name],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FormTextField(
                          fieldIcon: Icons.email,
                          label: "Email",
                          hint: "eg. example@gmail.com",
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
                          height: 10 / 2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const NotificatonsView( ),
                        FormSubmitButton(
                          key: UniqueKey(),
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          onPressed: () async {
                            FeedbackController.spinnerUpdateState(
                                key: AfroSpinKeys.signUpForm, isOn: true);
                            await controller.signUpWithEmail(
                                name: nameTextController.value.text,
                                email: emailTextController.value.text,
                                password: passwordTextController.value.text);
                            FeedbackController.spinnerUpdateState(
                                key: AfroSpinKeys.signUpForm, isOn: false);
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
