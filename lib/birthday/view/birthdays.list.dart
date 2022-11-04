import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/birthday/adapter/birthdays.factory.dart';
import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/birthday/model/birthday.dart';
import 'package:celebrated/birthday/model/birthday.list.dart';
import 'package:celebrated/birthday/view/b.list.empty.dart';
import 'package:celebrated/birthday/view/b.list.view.dart';
import 'package:celebrated/domain/view/app.page.view.dart';
import 'package:celebrated/domain/view/editable.text.field.dart';
import 'package:celebrated/navigation/views/app.bar.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/list.extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class BirthdayBoardsView extends AppPageView {
 const  BirthdayBoardsView({Key? key}) : super(key: key);

 static final BirthdaysController controller =Get.find<BirthdaysController>();

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        controller.orderedBoards;
        controller.currentBirthdayInEdit.value;
        return BListTabView(
          boards: controller.orderedBoards,
          tabs: [
            ...controller.orderedBoards
                .map2(
                  (BirthdayBoard list, index) => Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: EditableTextView(
                              icon: Icons.delete,
                              onIconPressed: () {},
                              key:  Key(list.name),
                              textValue: list.name,
                              label: 'list name',
                              background: Colors.transparent,
                              onSave: (String value) async {
                                FeedbackService.spinnerUpdateState(
                                    key: Key(list.name), isOn: true);
                                await controller
                                    .updateContent(list.id, {"name": value});
                                FeedbackService.spinnerUpdateState(
                                    key: Key(list.name), isOn: false);
                              },
                            ),
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
            Tab(
              child: GestureDetector(
                onTap: () async {
                  await controller.createNewList();
                },
                child: Row(
                  children: const [
                    Text(
                      "Add",
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ],
          pagesLength: controller.orderedBoards.length + 1,
          initialPage: 0,
          views: [
            ...controller.orderedBoards.map2((element, int index) {
              return BListView(
                element,
              );
            }).toList(),
            BListInfo(),
          ],
          actionButton: Obx(
            () {
              if (AuthController.instance.isAuthenticated.isFalse ||
                  controller.currentListId.value.isEmpty ||
                  controller.birthdayBoards[controller.currentListId.value] ==
                      null) {
                return const SizedBox();
              }
              if (controller.birthdayBoards.value.isNotEmpty) {
                return FloatingActionButton.extended(
                  tooltip: "add a new list",
                  onPressed: () async {
                    final String id = const Uuid().v4();
                    controller.currentBirthdayInEdit(id);
                    await controller
                        .updateContent(controller.currentListId.value, {
                      "birthdays": controller
                          .birthdayBoards[controller.currentListId.value]!
                          .withAddedBirthday(ABirthday.empty().copyWith(id: id))
                          .birthdays
                          .values
                          .map((value) => BirthdayFactory().toJson(value))
                          .toList()
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Birthday"),
                );
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}

class BListTabView extends StatelessWidget {
  final int initialPage;
  final int pagesLength;
  final List<Tab> tabs;
  final List<Widget> views;
  final Widget? actionButton;
  final List<BirthdayBoard> boards;

  const BListTabView(
      {required this.initialPage,
      this.actionButton,
      required this.pagesLength,
      required this.boards,
      required this.tabs,
      required this.views,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pagesLength,
      initialIndex: initialPage,
      child: Scaffold(
        appBar: AppTopBar.buildWithBottom(
            context,
            Container(
              width: Adaptive(context).width,
              alignment: Alignment.centerLeft,
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
                  unselectedLabelColor:
                      Theme.of(context).tabBarTheme.unselectedLabelColor,
                  labelStyle: Theme.of(context).tabBarTheme.labelStyle,
                  unselectedLabelStyle:
                      Theme.of(context).tabBarTheme.unselectedLabelStyle,
                  labelColor: Colors.black87,
                  onTap: (int index) {
                    // FeedbackService.clearErrorNotification();
                    // NavController.instance.withParam("listId",);
                    //   BirthdaysController.instance.currentListId( boards[index].id);
                    //   BirthdaysController.instance.currentListId.refresh();
                    if(index == boards.length){
                      BirthdaysController.instance.createNewList();
                    }
                  },
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
                  tabs: tabs),
            )),
        body: TabBarView(
          children: views,
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
