import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignOutView  extends AdaptiveUI {
  const SignOutView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        if(authService.user.isUnauthenticated){
          return const SizedBox();
        }
        return FeedbackSpinner(
        spinnerKey: FeedbackSpinKeys.auth,
        child: SizedBox(
          width: Get.width,
          child:AppButton(
            key: UniqueKey(),
            child: const Text(
              "Sign Out",
            ),
            onPressed: () async {
              FeedbackService.spinnerUpdateState(
                  key: FeedbackSpinKeys.auth, isOn: true);
              await authService.logout();
              FeedbackService.spinnerUpdateState(
                  key: FeedbackSpinKeys.auth, isOn: false);
            },
          ),
        ),
      );
      },
    );
  }
}
