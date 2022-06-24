import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/birthday/view/birthday.date.name.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.state.view.dart';
import 'package:bremind/domain/view/app.text.field.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/view/feedback.spinner.dart';

import 'package:bremind/support/view/notification.view.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth.button.dart';

/// auth sign up form , for authentication this is not a page just the form.
// ignore: must_be_immutable
class SignUpFormView extends AppStateView<AuthController> {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController(
      text: DateTime.now().toString());

  SignUpFormView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
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
            FeedbackSpinner(
              spinnerKey: FeedbackSpinKeys.signUpForm,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // AppTextField(
                        //   fieldIcon: Icons.email,
                        //   label: "Name",
                        //   hint: "eg. mpatso",
                        //   controller: nameTextController,
                        //   key: UniqueKey(),
                        //   keyboardType: TextInputType.name,
                        //   autoFillHints: const [AutofillHints.name],
                        // ),
                        BirthdayDateForm(
                            birthdateController: _birthdateController,
                            nameTextController: nameTextController),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          fieldIcon: Icons.email,
                          label: "Email",
                          hint: "eg. example@gmail.com",
                          controller: emailTextController,
                          key: UniqueKey(),
                          keyboardType: TextInputType.emailAddress,
                          autoFillHints: const [AutofillHints.email],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          fieldIcon: Icons.vpn_key,
                          label: "Password",
                          hint: "minimum 6 characters",
                          controller: passwordTextController,
                          obscureOption: true,
                          key: UniqueKey(),
                          keyboardType: TextInputType.visiblePassword,
                          autoFillHints: const [AutofillHints.password],
                        ),
                        const SizedBox(
                          height: 10 / 2,
                        ),

                        const NotificatonsView(),
                        const SizedBox(
                          height: 10 / 2,
                        ),
                        AppButton(
                          key: UniqueKey(),
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          onPressed: () async {
                            FeedbackService.spinnerUpdateState(
                                key: FeedbackSpinKeys.signUpForm, isOn: true);
                            await controller.signUpWithEmail(
                                name: nameTextController.value.text,
                                email: emailTextController.value.text,
                                birthdate:  DateTime.parse(_birthdateController.value.text),
                                password: passwordTextController.value.text);
                            FeedbackService.spinnerUpdateState(
                                key: FeedbackSpinKeys.signUpForm, isOn: false);
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
