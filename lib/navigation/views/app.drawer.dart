import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/interface/auth.controller.interface.dart';
import 'package:bremind/authenticate/view/avatar.view.dart';
import 'package:bremind/authenticate/view/form.submit.button.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/navigation/interface/controller.interface.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/view/afro_spinner.dart';
import 'package:bremind/util/list.extention.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  final INavController controller = Get.find<NavController>();
  final IAuthController authController = Get.find<AuthController>();

  AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(color: Get.theme.colorScheme.primary),
            child: SizedBox(
              height: 170,
              child: Column(children: [
                AvatarView(
                  controller: authController,
                ),
                Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      authController.user.value.userName,
                      style: GoogleFonts.mavenPro(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )),
                Obx(
                  () => Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (authController.isAuthenticated.isFalse)
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FormSubmitButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.auth);
                                },
                                key: UniqueKey(),
                                child: const Text(
                                  "SignIn",
                                )),
                          ),
                        if (authController.isAuthenticated.isFalse)
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 4),
                            child: Text("or"),
                          ),
                        if (authController.isAuthenticated.isFalse)
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FormSubmitButton(
                                onPressed: () {
                                  authController.logout();
                                  Get.toNamed(AppRoutes.auth);
                                },
                                key: UniqueKey(),
                                child: const Text(
                                  "SignUp",
                                )),
                          ),
                        if (authController.isAuthenticated.isTrue)
                          SpinnerView(
                            spinnerKey: AfroSpinKeys.signOut,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FormSubmitButton(
                                  onPressed: () async {
                                    FeedbackController.spinnerDefineState(
                                        key: AfroSpinKeys.signOut, isOn: true);
                                    await authController.logout();
                                    FeedbackController.spinnerDefineState(
                                        key: AfroSpinKeys.signOut, isOn: false);
                                  },
                                  key: UniqueKey(),
                                  child: const Text(
                                    "Signout",
                                  )),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ]),
            )),
        ...controller.items.map((e) {
          return Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 0, top: 5),
            child: ListTile(
              leading: Icon(e.icon),
              visualDensity: VisualDensity.compact,
              selectedColor: Get.theme.colorScheme.primary.withAlpha(187),
              title: Text(
                e.name,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              tileColor: Colors.transparent,
              selected: controller.currentItem.toLowerCase() == e.route,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              onTap: () {
                Get.toNamed(e.route);
              },
              contentPadding: const EdgeInsets.all(12),
            ),
          );
        }).toList(),
      ],
    ));
  }
}
