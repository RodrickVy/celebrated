import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/navigation/views/app.bar.dart';
import 'package:bremind/navigation/views/app.bottom.nav.bar.dart';
import 'package:bremind/navigation/views/app.drawer.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class AppPageView<T> extends StatelessWidget {
  final T controller = Get.find<T>();

  AppPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: NavController.instance.currentItem == AppRoutes.auth
            ? NavController.instance.scaffoldKey
            : null,
        appBar: const AppTopBar(),
        drawer: !GetPlatform.isMobile ? AppDrawer() : null,
        body: view(ctx: context, adapter: Adaptives(context)),
        bottomNavigationBar:
            GetPlatform.isMobile ? AppBottomNavBar<NavController>() : null,
      ),
    );
  }

  Widget view({required BuildContext ctx, required Adaptives adapter});
}

