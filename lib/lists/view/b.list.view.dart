import 'package:celebrated/lists/adapter/birthdays.factory.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/lists/model/birthday.list.dart';
import 'package:celebrated/lists/model/birthday.view.mode.dart';
import 'package:celebrated/lists/view/components/birthdays.list.actions.dart';
import 'package:celebrated/lists/view/birthday.tile.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/components/editable.text.field.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

Rx<BirthdayViewMode> viewMode = BirthdayViewMode.cards.obs;

/// page showing the users birthdays , and enables the user to update the lists.
class ABListView extends AdaptiveUI {
  final BirthdayBoard board;

  const ABListView(this.board, {Key? key}) : super(key: key);

  Key get spinnerKey => Key(board.id);

  // DropDownAction("Change-Color", () {
  //   FeedbackService.announce(
  //
  //     ///todo change Error Codes to notification codes
  //     notification: AppNotification(
  //         type: NotificationType.neutral,
  //         title: "Change Color",
  //         code: ResponseCode.prompt,
  //         child: ColorDropDown(
  //           values: StaticData.colorsList,
  //           defaultValue: board.hex,
  //           onSelect: (int value) async {
  //             await controller.updateContent(board.id, {"hex": value},);
  //           },
  //         )),
  //   );
  // }),
  // DropDownAction("Remind Time", () {
  //   FeedbackService.announce(
  //
  //     ///todo change Error Codes to notification codes
  //     notification: AppNotification(
  //       message: '',
  //       type: NotificationType.neutral,
  //       title:
  //       "When Do you want to be reminded? This will  apply to all birthdays in this list.",
  //       code: ResponseCode.prompt,
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 const Text("Remind me      "),
  //                 Flexible(
  //                   child: NotifyWhen(
  //                       values: List.generate(
  //                           15, (index) => (index + 1).toString()),
  //                       defaultValue: board.birthdays.isNotEmpty
  //                           ? board.birthdays.values.first.daysToRemind
  //                           .toString()
  //                           : "5",
  //                       onSelect: (String day) async {
  //                         Map<String, ABirthday> updatedBirthdays =
  //                         board.birthdays.map((key, value) =>
  //                             MapEntry(
  //                                 key,
  //                                 value.copyWith(
  //                                     remindMeWhen: value.date.subtract(
  //                                         Duration(
  //                                             days: int.parse(day))))));
  //
  //                         await controller.updateContent(board.id, {
  //                           "birthdays": updatedBirthdays.values
  //                               .map((value) =>
  //                               BirthdayFactory().toJson(value))
  //                               .toList()
  //                         });
  //                       }),
  //                 ),
  //                 const Text("   Before"),
  //               ],
  //             ),
  //             AppButton(
  //               onPressed: () {
  //                 FeedbackService.clearErrorNotification();
  //               },
  //               key: UniqueKey(),
  //               child: const Text("Done"),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }),
  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      height: adapter.height,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: Adaptive(ctx).adapt(phone: adapter.width, tablet: 800, desktop: 800),
        child: ListView(padding: EdgeInsets.zero, children: [
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditableTextView(
                icon: Icons.list,
                onIconPressed: () {},
                key: Key(board.name),
                textValue: board.name,
                label: 'List name',
                background: Colors.transparent,
                onSave: (String value) async {
                  FeedbackService.spinnerUpdateState(key: Key(board.name), isOn: true);
                  await birthdaysController.updateContent(board.id, {"name": value});
                  FeedbackService.spinnerUpdateState(key: Key(board.name), isOn: false);
                },
              ),
            ),
          ),
          SizedBox(
            width: Get.width,
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...birthdaysListActions(board)
                    .map((e) => Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: AppButton(
                            isTextButton: true,
                            key: UniqueKey(),
                            onPressed: () {
                              e.action();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  e.icon,
                                  color: Colors.black38,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  e.name,
                                  style: Adaptive(ctx).textTheme.bodyText2,
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),

          ListSettingsUi(
            board: board,
          ),
          const SizedBox(
            height: 40,
          ),
          TextButton.icon(
            onPressed: () async {
              final String id = const Uuid().v4();
              birthdaysController.currentBirthdayInEdit(id);
              await birthdaysController.updateContent(board.id, {
                "birthdays": board
                    .withAddedBirthday(ABirthday.empty().copyWith(id: id))
                    .birthdays
                    .values
                    .map((value) => BirthdayFactory().toJson(value))
                    .toList()
              });
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero, foregroundColor: Colors.black87, minimumSize: const Size(90, 50)),
            icon: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.add),
            ),
            label: const Text(
              "Add Birthday",
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ...board.bds.map((ABirthday birthday) {
            return BirthdayTile(
              birthday: birthday,
              onEdit: (ABirthday birthday) async {
                await birthdaysController.updateContent(board.id, {
                  "birthdays": board
                      .withAddedBirthday(birthday)
                      .birthdays
                      .values
                      .map((value) => BirthdayFactory().toJson(value))
                      .toList()
                });
              },
              onDelete: (ABirthday birthday) async {
                await birthdaysController.updateContent(board.id, {
                  "birthdays": board
                      .withRemovedBirthday(birthday.id)
                      .birthdays
                      .values
                      .map((value) => BirthdayFactory().toJson(value))
                      .toList()
                });
              },
              onSelect: () {
                navService.to(birthdaysController.getBirthdayShareRoute(board.id, birthday.id));
              },
            );
          }),

          // TextButton.icon(
          //   icon: const Icon(
          //     Icons.add,
          //     size: 30,
          //   ),
          //   padding: const EdgeInsets.all(20),
          //   onPressed: () async {
          //
          //   },
          // ),
          // Wrap(
          //   alignment: WrapAlignment.center,
          //   crossAxisAlignment: WrapCrossAlignment.center,
          //   children: [
          //     const Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: Text("Quick Actions :"),
          //     ),
          //     // Container(
          //     //   color: board.color.withAlpha(70),
          //     //   margin: EdgeInsets.all(2),
          //     //   padding: const EdgeInsets.all(8.0),
          //     //   child: Wrap(
          //     //     alignment: WrapAlignment.center,
          //     //     children: [
          //     //       Padding(
          //     //         padding: const EdgeInsets.all(8.0),
          //     //         child: Text(
          //     //           "Set remind time for all",
          //     //           style: adapter.textTheme.headline6
          //     //               ?.copyWith(fontWeight: FontWeight.w600),
          //     //         ),
          //     //       ),
          //     //       Row(
          //     //         mainAxisAlignment: MainAxisAlignment.center,
          //     //         children: [
          //     //           const Text("Remind me "),
          //     //           Flexible(
          //     //             child: NotifyWhen(
          //     //                 values: List.generate(
          //     //                     15, (index) => (index + 1).toString()),
          //     //                 defaultValue: board.birthdays.isNotEmpty
          //     //                     ? board.birthdays.values.first.daysToRemind
          //     //                         .toString()
          //     //                     : "5",
          //     //                 onSelect: (String day) async {
          //     //                   Map<String, ABirthday> updatedBirthdays = board
          //     //                       .birthdays
          //     //                       .map((key, value) => MapEntry(
          //     //                           key,
          //     //                           value.copyWith(
          //     //                               remindMeWhen: value.date.subtract(
          //     //                                   Duration(
          //     //                                       days: int.parse(day))))));
          //     //
          //     //                   await controller.updateContent(board.id, {
          //     //                     "birthdays": updatedBirthdays.values
          //     //                         .map((value) =>
          //     //                             BirthdayFactory().toJson(value))
          //     //                         .toList()
          //     //                   });
          //     //                 }),
          //     //           ),
          //     //           const Text("   Before"),
          //     //         ],
          //     //       ),
          //     //     ],
          //     //   ),
          //     // ),

          //   ],
          // ),
          SizedBox(
            height: 200,
            width: adapter.width,
          )
        ]),
      ),
    );
  }

  goToViewMode(BirthdayViewMode mode) {
    // NavController.instance.withParam("viewMode", AnEnum.toJson(mode));

    viewMode(mode);
  }
}
