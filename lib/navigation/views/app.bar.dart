import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     side: BorderSide.none
      // ),
      leading: !GetPlatform.isMobile && AuthController.instance.isAuthenticated.isTrue &&
              NavController.instance.currentItem == AppRoutes.auth.toLowerCase()
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                NavController.instance.openDrawer();
              },
            )
          : null,
      elevation: 0.4,
      title: const Text("breminder  "),
    );
  }
}
