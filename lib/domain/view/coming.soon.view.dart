

import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// page showing the users birthdays , and enables the user to update the lists.
class ComingSoon extends AppStateView<BirthdaysController> {
  final AuthController authController = Get.find<AuthController>();
  final String image;
  final String title;
  final String description;

  ComingSoon({required this.image, required this.title, required this.description, Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      height: adapter.height,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.zero,
      width: adapter.width,
      color: Colors.white,
      child: Center(
        child: SizedBox(
          width: adapter.adapt(phone: adapter.width, tablet: 600, desktop: 600),
          child: ListView(
              padding: const EdgeInsets.all(12),

              children: [
                const SizedBox(
                  height:100,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                   image,
                    width: 200,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: adapter.textTheme.headline5,
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    elevation: 0,
                    label: const Text("Coming soon"),
                    onSelected: (bool value) {
                      Get.toNamed(AppRoutes.support);
                    },
                    shape: AppTheme.shape,
                    backgroundColor: Colors.white,
                    selected: false,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    description,
                    style: adapter.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
