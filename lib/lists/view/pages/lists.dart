import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/editable.text.field.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/pages/task.stage.pages.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/lists/model/birthday.list.dart';
import 'package:celebrated/lists/view/components/birthday.card.dart';
import 'package:celebrated/lists/view/components/birthday.editor.dart';
import 'package:celebrated/lists/view/components/birthdays.list.actions.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/support/view/components/prompt.snack.actions.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListsPage extends AdaptiveUI {
  const ListsPage({super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        birthdaysController.trackedLists.values;
        authService.user.isUnauthenticated;
        return DefaultTabController(
          length: 2,
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                titleSpacing: 0,
                toolbarHeight: 0,
                elevation: 0,
                backgroundColor: Colors.white,
                bottom: const PreferredSize(
                    preferredSize: Size(350, 50),
                    child: SizedBox(
                      width: 350,
                      child: TabBar(tabs: [
                        Tab(
                          text: "Your List",
                          // icon: Icon(Icons.list),
                        ),
                        Tab(
                          text: "Tracking",
                          // icon: Icon(Icons.notifications),
                        )
                      ]),
                    )),
              ),
              body: TabBarView(children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: Adaptive(ctx).adapt(phone: adapter.width, tablet: 800, desktop: 800),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        ...birthdaysController.birthdayLists.values.map((BirthdayBoard value) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                birthdaysController.selectList(value.id);
                              },
                              shape: AppTheme.shape,
                              title: Text(value.name),
                              trailing: Text("${value.birthdays.length}"),
                            ),
                          );
                        }).toList(),
                        if (birthdaysController.birthdayLists.isEmpty || authService.user.isUnauthenticated) ...[
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/intro/calender.png",
                              width: 200,
                            ),
                          ),
                          if (authService.user.isUnauthenticated)
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Organize Birthdays!",
                                style: adapter.textTheme.headline5,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          if (authService.user.isUnauthenticated)
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                "You can choose to organize birthdays in different lists! Click the +add button at the top.",
                                // style: adapter.textTheme.headline6,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (birthdaysController.birthdayLists.isEmpty)
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                "You have no lists, create one",
                                // style: adapter.textTheme.headline6,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (authService.user.isAuthenticated)
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: AppButtonIcon(
                                onPressed: () {
                                  birthdaysController.createNewList();
                                },
                                // minWidth: Get.width,
                                isTextButton: true,
                                icon: const Icon(Icons.add),
                                label: "Create List",
                              ),
                            ),
                          if (authService.user.isUnauthenticated)
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: AppButton(
                                  onPressed: () async {
                                    navService.to(AppRoutes.authSignIn);
                                  },
                                  isTextButton: true,
                                  child: const Text(
                                    "SignIn",
                                  )),
                            ),
                          if (authService.user.isUnauthenticated)
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0, right: 4),
                              child: Text(
                                "or",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (authService.user.isUnauthenticated)
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: AppButton(
                                  onPressed: () async {
                                    navService.to(AppRoutes.authSignUp);
                                  },
                                  isTextButton: true,
                                  child: const Text(
                                    "create account",
                                  )),
                            ),
                        ],
                        if (birthdaysController.birthdayLists.isNotEmpty)
                          AppButtonIcon(
                            onPressed: () async {
                              birthdaysController.createNewList();
                            },
                            isTextButton: true,
                            icon: const Icon(Icons.add),
                            label: "Create New List",
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: Adaptive(ctx).adapt(phone: adapter.width, tablet: 800, desktop: 800),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        ...birthdaysController.trackedLists.values.map((BirthdayBoard board) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpansionTile(
                              title: Text(board.name),
                              children: [
                                // ExpansionTile(title: Text("Notifications"),children: [
                                //   NotificationSelection(board: board)
                                // ],),
                                AppButtonIcon(
                                  icon: const Icon(Icons.notifications),
                                  label: !board.isWatcher(authService.user.uid) ? "Track List" : "Stop Tracking",
                                  onPressed: () async {
                                    if (board.isWatcher(authService.user.uid)) {
                                      await birthdaysController.stopTrackingList(board);
                                    } else {
                                      await birthdaysController.trackList(board);
                                    }
                                    await birthdaysController.getTrackedLists();
                                  },
                                  isTextButton: board.isWatcher(authService.user.id),
                                ),
                                BodyText("by @${board.authorName}"),
                                ...board.birthdays.values.map((birthday) {
                                  return BirthdayPreviewCard(
                                    birthday: birthday,
                                  );
                                })
                              ],
                            ),
                          );
                        }).toList(),
                        if (birthdaysController.trackedLists.isEmpty || authService.user.isUnauthenticated) ...[
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/intro/calender.png",
                              width: 200,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Track Other Lists!",
                              style: adapter.textTheme.headline5,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              "Can track lists created by others to also get notified",
                              // style: adapter.textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (birthdaysController.trackedLists.isEmpty)
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                "You have no tracked lists ",
                                // style: adapter.textTheme.headline6,
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                        if (authService.user.isUnauthenticated)
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: AppButton(
                                onPressed: () async {
                                  navService.to(AppRoutes.authSignIn);
                                },
                                isTextButton: true,
                                child: const Text(
                                  "SignIn",
                                )),
                          ),
                        if (authService.user.isUnauthenticated)
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 4),
                            child: Text(
                              "or",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        if (authService.user.isUnauthenticated)
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: AppButton(
                                onPressed: () async {
                                  navService.to(AppRoutes.authSignUp);
                                },
                                isTextButton: true,
                                child: const Text(
                                  "create account",
                                )),
                          ),
                      ],
                    ),
                  ),
                )
              ])),
        );
      },
    );
  }

  Widget get heading {
    return Row(
      children: [
        const Heading("Your lists"),
        IconButton(
            onPressed: () {
              navService;
            },
            icon: const Icon(Icons.supervisor_account_rounded)),
        IconButton(
            onPressed: () {
              navService.routeToParameter('ui', 'settings');
            },
            icon: const Icon(Icons.more)),
      ],
    );
  }
}

enum BirthdayListPageUI { noList, birthdays, settings }

class BirthdayListPage extends AdaptiveUI {
  BirthdayBoard? get board => birthdaysController.currentList;

  BirthdayListPageUI get show {
    if (board == null) {
      return BirthdayListPageUI.noList;
    }
    return BirthdayListPageUI.values.byName(Get.parameters['ui'] ?? BirthdayListPageUI.birthdays.name);
  }

  const BirthdayListPage({super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(() {
      authService.userLive.value;
      switch (show) {
        case BirthdayListPageUI.noList:
          return TaskFailed(
            title: "list not found",
            image: "assets/intro/data_not_found.png",
            buttonAction: () {
              navService.to(AppRoutes.lists);
            },
            buttonLabel: "Go to lists",
          );
        case BirthdayListPageUI.birthdays:
          return Container(
            height: adapter.height,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.zero,
            child: SizedBox(
              width: Adaptive(ctx).adapt(phone: adapter.width, tablet: 800, desktop: 800),
              child: ListView(padding: EdgeInsets.zero, children: [
                heading,
                const SizedBox(
                  height: 40,
                ),
                AppButtonIcon(
                  onPressed: () async {
                    birthdaysController.addBirthday(board!);
                  },
                  isTextButton: true,
                  icon: const Icon(Icons.add),
                  label: "Add Birthday",
                ),
                const SizedBox(
                  height: 40,
                ),
                ...board!.bds.map((ABirthday birthday) {
                  if (birthdaysController.currentBirthdayInEdit.value == birthday.id) {
                    return BirthdayEditor(
                        birthdayValue: birthday,
                        onSave: (ABirthday birthday) {
                          birthdaysController.saveBirthdayDetails(board!, birthday);
                        },
                        onDelete: () {
                          birthdaysController.deleteBirthday(board!, birthday);
                        },
                        onCancel: () {
                          birthdaysController.currentBirthdayInEdit("");
                        });
                  }
                  return BirthdayCard(
                    list: board!,
                    birthday: birthday,
                  );
                }),
                SizedBox(
                  height: 200,
                  width: adapter.width,
                )
              ]),
            ),
          );
        case BirthdayListPageUI.settings:
          return Container(
            height: adapter.height,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.zero,
            child: SizedBox(
              width: Adaptive(ctx).adapt(phone: adapter.width, tablet: 800, desktop: 800),
              child: ListView(padding: EdgeInsets.zero, children: [
                heading,
                Container(
                  padding: const EdgeInsets.all(12),
                  width: adapter.adapt(phone: Get.width - 100, tablet: null, desktop: null),
                  child: Card(
                    shape: AppTheme.shape,
                    elevation: 0,
                    child: ShareListView(board: board!),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: adapter.adapt(phone: Get.width - 100, tablet: null, desktop: null),
                  child: Card(
                    shape: AppTheme.shape,
                    elevation: 0,
                    child: InviteOthersView(board: board!),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: adapter.adapt(phone: Get.width - 100, tablet: null, desktop: null),
                  child: Card(
                    shape: AppTheme.shape,
                    elevation: 0,
                    child: NotificationSelection(board: board!),
                  ),
                ),
              ]),
            ),
          );
      }
    });
  }

  Widget get heading {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              if (show != BirthdayListPageUI.birthdays) {
                birthdaysController.selectList(board!.id);
              } else {
                navService.to(AppRoutes.lists);
              }
            },
            icon: const Icon(Icons.arrow_back_ios)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EditableTextView(
              icon: Icons.list,
              asText: true,
              onIconPressed: () {},
              key: Key(board!.name),
              textStyle: Get.textTheme.headline5,
              textValue: board!.name,
              label: 'List name',
              background: Colors.transparent,
              onSave: (String value) async {
                FeedbackService.spinnerUpdateState(key: Key(board!.name), isOn: true);
                await birthdaysController.updateContent(board!.id, {"name": value});
                FeedbackService.spinnerUpdateState(key: Key(board!.name), isOn: false);
              },
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              FeedbackService.announce(
                ///todo change Error Codes to notification codes
                notification: AppNotification(
                    message: '',
                    appWide: true,
                    canDismiss: false,
                    type: NotificationType.warning,
                    title: "Are you sure you want to this '${board!.name}' delete?",
                    code: ResponseCode.unknown,
                    child: PromptSnackActions(
                      onCancel: () {},
                      actionLabel: "Delete",
                      cancelLabel: "Cancel",
                      onAction: () async {
                        await birthdaysController.deleteList(board!.id);
                      },
                    )),
              );
            },
            icon: const Icon(Icons.delete)),
        IconButton(
            onPressed: () {
              navService.routeToParameter('ui', 'settings');
            },
            icon: const Icon(Icons.more)),
      ],
    );
  }
}

// class BirthdayListsPage extends AppPageView {
//   const BirthdayListsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget view({required BuildContext ctx, required Adaptive adapter}) {
//     return Obx(
//       () {
//         birthdaysController.orderedBoards;
//         birthdaysController.currentBirthdayInEdit.value;
//         return _BListTabView(
//           boards: birthdaysController.orderedBoards,
//           tabs: [
//             ...birthdaysController.orderedBoards
//                 .map2(
//                   (BirthdayBoard list, index) => Tab(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             list.name,
//                             style: adapter.textTheme.bodyMedium,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircleAvatar(
//                             radius: 12,
//                             backgroundColor: list.color,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ],
//           pagesLength: authService.user.isUnauthenticated || birthdaysController.orderedBoards.isEmpty
//               ? 1
//               : birthdaysController.orderedBoards.length,
//           initialPage: 0,
//           views: [
//             ...birthdaysController.orderedBoards.map2((element, int index) {
//               return ABListView(
//                 element,
//               );
//             }).toList(),
//           ],
//           actionButton: Obx(
//             () {
//               if (authService.user.isUnauthenticated ||
//                   birthdaysController.currentListId.isEmpty ||
//                   birthdaysController.currentList == null) {
//                 return const SizedBox();
//               }
//               // if (controller.birthdayBoards.value.isNotEmpty) {
//               //   return FloatingActionButton.extended(
//               //     tooltip: "add a new list",
//               //     onPressed: () async {
//               //       final String id = const Uuid().v4();
//               //       controller.currentBirthdayInEdit(id);
//               //       await controller
//               //           .updateContent(controller.currentListId.value, {
//               //         "birthdays": controller
//               //             .birthdayBoards[controller.currentListId.value]!
//               //             .withAddedBirthday(ABirthday.empty().copyWith(id: id))
//               //             .birthdays
//               //             .values
//               //             .map((value) => BirthdayFactory().toJson(value))
//               //             .toList()
//               //       });
//               //     },
//               //     icon: const Icon(Icons.add),
//               //     label: const Text("Add Birthday"),
//               //   );
//               // }
//
//               return const SizedBox();
//             },
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _BListTabView extends StatelessWidget {
//   final int initialPage;
//   final int pagesLength;
//   final List<Tab> tabs;
//   final List<Widget> views;
//   final Widget? actionButton;
//   final List<BirthdayBoard> boards;
//
//   const _BListTabView({
//     required this.initialPage,
//     this.actionButton,
//     required this.pagesLength,
//     required this.boards,
//     required this.tabs,
//     required this.views,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: pagesLength,
//       initialIndex: initialPage,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppTopBar.buildWithBottom(
//             context,
//             SizedBox(
//               width: Adaptive(context).width,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 100,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 4.0),
//                       child: TextButton.icon(
//                         onPressed: () {
//                           birthdaysController.createNewList();
//                         },
//                         style: TextButton.styleFrom(
//                             padding: EdgeInsets.zero, foregroundColor: Colors.black87, minimumSize: const Size(90, 50)),
//                         icon: const Padding(
//                           padding: EdgeInsets.all(4.0),
//                           child: Icon(Icons.add),
//                         ),
//                         label: const Text(
//                           "Add",
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     // width: Adaptive(context).width-100,
//                     // alignment: Alignment.centerLeft,
//                     // color: AppRoutes.lists ==
//                     //     NavController.instance.currentItem &&
//                     //     BirthdaysController.instance.birthdayBoards[
//                     //     BirthdaysController.instance.currentListId.value] !=
//                     //         null
//                     //     ? BirthdaysController
//                     //     .instance
//                     //     .birthdayBoards[
//                     // BirthdaysController.instance.currentListId.value]!
//                     //     .color
//                     //     : Colors.transparent,
//                     child: TabBar(
//                         unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
//                         labelStyle: Theme.of(context).tabBarTheme.labelStyle,
//                         unselectedLabelStyle: Theme.of(context).tabBarTheme.unselectedLabelStyle,
//                         labelColor: Colors.black87,
//                         // onTap: (int index) {
//                         //   // FeedbackService.clearErrorNotification();
//                         //   // NavController.instance.withParam("listId",);
//                         //   //   BirthdaysController.instance.currentListId( boards[index].id);
//                         //   //   BirthdaysController.instance.currentListId.refresh();
//                         //   if (index == 0) {
//                         //
//                         //   }
//                         // },
//                         isScrollable: true,
//                         padding: EdgeInsets.zero,
//                         indicatorColor: AppSwatch.primary.shade400,
//                         tabs: [
//                           if (birthdaysController.birthdayLists.isEmpty || authService.user.isUnauthenticated)
//                             const Tab(
//                               text: "",
//                             ),
//                           ...tabs
//                         ]),
//                   ),
//                 ],
//               ),
//             )),
//         body: TabBarView(
//           children: [
//             if (birthdaysController.birthdayLists.isEmpty || authService.user.isUnauthenticated) const BListInfo(),
//             ...views
//           ],
//         ),
//         bottomNavigationBar: null,
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: actionButton,
//         ),
//       ),
//     );
//   }
// }
