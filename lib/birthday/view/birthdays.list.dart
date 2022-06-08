import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/view/form.submit.button.dart';
import 'package:bremind/authenticate/view/form.text.field.dart';
import 'package:bremind/birthday/adapter/birthdays.factory.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/birthday/view/birthday.card.dart';
import 'package:bremind/birthday/view/birthday.drop.down.dart';
import 'package:bremind/domain/view/page.view.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class BirthdaysListsView extends AppView<BirthdaysController> {
  BirthdaysListsView({Key? key}) : super(key: key) {
    AuthController.instance.isAuthenticated
        .listen((bool isAuthenticated) async {
      if (isAuthenticated) {
        Get.log(
            "user is authenticated with ${AuthController.instance.user.value.uid}");
        BirthdaysController.instance.getBirthdays();
      }
    });
  }

  @override
  Widget view({required BuildContext ctx, required Adaptives adapter}) {
    return Center(
      child: Text(NavController.instance.currentItem.capitalizeFirst??"",style: adapter.textTheme.headline4,),
    );
  }
}


