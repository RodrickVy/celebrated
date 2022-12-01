import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';

/// view that shows the users avatar and gracefully handles a generic avatar for unauthenticated users
class AvatarView extends AdaptiveUI {
  const AvatarView({this.radius = 120, Key? key}) : super(key: key);
  final double radius;

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    // return Obx(
    //       () {
    // if (controller.isAuthenticated.isFalse) {
    return SizedBox(
      width: radius + 10,
      height: radius + 10,
      child: InkWell(
          onTap: () {
           navService.to(AppRoutes.profile);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppSwatch.primary.shade600,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  // clipBehavior: Clip.hardEdge,        width: radius,
                  // decoration: BoxDecoration(
                  //   color: AppSwatch.primaryAccent,
                  //                 //   borderRadius: BorderRadius.circular(radius),
                  //                 // ),
                  radius: radius,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/defualt_icons/avatar_outline.png',
                  ),
                ),
              ),
            ),
          )),
    );

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
