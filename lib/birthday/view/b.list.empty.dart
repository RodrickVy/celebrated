import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/birthday/adapter/birthdays.factory.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/birthday/model/birthday.list.dart';
import 'package:bremind/birthday/view/birthday.card.dart';
import 'package:bremind/birthday/view/colordrop.down.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.state.view.dart';
import 'package:bremind/domain/view/editable.text.field.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/view/feedback.spinner.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:uuid/uuid.dart';

/// page showing the users birthdays , and enables the user to update the lists.
class BListInfo extends AppStateView<BirthdaysController> {
  final AuthController authController = Get.find<AuthController>();
  BListInfo({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      height: adapter.height,
      decoration: BoxDecoration(
        color: Colors.white10.withAlpha(60),
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.zero,
      width: adapter.width,
      child: Center(
        child: SizedBox(
          width: adapter.adapt(phone: adapter.width, tablet: 600, desktop: 600),
          child: ListView(
            padding: EdgeInsets.all(12),

              children: [
            SizedBox(
              height: adapter.height / 5,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/intro/cake_time.png",
                width: 200,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Organize Birthdays!",
                style: adapter.textTheme.headline5,
                textAlign: TextAlign.left,
              ),
            ),

            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "You can choose to organize birthdays in different lists! Click the +add button at the top.",
                style: adapter.textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),

            if (authController.isAuthenticated.isFalse)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: AppButton(
                    onPressed: () {
                      NavController.instance
                          .to(AppRoutes.authSignIn);
                    },
                    key: UniqueKey(),
                    child: const Text(
                      "SignIn",
                    )),
              ),
            if (authController.isAuthenticated.isFalse)
              const Padding(
                padding: EdgeInsets.only(left: 4.0, right: 4),
                child: Text("or",textAlign: TextAlign.center,),
              ),
            if (authController.isAuthenticated.isFalse)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: AppButton(
                    onPressed: () {
                      NavController.instance
                          .to(AppRoutes.authSignUp);
                    },
                    key: UniqueKey(),
                    child: const Text(
                      "SignUp",
                    )),
              ),
            if(authController.isAuthenticated.isFalse)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "to create a list",
                      style: adapter.textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}
