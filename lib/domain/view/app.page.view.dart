import 'package:bremind/domain/view/app.state.view.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/navigation/views/app.bar.dart';
import 'package:bremind/navigation/views/app.bottom.nav.bar.dart';
import 'package:bremind/navigation/views/app.drawer.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// much like [AppStateView] but this time for a page, adds a scaffold using the appWide [AppDesktopDrawer],[AppBottomNavBar]
/// to avoid the hustle of repeating calling them.
/// The scaffold uses [NavControllers]'s scaffoldKey to enable anyone to close and open drawer using [NavController]
abstract class AppPageView extends StatelessWidget {


  const AppPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if(!GetPlatform.isMobile &&  Adaptive(context).width > 800){
    //   return SafeArea(
    //     child: Row(
    //       children: [
    //         AppDesktopDrawer(),
    //         Expanded(child: page(context))
    //       ],
    //     ),
    //   );
    // }
    // return SafeArea(
    //   child: page(context),
    // );

    return page(context);
  }

  Widget  page(BuildContext context) {
    return  view(ctx: context, adapter: Adaptive(context));

    //   Scaffold(
    //   // key: NavController.instance.currentItem == AppRoutes.auth
    //   //     ? NavController.instance.scaffoldKey
    //   //     : null,
    //   appBar:NavController.instance.currentItem == AppRoutes.lists ? null : const AppTopBar(),
    //   drawer: null,
    //   body:,
    //   bottomNavigationBar: GetPlatform.isMobile ? AppBottomNavBar<NavController>() : null,
    // );
  }

  Widget view({required BuildContext ctx, required Adaptive adapter});
}


 class AppPageViewWrapper extends StatelessWidget {

  final Widget body;
  const AppPageViewWrapper({required this.body,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(!GetPlatform.isMobile &&  Adaptive(context).width > 800){
      return SafeArea(
        child: Row(
          children: [
            AppDesktopDrawer(),
            Expanded(child: page(context))
          ],
        ),
      );
    }
    return SafeArea(
      child: page(context),
    );
  }

  Scaffold  page(BuildContext context) {
    return Scaffold(
      // key: NavController.instance.currentItem == AppRoutes.auth
      //     ? NavController.instance.scaffoldKey
      //     : null,
      appBar:NavController.instance.currentItem == AppRoutes.lists ? null : const AppTopBar(),
      drawer: null,
      body: body,
      bottomNavigationBar: Adaptive(context).adapt(phone: AppBottomNavBar<NavController>(), tablet: AppBottomNavBar<NavController>(), desktop: null) ,
    );
  }


}
