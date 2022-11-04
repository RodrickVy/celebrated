import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/authenticate/controller/auth.controller.dart';

import 'package:celebrated/authenticate/view/avatar.view.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/interface/controller.interface.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDesktopDrawer extends StatelessWidget {
  final INavController controller = Get.find<NavController>();
  final AuthController authController = Get.find<AuthController>();

  AppDesktopDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.currentRoute == '/') {
      return const SizedBox();
    }
    return SizedBox(
      width: 280,
      height: Adaptive(context).height,
      child: Drawer(
          elevation: 0,
          backgroundColor: AppSwatch.primaryAccent,

          child: ListView(
            children: [
              // DrawerHeader(
              //     child: Column(children: [
              //
              //       // Obx(
              //       //   () => Expanded(
              //       //     child: Row(
              //       //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       //       children: [
              //       //         if (authController.isAuthenticated.isFalse)
              //       //           Padding(
              //       //             padding: const EdgeInsets.all(2.0),
              //       //             child: AppButton(
              //       //                 onPressed: () {
              //       //                   NavController.instance
              //       //                       .to(AppRoutes.authSignIn);
              //       //                 },
              //       //                 key: UniqueKey(),
              //       //                 child: const Text(
              //       //                   "SignIn",
              //       //                 )),
              //       //           ),
              //       //         if (authController.isAuthenticated.isFalse)
              //       //           const Padding(
              //       //             padding: EdgeInsets.only(left: 4.0, right: 4),
              //       //             child: Text("or"),
              //       //           ),
              //       //         if (authController.isAuthenticated.isFalse)
              //       //           Padding(
              //       //             padding: const EdgeInsets.all(2.0),
              //       //             child: AppButton(
              //       //                 onPressed: () {
              //       //                   NavController.instance
              //       //                       .to(AppRoutes.authSignUp);
              //       //                 },
              //       //                 key: UniqueKey(),
              //       //                 child: const Text(
              //       //                   "SignUp",
              //       //                 )),
              //       //           ),
              //       //         if (authController.isAuthenticated.isTrue)
              //       //           FeedbackSpinner(
              //       //             spinnerKey: FeedbackSpinKeys.signOut,
              //       //             child: Padding(
              //       //               padding: const EdgeInsets.all(2.0),
              //       //               child: AppButton(
              //       //                   onPressed: () async {
              //       //                     FeedbackService.spinnerDefineState(
              //       //                         key: FeedbackSpinKeys.signOut,
              //       //                         isOn: true);
              //       //                     await authController.logout();
              //       //                     FeedbackService.spinnerDefineState(
              //       //                         key: FeedbackSpinKeys.signOut,
              //       //                         isOn: false);
              //       //                   },
              //       //                   key: UniqueKey(),
              //       //                   child: const Text(
              //       //                     "Signout",
              //       //                   )),
              //       //             ),
              //       //           ),
              //       //       ],
              //       //     ),
              //       //   ),
              //       // )
              //     ])),
              AvatarView(),
              Obx(
                ()=> Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      authController.user.value.userName,
                      style: GoogleFonts.mavenPro(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,),
                      textAlign: TextAlign.center,
                    )),
              ),
              ...controller.items.map((e) {
                return Padding(
                  padding:
                      const EdgeInsets.all(8.0).copyWith(bottom: 0, top: 5),
                  child: ListTile(
                    leading: Icon(e.icon),
                    visualDensity: VisualDensity.compact,
                    // selectedColor:controller.currentItemIndex == index ? AppSwatch.primary.shade500:Colors.black54
                    selectedTileColor:  AppSwatch.primary.shade500.withAlpha(34),
                    title: Text(
                      e.name,
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    tileColor: Colors.transparent,
                    selected: controller.currentItem.toLowerCase() == e.route,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    onTap: () {
                      NavController.instance.to(e.route);
                    },
                    contentPadding: const EdgeInsets.all(12),
                  ),
                );
              }).toList(),
            ],
          )),
    );
  }
}
