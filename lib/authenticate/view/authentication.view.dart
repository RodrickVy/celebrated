import 'package:bremind/domain/view/page.view.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/view/auth.login.dart';
import 'package:bremind/authenticate/view/auth.password.recovery.view.dart';
import 'package:bremind/authenticate/view/auth.signup.dart';
import 'package:bremind/authenticate/view/signout.view.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/views/app.bottom.nav.bar.dart';
import 'package:bremind/navigation/views/app.drawer.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthView extends AppView<AuthController> {
  AuthView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptives adapter}) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          toolbarHeight: 20,
          bottom: TabBar(
            unselectedLabelColor:
                Theme.of(ctx).tabBarTheme.unselectedLabelColor,
            labelStyle: Theme.of(ctx).tabBarTheme.labelStyle,
            unselectedLabelStyle:
                Theme.of(ctx).tabBarTheme.unselectedLabelStyle,
            labelColor: Colors.black87,
            onTap: (_) {
              Get.log("Tab tapped");
              FeedbackController.clearErrorNotification();
            },
            indicatorColor: Theme.of(ctx).colorScheme.secondaryContainer,
            tabs: const <Tab>[
              Tab(
                text: 'Sign In',
              ),
              Tab(text: 'Sign Up'),
              Tab(text: 'Recover Password'),
            ],
          ),
          leading: const SizedBox(
            width: 0,
          ),
        ),
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
        bottomNavigationBar:null,
      ),
    );
  }
}
