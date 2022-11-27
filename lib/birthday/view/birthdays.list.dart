import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/birthday/model/birthday.list.dart';
import 'package:celebrated/birthday/view/b.list.empty.dart';
import 'package:celebrated/birthday/view/b.list.view.dart';
import 'package:celebrated/birthday/view/birthday.adds.dart';
import 'package:celebrated/domain/view/pages/app.page.view.dart';
import 'package:celebrated/navigation/views/app.bar.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/list.extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BirthdayListsPage extends AppPageView {
  const BirthdayListsPage({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        birthdaysController.orderedBoards;
        birthdaysController.currentBirthdayInEdit.value;
        return _BListTabView(
          boards: birthdaysController.orderedBoards,
          tabs: [
            ...birthdaysController.orderedBoards
                .map2(
                  (BirthdayBoard list, index) => Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            list.name,
                            style: adapter.textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: list.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
          pagesLength: authService.isAuthenticated.isFalse || birthdaysController.orderedBoards.isEmpty ? 1: birthdaysController.orderedBoards.length,
          initialPage: 0,
          views: [
            ...birthdaysController.orderedBoards.map2((element, int index) {
              return ABListView(
                element,
              );
            }).toList(),
          ],
          actionButton: Obx(
            () {
              if (authService.isAuthenticated.isFalse ||
                  birthdaysController.currentListId.value.isEmpty ||
                  birthdaysController.birthdayBoards[birthdaysController.currentListId.value] == null) {
                return const SizedBox();
              }
              // if (controller.birthdayBoards.value.isNotEmpty) {
              //   return FloatingActionButton.extended(
              //     tooltip: "add a new list",
              //     onPressed: () async {
              //       final String id = const Uuid().v4();
              //       controller.currentBirthdayInEdit(id);
              //       await controller
              //           .updateContent(controller.currentListId.value, {
              //         "birthdays": controller
              //             .birthdayBoards[controller.currentListId.value]!
              //             .withAddedBirthday(ABirthday.empty().copyWith(id: id))
              //             .birthdays
              //             .values
              //             .map((value) => BirthdayFactory().toJson(value))
              //             .toList()
              //       });
              //     },
              //     icon: const Icon(Icons.add),
              //     label: const Text("Add Birthday"),
              //   );
              // }

              return const SizedBox();
            },
          ),

        );
      },
    );
  }
}

class _BListTabView extends StatelessWidget {
  final int initialPage;
  final int pagesLength;
  final List<Tab> tabs;
  final List<Widget> views;
  final Widget? actionButton;
  final List<BirthdayBoard> boards;


  const _BListTabView(
      {required this.initialPage,
      this.actionButton,
      required this.pagesLength,
      required this.boards,
      required this.tabs,
      required this.views,
      Key? key,
     })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pagesLength,
      initialIndex: initialPage,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppTopBar.buildWithBottom(
            context,
            SizedBox(
              width: Adaptive(context).width,
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: TextButton.icon(
                        onPressed: () {
                          birthdaysController.createNewList();
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, foregroundColor: Colors.black87, minimumSize: const Size(90, 50)),
                        icon: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.add),
                        ),
                        label: const Text(
                          "Add",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    // width: Adaptive(context).width-100,
                    // alignment: Alignment.centerLeft,
                    // color: AppRoutes.lists ==
                    //     NavController.instance.currentItem &&
                    //     BirthdaysController.instance.birthdayBoards[
                    //     BirthdaysController.instance.currentListId.value] !=
                    //         null
                    //     ? BirthdaysController
                    //     .instance
                    //     .birthdayBoards[
                    // BirthdaysController.instance.currentListId.value]!
                    //     .color
                    //     : Colors.transparent,
                    child: TabBar(
                        unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
                        labelStyle: Theme.of(context).tabBarTheme.labelStyle,
                        unselectedLabelStyle: Theme.of(context).tabBarTheme.unselectedLabelStyle,
                        labelColor: Colors.black87,
                        // onTap: (int index) {
                        //   // FeedbackService.clearErrorNotification();
                        //   // NavController.instance.withParam("listId",);
                        //   //   BirthdaysController.instance.currentListId( boards[index].id);
                        //   //   BirthdaysController.instance.currentListId.refresh();
                        //   if (index == 0) {
                        //
                        //   }
                        // },
                        isScrollable: true,
                        padding: EdgeInsets.zero,
                        indicatorColor: AppSwatch.primary.shade400,
                        tabs: [
                          if (birthdaysController.birthdayBoards.isEmpty || authService.isAuthenticated.isFalse)
                            const Tab(
                              text: "",
                            ),
                          ...tabs
                        ]),
                  ),
                ],
              ),
            )),
        body: TabBarView(
          children: [
            if (birthdaysController.birthdayBoards.isEmpty || authService.isAuthenticated.isFalse) const BListInfo(),
            ...views
          ],
        ),
        bottomNavigationBar: null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: actionButton,
        ),
      ),
    );
  }
}
