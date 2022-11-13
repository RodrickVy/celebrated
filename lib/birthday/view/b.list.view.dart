import 'package:celebrated/app.theme.dart';
import 'package:celebrated/birthday/adapter/birthday.list.factory.dart';
import 'package:celebrated/birthday/adapter/birthdays.factory.dart';
import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/birthday/model/birthday.dart';
import 'package:celebrated/birthday/model/birthday.list.dart';
import 'package:celebrated/birthday/model/birthday.view.mode.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/model/toggle.option.dart';
import 'package:celebrated/birthday/view/birthday.tile.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/domain/view/toogle.button.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

Rx<BirthdayViewMode> viewMode = BirthdayViewMode.cards.obs;

/// page showing the users birthdays , and enables the user to update the lists.
class BListView extends AppStateView<BirthdaysController> {
  final bool beginAtEditName;
  final BirthdayBoard board;

  BListView(this.board, {this.beginAtEditName = false, Key? key}) : super(key: key);

  Key get spinnerKey => Key(board.id);

  List<DropDownAction> get _actions {
    return [
      DropDownAction("Share Link", Icons.share, () {
        final RxBool shareOn = board.viewingId.isNotEmpty.obs;
        final String viewId = shareOn.value ? board.viewingId : board.generateViewId();
        FeedbackService.announce(
          ///todo change Error Codes to notification codes
          notification: AppNotification(
              message: '',
              appWide: true,
              type: NotificationType.neutral,
              title: "Share Live List With Others",
              code: ResponseCode.unknown,
              child: ShareListView(shareOn: shareOn, controller: controller, board: board, viewId: viewId)),
        );
      }),
      DropDownAction("Invite Others to add their birthdays", Icons.add_link, () {
        final RxBool shareOn = board.addingId.isNotEmpty.obs;
        final String addId = shareOn.value ? board.addingId : board.generateInviteId();

        FeedbackService.announce(
          ///todo change Error Codes to notification codes
          notification: AppNotification(
              message: '',
              type: NotificationType.neutral,
              title: "Invite Others to add theirs birthdays",
              code: ResponseCode.unknown,
              appWide: true,
              child: InviteOthersView(shareOn: shareOn, controller: controller, board: board, addId: addId)),
        );
      }),
      DropDownAction("Delete", Icons.delete, () {
        FeedbackService.announce(
          ///todo change Error Codes to notification codes
          notification: AppNotification(
              message: '',
              appWide: true,canDismiss: false,
              type: NotificationType.warning,
              title: "Are you sure you want to this '${board.name}' delete?",
              code: ResponseCode.unknown,
              child: DeleteListView(controller: controller, board: board)),
        );
      }),
    ];
  }

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
    //Get.log("view link is-${board.viewingId}---- ${board.birthdays.length} -- all boards : ${BirthdaysController.instance.orderedBoards.length}");
    return Container(
      height: adapter.height,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.zero,

      child: SizedBox(      width: Adaptive(ctx).adapt(phone: adapter.width, tablet: 800, desktop: 800),
        child: ListView(padding: EdgeInsets.zero, children: [
          // ListTile(
          //   dense: true,
          //   // leading: Padding(
          //   //   padding: const EdgeInsets.all(4.0),
          //   //   child: ToggleButtons(
          //   //     onPressed: (int index) {
          //   //       goToViewMode(BirthdayViewMode.values[index]);
          //   //     },
          //   //     selectedColor: Colors.transparent,
          //   //     isSelected:
          //   //         BirthdayViewMode.values.map((e) => e == viewMode.value).toList(),
          //   //     children: const <Widget>[
          //   //       Icon(Icons.check_box_outline_blank_outlined),
          //   //       Icon(Icons.calendar_view_day),
          //   //     ],
          //   //   ),
          //   // ),
          //   contentPadding: EdgeInsets.zero,
          //   title: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       // Expanded(
          //       //   child: Padding(
          //       //     padding: const EdgeInsets.all(8.0),
          //       //     child: ColorDropDown(
          //       //       values: StaticData.colorsList,
          //       //       defaultValue: board.hex,
          //       //       onSelect: (int value) async {
          //       //         await controller.updateContent(
          //       //           board.id,
          //       //           {"hex": value},
          //       //         );
          //       //       },
          //       //     ),
          //       //   ),
          //       // ),
          //       Expanded(
          //         flex: 4,
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: EditableTextView(
          //             icon: Icons.delete,
          //             onIconPressed: () {},
          //             key: const Key("_board_name_editor"),
          //             textValue: board.name,
          //             label: 'list name',
          //             editMode: beginAtEditName,
          //             background: Colors.transparent,
          //             onSave: (String value) async {
          //               FeedbackService.spinnerUpdateState(
          //                   key: spinnerKey, isOn: true);
          //               await controller.updateContent(board.id, {"name": value});
          //               FeedbackService.spinnerUpdateState(
          //                   key: spinnerKey, isOn: false);
          //             },
          //           ),
          //         ),
          //       ),
          //       ActionDropDown(
          //         actions: _actions,
          //       )
          //     ],
          //   ),
          //
          //   tileColor: Colors.white,
          // ),
          SizedBox(
            width: Get.width,
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ..._actions
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
                                Icon(e.icon),
                                const SizedBox(width: 5,),
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
          ...board.bds.map((ABirthday birthday) {
            return BirthdayTile(
              birthday: birthday,
              onEdit: (ABirthday birthday) async {
                await controller.updateContent(board.id, {
                  "birthdays": board
                      .withAddedBirthday(birthday)
                      .birthdays
                      .values
                      .map((value) => BirthdayFactory().toJson(value))
                      .toList()
                });
              },
              onDelete: (ABirthday birthday) async {
                await controller.updateContent(board.id, {
                  "birthdays": board
                      .withRemovedBirthday(birthday.id)
                      .birthdays
                      .values
                      .map((value) => BirthdayFactory().toJson(value))
                      .toList()
                });
              },
              onSelect: () {
                NavController.instance.to(controller.getBirthdayShareRoute(board.id, birthday.id));
              },
            );
          }),
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
            padding: const EdgeInsets.all(20),
            onPressed: () async {
              final String id = const Uuid().v4();
              controller.currentBirthdayInEdit(id);
              await controller.updateContent(board.id, {
                "birthdays": board
                    .withAddedBirthday(ABirthday.empty().copyWith(id: id))
                    .birthdays
                    .values
                    .map((value) => BirthdayFactory().toJson(value))
                    .toList()
              });
            },
          ),
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

class DeleteListView extends StatelessWidget {
  const DeleteListView({
    Key? key,
    required this.controller,
    required this.board,
  }) : super(key: key);

  final BirthdaysController controller;
  final BirthdayBoard board;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.themeData,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton(
              onPressed: () {
                controller.deleteContent(board.id);

                FeedbackService.clearErrorNotification();
              },
              key: UniqueKey(),
              child: const Text("Delete"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton(
              onPressed: () {
                FeedbackService.clearErrorNotification();
              },
              key: UniqueKey(),
              child: const Text("Cancel"),
            ),
          ),
        ],
      ),
    );
  }
}

class InviteOthersView extends StatelessWidget {
  const InviteOthersView({
    Key? key,
    required this.shareOn,
    required this.controller,
    required this.board,
    required this.addId,
  }) : super(key: key);

  final RxBool shareOn;
  final BirthdaysController controller;
  final BirthdayBoard board;
  final String addId;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.themeData,
      child: Obx(
        () => Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.horizontal,
          spacing: 5,
          runSpacing: 5,
          children: [
            AppToggleButton(
              onInteraction: () {
                shareOn.toggle();
              },
              options: [
                ToggleOption(
                    view: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: const [Icon(Icons.link_off), Text("Off")],
                      ),
                    ),
                    state: shareOn.isFalse,
                    onSelected: () {
                      controller.updateContent(
                          board.id, BirthdayBoardFactory().toJson(board.copyWith(addingId: "")));
                    }),
                ToggleOption(
                    view: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: const [Icon(Icons.link), Text("On")],
                      ),
                    ),
                    state: shareOn.isTrue,
                    onSelected: () {
                      controller.updateContent(
                          board.id, BirthdayBoardFactory().toJson(board.copyWith(addingId: addId)));
                    })
              ],
            ),
            if (shareOn.isTrue)
              AppButton(
                onPressed: () async {
                  if (GetPlatform.isWeb) {
                    Clipboard.setData(ClipboardData(text: board.addInviteUrl(addId)));
                    FeedbackService.clearErrorNotification();
                    FeedbackService.successAlertSnack('Link Copied!');
                  } else {
                    await Share.share(board.addInviteUrl(addId));
                    FeedbackService.clearErrorNotification();
                  }
                },
                key: UniqueKey(),
                isTextButton:true,
                child: Text(GetPlatform.isWeb ? "Copy Link" : "Share Link"),
              ),
          ],
        ),
      ),
    );
  }
}

class ShareListView extends StatelessWidget {
  const ShareListView({
    Key? key,
    required this.shareOn,
    required this.controller,
    required this.board,
    required this.viewId,
  }) : super(key: key);

  final RxBool shareOn;
  final BirthdaysController controller;
  final BirthdayBoard board;
  final String viewId;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        alignment: WrapAlignment.spaceAround,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        runSpacing: 5,
        children: [
          AppToggleButton (
            onInteraction: () {
              shareOn.toggle();
            },
            options: [
              ToggleOption(
                  view: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: const [Icon(Icons.link_off), Text("Off")],
                    ),
                  ),
                  state: shareOn.isFalse,
                  onSelected: () {
                    controller.updateContent(board.id, BirthdayBoardFactory().toJson(board.copyWith(viewingId: "")));
                  }),
              ToggleOption(
                  view: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: const [Icon(Icons.link), Text("On")],
                    ),
                  ),
                  state: shareOn.isTrue,
                  onSelected: () {
                    controller.updateContent(
                        board.id, BirthdayBoardFactory().toJson(board.copyWith(viewingId: viewId)));
                  })
            ],
          ),
          if (shareOn.isTrue)
            CopyShareLinkButton(board: board, viewId: viewId,),
          // AppButton(
          //   onPressed: () {
          //     FeedbackService.clearErrorNotification();
          //   },
          //   isTextButton: true,
          //   key: UniqueKey(),
          //   child: const Text("Close"),
          // ),
        ],
      ),
    );
  }
}

class CopyShareLinkButton extends StatelessWidget {
  const CopyShareLinkButton({
    Key? key,
    required this.board,
    required this.viewId,
    this.label="Link Copied"
  }) : super(key: key);

  final BirthdayBoard board;
  final String viewId;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: () async {
        if (GetPlatform.isWeb) {
          Clipboard.setData(ClipboardData(text: board.viewUrl(viewId)));
          FeedbackService.clearErrorNotification();
          FeedbackService.successAlertSnack(label);
        } else {
          await Share.share(board.viewUrl(viewId));
          FeedbackService.clearErrorNotification();
        }
      },
      key: UniqueKey(),
      isTextButton: true,
      child: Text(GetPlatform.isWeb ? "Copy Link" : "Share Link"),
    );
  }
}
