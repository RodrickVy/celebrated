import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/domain/view/app.page.view.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// view for showing current birthdays around the world.
class BirthdaysLeaderBoard extends AppPageView<BirthdaysController> {
  BirthdaysLeaderBoard({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: Text(NavController.instance.currentItem.capitalizeFirst??"",style: adapter.textTheme.headline4,),
    );
  }
}


