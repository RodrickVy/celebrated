import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/view/afro_spinner.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/interface/auth.controller.interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'form.submit.button.dart';

class SignOutView extends StatelessWidget {
  final IAuthController controller = Get.find<AuthController>();

  SignOutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinnerView(
      spinnerKey: AfroSpinKeys.signOut,
      child: SizedBox(
        width: Get.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Looks like you are already signed in. ",
              ),
              const SizedBox(
                height: 20,
              ),
              FormSubmitButton(
                key: UniqueKey(),
                child: const Text(
                  "Sign Out",
                ),
                onPressed: () async {
                  FeedbackController.spinnerUpdateState(
                      key: AfroSpinKeys.signOut, isOn: true);
                  await controller.logout();
                  FeedbackController.spinnerUpdateState(
                      key: AfroSpinKeys.signOut, isOn: false);
                },
              ),
            ]),
      ),
    );
  }
}
