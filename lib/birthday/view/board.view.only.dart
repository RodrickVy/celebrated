

import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/birthday/model/birthday.dart';
import 'package:celebrated/birthday/model/birthday.list.dart';
import 'package:celebrated/birthday/model/birthday.view.mode.dart';
import 'package:celebrated/birthday/view/birthday.tile.view.only.dart';
import 'package:celebrated/domain/model/enum.dart';
import 'package:celebrated/birthday/view/birthday.card.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/pages/app.page.view.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


final Future<BirthdayBoard> board = BirthdaysController().boardFromViewId();

/// page showing the users birthdays , and enables the user to update the lists.
class BoardViewOnly extends AppPageView {
  const BoardViewOnly({Key? key}) : super(key: key);



  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return FutureBuilder(
        future: board,
        builder: (_, AsyncSnapshot<BirthdayBoard> snap) {
          if (snap.hasData) {
            final BirthdayBoard board = snap.data!;
            if (board.isEmpty()) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/intro/data_not_found.png",
                      width: 250,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Can't load this birthday list, its not found , this link has expired."),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Sorry for this; You can now"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                            key: UniqueKey(),
                            child: const Text("Go Back"),
                            onPressed: () {
                             navService.back();
                            }),
                        const SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
            if (authService.accountUser.value.uid == board.authorId) {
              /// give edit option is user is the owner of this list
              FeedbackService.announce(
                  notification: AppNotification.empty().copyWith(
                      title: "This list is yours , you can edit it",
                      type: NotificationType.neutral,
                      appWide: false,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppButton(
                                key: UniqueKey(),
                                child: const Text("Edit"),
                                onPressed: () {
                                  BirthdaysController.instance.currentListId(board.id);
                                 navService.to(AppRoutes.lists);
                                }),
                          ],
                        ),
                      )));
            }
            return Container(
              height: adapter.height,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.zero,
              width: adapter.width,
              child: SizedBox(
                width: Adaptive(ctx).adapt(phone: adapter.width, tablet: 300, desktop: adapter.width / 2),
                height: Get.height,
                child: ListView(padding: EdgeInsets.zero, children: [
                  Text(
                    board.name,
                    textAlign: TextAlign.center,
                    style: adapter.textTheme.headline5?.copyWith(
                        fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                  if (board.authorName.isNotEmpty)
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(style: adapter.textTheme.headline6, children: [
                          TextSpan(
                            text: "@",
                            style: adapter.textTheme.headline6
                                ?.copyWith(fontWeight: FontWeight.w900, color: AppSwatch.primary.shade600),
                          ),
                          TextSpan(
                            text: board.authorName,
                            style:
                                adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.w900, color: Colors.red),
                          ),
                          TextSpan(
                            style: adapter.textTheme.headline6,
                            text: " shared this birthday list with you.",
                          ),
                        ]),
                      ),
                    ),
                  if (board.authorName.isEmpty)
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(style: adapter.textTheme.subtitle1, children: const [
                          TextSpan(
                            text: "You have been invited to view this list ",
                          ),
                        ]),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (board.birthdays.isEmpty)
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(style: adapter.textTheme.headline6, children: [
                          TextSpan(
                            text: "Birthday list is empty",
                            style: adapter.textTheme.subtitle1?.copyWith(),
                          ),
                        ]),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: NotificationsView(
                      key: UniqueKey(),
                    ),
                  ),
                  SizedBox(
                    width: adapter.width,
                  ),
                  ...board.birthdaysList.map((ABirthday birthday) {
                    switch (viewMode) {
                      case BirthdayViewMode.tiles:
                        return BirthdayCard1ViewOnly(
                          birthday: birthday,
                        );
                      case BirthdayViewMode.cards:
                        return BirthdayCard2ViewOnly(
                          birthday: birthday,
                        );
                    }
                  }),
                ]),
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitSpinningCircle(
                  color: adapter.theme.colorScheme.primary,
                ),
                const Text("getting things ready...")
              ],
            );
          }
        });
  }

  BirthdayViewMode get viewMode {
    if (Get.parameters["viewMode"] == null || Get.parameters["viewMode"]!.isEmpty) {
      return BirthdayViewMode.tiles;
    } else {
      return AnEnum.fromJson(BirthdayViewMode.values, Get.parameters["viewMode"]!);
    }
  }

  goToViewMode(BirthdayViewMode mode) {
   navService.withParam("viewMode", AnEnum.toJson(mode));
  }
}
