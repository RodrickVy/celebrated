import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/models/auth.pages.dart';
import 'package:bremind/authenticate/view/profile.view.dart';
import 'package:bremind/domain/model/enum.dart';
import 'package:bremind/domain/view/app.page.view.dart';
import 'package:bremind/authenticate/view/auth.login.dart';
import 'package:bremind/authenticate/view/auth.password.recovery.view.dart';
import 'package:bremind/authenticate/view/auth.signup.dart';
import 'package:bremind/authenticate/view/signout.view.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/navigation/views/app.bar.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Main auth page , contains the different forms (login,sing-up,recovery)  for successful user authentication.
/// Uses a default tab bar.
class AuthView extends AppPageView<AuthController> {
  AuthView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
  return Obx(() {
    if (AuthController.instance.isAuthenticated.value == true) {
      return ProfileView(
        key: const Key("${AppRoutes.auth}profile"),
      );
    }
    return DefaultTabController(
      length: 3,
      key: UniqueKey(),
      initialIndex: initialPage,

      child: Scaffold(
        key: UniqueKey(),
        appBar:  AppTopBar.buildWithBottom(ctx, TabBar(
          unselectedLabelColor:
          Theme.of(ctx).tabBarTheme.unselectedLabelColor,
          labelStyle: Theme.of(ctx).tabBarTheme.labelStyle,
          unselectedLabelStyle:
          Theme.of(ctx).tabBarTheme.unselectedLabelStyle,
          labelColor: Colors.black87,
          onTap: (_) {
            Get.log("Tab tapped");
            FeedbackService.clearErrorNotification();
          },

          indicatorColor: Theme.of(ctx).colorScheme.secondaryContainer,
          isScrollable: true,
          tabs: const <Tab>[
            Tab(
              text: 'Sign In',
            ),
            Tab(text: 'Sign Up'),
            Tab(text: 'Reset Password'),
          ],
        )),
        body: Obx(
              () => TabBarView(children: [
            if (controller.isAuthenticated.isTrue) SignOutView(),
            if (controller.isAuthenticated.isTrue) SignOutView(),
            if (controller.isAuthenticated.isTrue) SignOutView(),
            if (controller.isAuthenticated.isFalse) LoginFormView(),
            if (controller.isAuthenticated.isFalse) SignUpFormView(),
            if (controller.isAuthenticated.isFalse) RecoverPasswordView(),
          ]),
        ),
        bottomNavigationBar: null,
      ),
    );
  });
  }

  int get initialPage {
    try {
      AuthPages pageInRoute = AnEnum.fromJson(AuthPages.values,
          Get.parameters["page"] ?? AnEnum.toJson(AuthPages.sign_in));
      Get.log("Current page is $pageInRoute");
      return AuthPages.values.indexOf(pageInRoute);
    } catch (_) {
      return 0;
    }
  }
}
