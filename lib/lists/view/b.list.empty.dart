import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// page showing the users birthdays , and enables the user to update the lists.
class BListInfo extends AdaptiveUI {
  const BListInfo({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      ()=> Container(
        height: adapter.height,
        decoration: BoxDecoration(
          color: Colors.white10.withAlpha(60),
        ),
        alignment: Alignment.topCenter,
        padding: EdgeInsets.zero,
        width: adapter.width,
        child: Center(
          child: Container(padding: const EdgeInsets.all(12),
            width: adapter.adapt(phone: adapter.width, tablet: 600, desktop: 600),
            child: Column(children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/intro/calender.png",
                  width: 200,
                ),
              ),
              if(authService.user.isUnauthenticated)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Organize Birthdays!",
                    style: adapter.textTheme.headline5,
                    textAlign: TextAlign.left,
                  ),
                ),
              if(authService.user.isUnauthenticated)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "You can choose to organize birthdays in different lists! Click the +add button at the top.",
                    // style: adapter.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              if(birthdaysController.birthdayLists.isEmpty)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "You have no lists, create one",
                    // style: adapter.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (authService.user.isAuthenticated)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: AppButtonIcon(
                    onPressed: () {
                      birthdaysController.createNewList();
                    },
                    // minWidth: Get.width,
                    isTextButton: true,
                    icon: const Icon(Icons.add),
                    label: "Create List",
                  ),
                ),
              if (authService.user.isUnauthenticated)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: AppButton(
                      onPressed: () async{
                        navService.to(AppRoutes.authSignIn);
                      },
                      isTextButton: true,

                      child: const Text(
                        "SignIn",
                      )),
                ),
              if (authService.user.isUnauthenticated)
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, right: 4),
                  child: Text(
                    "or",
                    textAlign: TextAlign.center,
                  ),
                ),
              if (authService.user.isUnauthenticated)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: AppButton(
                      onPressed: () async{
                        navService.to(AppRoutes.authSignUp);
                      },
                      isTextButton: true,
                      child: const Text(
                        "create account",
                      )),
                ),

            ]),
          ),
        ),
      ),
    );
  }
}
