
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/authenticate/view/components/user.avatar.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final RxBool value = false.obs;

class AppTopBar extends PreferredSize {
  const AppTopBar({Key? key})
      : super(
          key: key,
          preferredSize: const Size.fromHeight(65),
          child: const SizedBox(),
        );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading(),
      leadingWidth: leading() == null ? 0 : null,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  static PreferredSizeWidget buildWithBottom(BuildContext context, Widget bottom) {
    return AppBar(
      leading: leading(),
      leadingWidth: leading() == null ? 0 : null,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: bottom,
      ),
      toolbarHeight: 0,
      elevation: !GetPlatform.isMobile ? 0 : 0.4,
    );
  }


  static Widget? leading() {
    if (Adaptive(Get.context!).isPhone) {
      if (Get.currentRoute == AppRoutes.home) {
        Get.log("home route");
        return const AvatarView();
      } else {

        if(Get.previousRoute.isEmpty){
          return const SizedBox();
        }
        return IconButton(
            onPressed: () {
              if(Get.previousRoute == AppRoutes.profile && authService.isAuthenticated.isFalse){
                Get.toNamed(AppRoutes.home);
              }else{
                Get.back();
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new));
      }
    } else {
      return const SizedBox();
    }
  }
}
