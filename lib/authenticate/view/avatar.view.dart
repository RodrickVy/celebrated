import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/appIntro/controller/intro.controller.dart';
import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// view that shows the users avatar and gracefully handles a generic avatar for unauthenticated users
class AvatarView extends AppStateView<AuthController> {
  AvatarView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    // return Obx(
    //       () {
    // if (controller.isAuthenticated.isFalse) {
    return InkWell(
        onTap: () {
          NavController.instance.to(AppRoutes.auth);
        },
        child: Center(
          child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppSwatch.primaryAccent,
                borderRadius: BorderRadius.circular(120),
                // border: Border.fromBorderSide(BorderSide(color: Colors.black,width: 2)),
                // image: DecorationImage(
                //   image: AssetImage(
                //     Get.find<IntroScreenController>().homeItem.image,
                //
                //   ),
                //   fit: BoxFit.scaleDown,
                // )
              ),
              width: 120,
              height: 120,
              margin: EdgeInsets.all(4),
              alignment: Alignment.center,
              child: Image.asset(
                Get.find<IntroScreenController>().homeItem.image,
                width: 100,
              )
          ),
        ));

    // child: () {
    //   // if(controller.accountUser.value.avatar ==  "assets/defualt_icons/avatar_outline.png"){
    //   return Image.asset(
    //
    //   );
    //   // }
    // return  Image.network(
    //   controller.accountUser.value.avatar,
    //   height: 50,
    //   width: 50,
    //   errorBuilder: (_,r_,r){
    //     return CircleAvatar(
    //       backgroundColor: Colors.white,
    //       radius: 30,
    //       child: Text(
    //         controller.user.value.isEmpty() &&
    //             controller.user.value.userName.isEmpty
    //             ? "AN"
    //             : controller.user.value.userName
    //             .split("")
    //             .first
    //             .toUpperCase(),
    //         style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
    //       ),
    //     );
    //   },
    //
    //   fit: BoxFit.cover,
    // );
    // }

    // (
    //
    // )
    //
    // ,
    //
    // )

    //     : CircleAvatar(
    //   backgroundColor: Colors.white,
    //   radius: 30,
    //   child: Text(
    //     controller.user.value.isEmpty() &&
    //         controller.user.value.userName.isEmpty
    //         ? "AN"
    //         : controller.user.value.userName
    //         .split("")
    //         .first
    //         .toUpperCase(),
    //     style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
    //   ),
    // ),
    // );
//     },
//   );
// }
  }
}
