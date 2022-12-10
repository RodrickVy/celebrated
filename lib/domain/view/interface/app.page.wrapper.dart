import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/views/app.bar.dart';
import 'package:celebrated/navigation/views/app.bottom.nav.bar.dart';
import 'package:celebrated/navigation/views/app.drawer.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
/// Wraps around a a UI adding the scaffold, and nav components to create a complete page, every view is wrapped in this component  to be a page
class AppPageWrapper extends StatelessWidget {
  final Widget body;

  const AppPageWrapper({required this.body, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Adaptive(context).adaptScreens(
          small: smallScreen(context),
          big: bigScreen(context)
      ),
    );
  }


  Scaffold smallScreen(BuildContext context) {
    return Scaffold(
      appBar: AppRoutes.noAppBarRoutes.contains(navService.baseRoute(Get.currentRoute))? null : const AppTopBar(),
      drawer: null,
      backgroundColor: Colors.white,
      body: body,
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  Widget bigScreen(BuildContext context) {
    return SafeArea(

      child: Container(
        color: Colors.white,
        child: Row(
          children: [const AppDesktopDrawer(), Expanded(child: Scaffold(
            appBar: AppRoutes.noAppBarRoutes.contains(navService.baseRoute(Get.currentRoute))? null : const AppTopBar(),
            drawer: null,
            body: body,
            backgroundColor: Colors.white,
            bottomNavigationBar: null,
          ))],
        ),)
      ,
    );
  }
}
