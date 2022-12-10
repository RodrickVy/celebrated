import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/lists/model/birthday.list.dart';
import 'package:celebrated/lists/model/birthday.view.mode.dart';
import 'package:celebrated/lists/view/birthday.tile.view.only.dart';
import 'package:celebrated/domain/model/enum.dart';
import 'package:celebrated/lists/view/birthday.card.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/app.page.view.dart';
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

/// page showing the users birthdays , and enables the user to update the lists.
class BoardViewOnly extends AdaptiveUI {
   BoardViewOnly({Key? key}) : super(key: key){
     birthdaysController.loadBoardFromShareUrl();
   }

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {

    return Obx(() {
      if (authService.userLive.value.isAuthenticated) {
        FeedbackService.announceSignUpPromo();
      }
      authService.userLive.value;
      if (BirthdaysController.listInView.value == null) {
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
      final BirthdayBoard board = BirthdaysController.listInView.value!;
      if (BirthdaysController.listInView.value != null) {
        return Container(
          height: adapter.height,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.zero,
          width: adapter.width,
          child: SizedBox(
            width: Adaptive(ctx).adapt(phone: adapter.width, tablet: 600, desktop: 700),
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
                  child: const Heading("You have been invited to view this list "),
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
                child: const NotificationsView(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!board.isWatcher(authService.user.uid))
                         const BodyText("Get auto reminders from this list"),
                    if (board.isWatcher(authService.user.uid) && authService.userLive.value.uid != board.authorId)
                       const BodyText("You are now tracking this list"),
                    if(authService.userLive.value.uid == board.authorId)
                      const BodyText("This is your own list"),
                    if( authService.userLive.value.uid != board.authorId)
                       AppButtonIcon(
                      icon: const Icon(Icons.notifications),
                      label: !board.isWatcher(authService.user.uid) ? "Track List" : "Stop Tracking",
                      onPressed: () {
                        if (board.isWatcher(authService.user.uid)) {
                          birthdaysController.stopTrackingList(board);
                        } else {
                          birthdaysController.trackList(board);
                        }
                      },
                      isTextButton: board.isWatcher(authService.user.id),
                    ),
                    if( authService.userLive.value.uid == board.authorId)
                      AppButtonIcon(
                        icon: const Icon(Icons.notifications),
                        label: "Edit List",
                        onPressed: () {
                          birthdaysController.selectList(board.id);
                        },
                      )
                  ],
                ),
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
      }
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
                    child: const Text("Go Home"),
                    onPressed: () async {
                      navService.to(AppRoutes.home);
                    }),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
          )
        ],
      );
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
    navService.routeToParameter("viewMode", mode.name);
  }
}
