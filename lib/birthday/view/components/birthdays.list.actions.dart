import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/birthday/adapter/birthday.list.factory.dart';
import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/birthday/model/birthday.list.dart';
import 'package:celebrated/birthday/view/b.list.view.dart';
import 'package:celebrated/birthday/view/birthday.notify.when.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/model/toggle.option.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/app.state.view.dart';
import 'package:celebrated/domain/view/components/toogle.button.dart';

import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

List<DropDownAction> birthdaysListActions(BirthdayBoard board) {
  return [
    DropDownAction("Share Link", Icons.share, () {
      birthdaysController.currentSettingBox(SettingBox.shareList);
    }),
    DropDownAction("Invite Others", Icons.add_link, () {
      birthdaysController.currentSettingBox(SettingBox.invite);
    }),
    DropDownAction("Notifications", Icons.notifications_sharp, () {
      birthdaysController.currentSettingBox(SettingBox.notifications);
    }),
    DropDownAction("Delete List", Icons.delete, () {
      FeedbackService.announce(
        ///todo change Error Codes to notification codes
        notification: AppNotification(
            message: '',
            appWide: true,
            canDismiss: false,
            type: NotificationType.warning,
            title: "Are you sure you want to this '${board.name}' delete?",
            code: ResponseCode.unknown,
            child: DeleteListView(controller: birthdaysController, board: board)),
      );
    }),
  ];
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
              isTextButton: true,
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
              isTextButton: true,
              key: UniqueKey(),
              child: const Text("Cancel"),
            ),
          ),
        ],
      ),
    );
  }
}

class InviteOthersView extends AdaptiveUI {
  final RxBool shareOn = false.obs;
  late String addId;

  InviteOthersView({
    Key? key,
    required this.board,
  }) : super(key: key) {
    shareOn(board.addingId.isNotEmpty);
    addId = board.addingId.isNotEmpty ? board.addingId : board.generateInviteId();
  }

  final BirthdayBoard board;

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      ()=> Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleWidget(image: "assets/intro/forget.png",title: "Invite Others to add their birthdays",),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppToggleButton(
                onInteraction: () {
                  shareOn.toggle();
                },
                options: [
                  ToggleOption(
                      view: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: const [Icon(Icons.link_off), Text(" Off")],
                        ),
                      ),
                      state: shareOn.isFalse,
                      onSelected: () {
                        birthdaysController.updateContent(
                            board.id, BirthdayBoardFactory().toJson(board.copyWith(addingId: "")));
                      }),
                  ToggleOption(
                      view: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: const [Icon(Icons.link), Text(" On")],
                        ),
                      ),
                      state: shareOn.isTrue,
                      onSelected: () {
                        birthdaysController.updateContent(
                            board.id, BirthdayBoardFactory().toJson(board.copyWith(addingId: addId)));
                      })
                ],
              ),
            ),
            if (shareOn.isTrue)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButton(
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
                  isTextButton: true,
                  child: Text(GetPlatform.isWeb ? "Copy Link" : "Share Link"),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(
                      isTextButton: true,
                      minWidth: 60,
                      label: "close",
                      onPressed: () {
                        birthdaysController.currentSettingBox(SettingBox.none);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ShareListView extends AdaptiveUI {
  late RxBool shareOn;
  late String viewId;

  ShareListView({
    Key? key,
    required this.board,
  }) : super(key: key) {
    shareOn = board.viewingId.isNotEmpty.obs;
    viewId = shareOn.value ? board.viewingId : board.generateViewId();
  }

  final BirthdayBoard board;

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleWidget(image: "assets/intro/share_link.png",title:      "Share list to others to watch",),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppToggleButton(
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
                      birthdaysController.updateContent(
                          board.id, BirthdayBoardFactory().toJson(board.copyWith(viewingId: "")));
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
                      birthdaysController.updateContent(
                          board.id, BirthdayBoardFactory().toJson(board.copyWith(viewingId: viewId)));
                    })
              ],
            ),
          ),
          if (shareOn.isTrue)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CopyShareLinkButton(
                board: board,
                viewId: viewId,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButton(
                    isTextButton: true,
                    minWidth: 60,
                    label: "close",
                    onPressed: () {
                      birthdaysController.currentSettingBox(SettingBox.none);
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CopyShareLinkButton extends StatelessWidget {
  const CopyShareLinkButton({Key? key, required this.board, required this.viewId, this.label = "Link Copied"})
      : super(key: key);

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

class NotificationSelection extends AdaptiveUI {
  const NotificationSelection({
    Key? key,
    required this.board,
  }) : super(key: key);

  final BirthdayBoard board;

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleWidget(image:  "assets/intro/notification.png", title: "How do you want to be reminded",),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppToggleButton(
                onInteraction: () {},
                multiselect: true,
                options: [
                  ToggleOption(
                      view: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            if (authService.accountUser.value.silencedBirthdayLists.contains(board.id))
                              const Icon(Icons.notifications),
                            if (authService.accountUser.value.silencedBirthdayLists.contains(board.id))
                              const Text(" Resume Notifications "),
                            if (!authService.accountUser.value.silencedBirthdayLists.contains(board.id))
                              const Icon(Icons.notifications_off),
                            if (!authService.accountUser.value.silencedBirthdayLists.contains(board.id))
                              const Text(" Pause Notifications "),
                          ],
                        ),
                      ),
                      state: authService.accountUser.value.silencedBirthdayLists.contains(board.id),
                      onSelected: () {
                        if (authService.accountUser.value.silencedBirthdayLists.contains(board.id)) {
                          authService.resumeBirthdayListNotifications(board.id);
                        } else {
                          authService.pauseBirthdayListNotifications(board.id);
                        }
                      }),
                  // ToggleOption(
                  //     view: Padding(
                  //       padding: const EdgeInsets.all(6.0),
                  //       child: Row(
                  //         children: const [Icon(Icons.link), Text(" On")],
                  //       ),
                  //     ),
                  //     state: !authService.accountUser.value.silencedBirthdayLists.contains(board.id),
                  //     onSelected: () {
                  //       authService.resumeBirthdayListNotifications(board.id);
                  //     })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 14),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceEvenly,
                direction: Axis.horizontal,
                children: [
                  const Text("Remind Me : "),
                  NotifyWhen(
                    disabled:authService.accountUser.value.silencedBirthdayLists.contains(board.id),
                    values: List.generate(
                      7,
                      (index) => '${index + 1}',
                    ),
                    defaultValue: board.startReminding.toString(),
                    onSelect: (String value) {
                      birthdaysController.updateListsStartReminding(board,int.parse(value));
                    },
                  ),
                  const Text("before a birthday."),
                ],
              ),
            ),
            ...BirthdayReminderType.values.map((e) {
              return ListTile(
                leading: Icon(board.notificationType == e ? Icons.check_box : Icons.check_box_outline_blank),
                title: Text(e.name),
                enabled: !authService.accountUser.value.silencedBirthdayLists.contains(board.id),
                selected: board.notificationType == e,
                onTap: () {
                  birthdaysController.updateContent(board.id, {"notificationType": e.name});
                },
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(
                      isTextButton: true,
                      minWidth: 60,
                      label: "close",
                      onPressed: () {
                        birthdaysController.currentSettingBox(SettingBox.none);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TitleWidget extends AdaptiveUI {
  final String image;
  final String title;

  const TitleWidget({
    Key? key, required this.image, required this.title,
  }) : super(key: key);



  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Row(

      children: [
        FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              image,
              width: 100,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: adapter.textTheme.headline6,
            ),
          ),
        ),
      ],
    );
  }
}

class ListSettingsUi extends AdaptiveUI {
  final BirthdayBoard board;

  const ListSettingsUi({super.key, required this.board});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return SizedBox(
      width: adapter.adapt(phone: Get.width-100, tablet: null, desktop: null),
      child: Obx(
        () {
          if (birthdaysController.showNotificationSettings.value) {}
          switch (birthdaysController.currentSettingBox.value) {
            case SettingBox.none:
              return const SizedBox();
            case SettingBox.shareList:
              return ShareListView(board: board);
            case SettingBox.invite:
              return InviteOthersView(board: board);
            case SettingBox.notifications:
              return NotificationSelection(board: board);
          }
        },
      ),
    );
  }
}
