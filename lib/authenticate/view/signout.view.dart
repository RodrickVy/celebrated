import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.state.view.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/view/feedback.spinner.dart';

import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignOutView  extends AppStateView<AuthController> {
  SignOutView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        if(controller.isAuthenticated.isFalse){
          return const SizedBox();
        }
        return FeedbackSpinner(
        spinnerKey: FeedbackSpinKeys.signOut,
        child: SizedBox(
          width: Get.width,
          child:AppButton(
            key: UniqueKey(),
            child: const Text(
              "Sign Out",
            ),
            onPressed: () async {
              FeedbackService.spinnerUpdateState(
                  key: FeedbackSpinKeys.signOut, isOn: true);
              await controller.logout();
              FeedbackService.spinnerUpdateState(
                  key: FeedbackSpinKeys.signOut, isOn: false);
            },
          ),
        ),
      );
      },
    );
  }
}
