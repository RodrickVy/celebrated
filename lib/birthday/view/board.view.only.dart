import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/birthday/model/birthday.list.dart';
import 'package:bremind/birthday/model/birthday.view.mode.dart';
import 'package:bremind/domain/model/enum.dart';
import 'package:bremind/domain/repository/amen.content/model/query.dart';
import 'package:bremind/domain/repository/amen.content/model/query.methods.dart';
import 'package:bremind/birthday/view/birthday.card.dart';
import 'package:bremind/birthday/view/birthday.tile.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.page.view.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/support/models/notification.type.dart';
import 'package:bremind/support/view/notification.view.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

final  Future<BirthdayBoard>  board = BirthdaysController().boardFromViewId();
/// page showing the users birthdays , and enables the user to update the lists.
class BoardViewOnly extends AppPageView<BirthdaysController> {
  BoardViewOnly({Key? key}) : super(key: key);



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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Can't load this birthday list, its not found , maybe the author has taken it down."),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Sorry for this, you can now"),
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
                              NavController.instance.back();
                            }),
                        const SizedBox(
                          width: 50,
                        ),
                        AppButton(
                            key: UniqueKey(),
                            child: const Text("Check Us Out"),
                            onPressed: () {
                              NavController.instance.to(AppRoutes.splash);
                            }),
                      ],
                    ),
                  )
                ],
              );
            }
            if(AuthController.instance.user.value.uid == board.authorId){
              /// give edit option is user is the owner of this list
              FeedbackService.announce(
                  notification: AppNotification.empty().copyWith(
                      title:
                      "Edit this list",
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
                                  NavController.instance
                                      .to(AppRoutes.lists);
                                  BirthdaysController.instance.currentListId(board.id);

                                }),
                          ],
                        ),
                      )
                  )
              );
            }
            return Container(
              height: adapter.height,
              decoration: BoxDecoration(
                color: Color(board.hex).withAlpha(60),
              ),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.zero,
              width: adapter.width,
              child: SizedBox(
                child: ListView(padding: EdgeInsets.zero, children: [

                  ListTile(
                    dense: true,
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ToggleButtons(
                        onPressed: (int index) {
                          goToViewMode(BirthdayViewMode.values[index]);
                        },
                        selectedColor: Colors.transparent,
                        isSelected: BirthdayViewMode.values
                            .map((e) => e == viewMode)
                            .toList(),
                        children: const <Widget>[
                          Icon(Icons.check_box_outline_blank_outlined),
                          Icon(Icons.calendar_view_day),
                        ],
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Text(board.name),
                    tileColor: Color(board.hex).withAlpha(80),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  if (board.authorName.isNotEmpty)
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(style: adapter.textTheme.headline6, children: [
                          TextSpan(
                            text: "@${board.authorName} \n",
                            style: adapter.textTheme.headline6
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const TextSpan(
                            text: "shared this birthday list with you",
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
                        text: TextSpan(style: adapter.textTheme.headline6, children:const [
                          TextSpan(
                            text: "you have been invited to view this list  ",
                          ),
                        ]),
                      ),
                    ),
                  SizedBox(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        if (board.birthdays.isEmpty)
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(style: adapter.textTheme.headline6, children: [
                                TextSpan(
                                  text: "Birthday list is empty",
                                  style: adapter.textTheme.subtitle1
                                      ?.copyWith(),
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
                          child: NotificatonsView(key: UniqueKey(),),
                        ),
                        SizedBox(width: adapter.width,),
                        ...board.birthdaysList.map((ABirthday birthday) {
                          switch (viewMode) {
                            case BirthdayViewMode.tiles:
                              return BirthdayTile(
                                birthday: birthday,
                                onEdit: (ABirthday birthday) async {},
                                onDelete: (ABirthday birthday) async {},
                              );
                            case BirthdayViewMode.cards:
                              return BirthdayCard2ViewOnly(

                                birthday: birthday,


                              );
                          }
                        }),
                      ],
                    ),
                  ),
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
    if (Get.parameters["viewMode"] == null ||
        Get.parameters["viewMode"]!.isEmpty) {
      return BirthdayViewMode.tiles;
    } else {
      return AnEnum.fromJson(
          BirthdayViewMode.values, Get.parameters["viewMode"]!);
    }
  }

  goToViewMode(BirthdayViewMode mode) {
    NavController.instance.withParam("viewMode", AnEnum.toJson(mode));
  }
}