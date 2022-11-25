import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/views/app.bar.dart';
import 'package:celebrated/navigation/views/app.bottom.nav.bar.dart';
import 'package:celebrated/navigation/views/app.drawer.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// much like [AppStateView] but this time for a page, adds a scaffold using the appWide [AppDesktopDrawer],[AppBottomNavBar]
/// to avoid the hustle of repeating calling them.
/// The scaffold uses [NavControllers]'s scaffoldKey to enable anyone to close and open drawer using [NavController]
abstract class AppPageView extends StatelessWidget {
  const AppPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return view(ctx: context, adapter: Adaptive(context));
  }


  Widget view({required BuildContext ctx, required Adaptive adapter});
}

class AppPageViewWrapper extends StatelessWidget {
  final Widget body;

  const AppPageViewWrapper({required this.body, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Adaptive(context).adaptScreens(
        small: smallScreen(context),
        big: bigScreen(context)
    );
  }


  Scaffold smallScreen(BuildContext context) {
    return Scaffold(
      // key: NavController.instance.currentItem == AppRoutes.auth
      //     ? NavController.instance.scaffoldKey
      //     : null,
      appBar: AppRoutes.noAppBarRoutes.contains(Get.currentRoute)? null : const AppTopBar(),
      drawer: null,
      backgroundColor: Colors.white,
      body: body,
      bottomNavigationBar: AppBottomNavBar<NavController>(),
    );
  }

  Widget bigScreen(BuildContext context) {
    return SafeArea(

      child: Container(
          color: Colors.white,
          child: Row(
          children: [AppDesktopDrawer<NavController>(), Expanded(child: Scaffold(
            appBar: AppRoutes.noAppBarRoutes.contains(Get.currentRoute)? null : const AppTopBar(),
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
