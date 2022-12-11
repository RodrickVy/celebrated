import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/view/components/copy.text.dart';
import 'package:celebrated/lists/adapter/birthday.list.factory.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/birthday.list.dart';
import 'package:celebrated/lists/model/settings.ui.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/model/toggle.option.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/components/toogle.button.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

List<OptionAction> birthdaysListActions(BirthdayBoard board) {
  return [
    OptionAction("Share List", Icons.share, () {
      birthdaysController.currentSettingBox(SettingBox.shareList);
    }),
    OptionAction("Collect Info", Icons.add_link, () {
      birthdaysController.currentSettingBox(SettingBox.invite);
    }),
    OptionAction("Notifications", Icons.notifications_sharp, () {
      birthdaysController.currentSettingBox(SettingBox.notifications);
    }),
    // DropDownAction("Delete List", Icons.delete, () {
    //
    // }),
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
              onPressed: () async{
                await  controller.deleteList(board.id);
                FeedbackService.clearErrorNotification();
              },

              isTextButton: true,
              child: const Text("Delete"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton(
              onPressed: () async{
                FeedbackService.clearErrorNotification();

              },
              isTextButton: true,
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
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleWidget(
              image: "assets/intro/forget.png",
              title: "Invite Others to add their birthdays",
            ),
            if (shareOn.isTrue)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CopyText(
                  textValue: board.addInviteUrl(),
                ),
              ),
            Wrap(
              children: [
                if (board.addingId.isNotEmpty)
                  AppButtonIcon(
                    icon: const Icon(Icons.delete),
                    onPressed: () async{
                      await birthdaysController.updateContent(
                          board.id, BirthdayBoardFactory().toJson(board.copyWith(addingId: "")));
                    },
                    loadStateKey: FeedbackSpinKeys.appWide,
                    isTextButton: true,
                    label: "Destroy Link",
                  ),
                AppButtonIcon(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    await birthdaysController.updateContent(
                        board.id,
                        BirthdayBoardFactory().toJson(
                            board.copyWith(addingId: board.addingId.isNotEmpty ? board.generateInviteId() : addId)));
                  },
                  loadStateKey: FeedbackSpinKeys.appWide,
                  isTextButton: true,
                  label: "${board.addingId.isEmpty ? 'G' : 'Reg'}enerate link",
                ),
              ],
            ),
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
          const TitleWidget(
            image: "assets/intro/share_link.png",
            title: "Share list to others to watch",
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: AppToggleButton(
          //     onInteraction: () {
          //       shareOn.toggle();
          //     },
          //     options: [
          //       ToggleOption(
          //           view: Padding(
          //             padding: const EdgeInsets.all(6.0),
          //             child: Row(
          //               children: const [Icon(Icons.link_off), Text(" Destory ")],
          //             ),
          //           ),
          //           state: shareOn.isFalse,
          //           onSelected: () {
          //             birthdaysController.updateContent(
          //                 board.id, BirthdayBoardFactory().toJson(board.copyWith(viewingId: "")));
          //           }),
          //       ToggleOption(
          //           view: Padding(
          //             padding: const EdgeInsets.all(6.0),
          //             child: Row(
          //               children: const [Icon(Icons.link), Text("On")],
          //             ),
          //           ),
          //           state: shareOn.isTrue,
          //           onSelected: () {
          //             birthdaysController.updateContent(
          //                 board.id, BirthdayBoardFactory().toJson(board.copyWith(viewingId: viewId)));
          //           })
          //     ],
          //   ),
          // ),
          if (shareOn.isTrue)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CopyText(
                textValue: board.viewUrl(),
              ),
            ),
          Wrap(
            children: [
              if (board.viewingId.isNotEmpty)
                AppButtonIcon(
                  icon: const Icon(Icons.delete),
                  onPressed: () async{
                    birthdaysController.updateContent(
                        board.id, BirthdayBoardFactory().toJson(board.copyWith(viewingId: "")));
                  },
                  loadStateKey: FeedbackSpinKeys.appWide,
                  isTextButton: true,
                  label: "Destroy Link",
                ),
              AppButtonIcon(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await birthdaysController.updateContent(
                      board.id,
                      BirthdayBoardFactory().toJson(
                          board.copyWith(viewingId: board.viewingId.isNotEmpty ? board.generateViewId() : viewId)));
                },
                loadStateKey: FeedbackSpinKeys.appWide,
                isTextButton: true,
                label: "${board.viewingId.isEmpty ? 'G' : 'Reg'}enerate link",
              ),
            ],
          ),
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
            const TitleWidget(
              image: "assets/intro/notification.png",
              title: "How do you want to be reminded",
            ),
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
                            if (authService.userLive.value.silencedBirthdayLists.contains(board.id))
                              const Icon(Icons.notifications),
                            if (authService.userLive.value.silencedBirthdayLists.contains(board.id))
                              const Text(" Resume Notifications "),
                            if (!authService.userLive.value.silencedBirthdayLists.contains(board.id))
                              const Icon(Icons.notifications_off),
                            if (!authService.userLive.value.silencedBirthdayLists.contains(board.id))
                              const Text(" Pause Notifications "),
                          ],
                        ),
                      ),
                      state: authService.userLive.value.silencedBirthdayLists.contains(board.id),
                      onSelected: () {
                        if (authService.userLive.value.silencedBirthdayLists.contains(board.id)) {
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
                    disabled: authService.userLive.value.silencedBirthdayLists.contains(board.id),
                    values: List.generate(
                      7,
                      (index) => '${index + 1}',
                    ),
                    defaultValue: board.startReminding.toString(),
                    onSelect: (String value) {
                      birthdaysController.updateListsStartReminding(board, int.parse(value));
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
                enabled: !authService.userLive.value.silencedBirthdayLists.contains(board.id),
                selected: board.notificationType == e,
                onTap: () {
                  birthdaysController.updateContent(board.id, {"notificationType": e.name});
                },
              );
            }),
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
    Key? key,
    required this.image,
    required this.title,
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
              width:80,
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
    return Obx(
      () {
        if (birthdaysController.currentSettingBox.value == SettingBox.none) {
          return const SizedBox();
        }
        return Container(
          padding: const EdgeInsets.all(12),
          width: adapter.adapt(phone: Get.width - 100, tablet: null, desktop: null),
          child: Card(
            shape: AppTheme.shape,
            elevation: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(
                      isTextButton: true,
                      minWidth: adapter.width,
                      label: "close",
                      onPressed: () async{
                        birthdaysController.currentSettingBox(SettingBox.none);
                      }),
                ),
                ShareListView(board: board),
                InviteOthersView(board: board),
                NotificationSelection(board: board),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget get uiToShow {
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
  }
}



/// used in birthday editor to select the time to be notified.
class NotifyWhen extends AdaptiveUI {
  final List<String> values;
  final Rx<String?> _value = Rx<String?>(null);
  final Function(String value) onSelect;
  final bool disabled;
  final String defaultValue;

  NotifyWhen(
      {Key? key,
        required this.values,
        required this.defaultValue,
        this.disabled = false,
        required this.onSelect})
      : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _value(defaultValue);
    });
  }

  @override
  Widget view({ required BuildContext ctx,  required Adaptive adapter}) {
    return Obx(
          () => Opacity(
        opacity: disabled ? 0.4:1,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color:Colors.transparent,
            borderRadius: BorderRadius.circular(0),
            // border: const Border.fromBorderSide(
            //     BorderSide(color: Colors.black45, width: 0.8))
          ),
          child: DropdownButton<String>(
            value: _value.value ?? defaultValue,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,

            borderRadius: BorderRadius.circular(0),
            underline: Container(
              height: 2,
            ),
            onChanged: (String? newValue) {},
            items: values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                onTap: () {
                  _value(value);
                  onSelect(value);
                },
                child: Text(
                  "$value days",
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
