import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/domain/view/app.page.view.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// view for showing current birthdays around the world.
class BirthdaysLeaderBoard extends AppPageView {
  const BirthdaysLeaderBoard({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: Text(NavController.instance.currentItem.capitalizeFirst??"",style: adapter.textTheme.headline4,),
    );
  }
}


