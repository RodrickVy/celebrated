// ignore_for_file: prefer_for_elements_to_map_fromiterable

import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/models/account.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/adapter/birthdays.factory.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/services/app.initializing.state.dart';
import 'package:celebrated/domain/services/content.store/model/query.dart';
import 'package:celebrated/domain/services/content.store/model/query.methods.dart';
import 'package:celebrated/domain/services/content.store/repository/repository.dart';
import 'package:celebrated/lists/adapter/birthday.list.factory.dart';
import 'package:celebrated/lists/data/static.data.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/lists/model/birthday.list.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/lists/model/settings.ui.dart';
import 'package:celebrated/lists/view/pages/list.shared.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:celebrated/domain/services/instances.dart';

class BirthdaysController extends GetxController with ContentStore<BirthdayBoard, BirthdayBoardFactory> {
  final RxMap<String, BirthdayBoard> birthdayLists = RxMap<String, BirthdayBoard>({});
  final RxMap<String, BirthdayBoard> trackedLists = RxMap<String, BirthdayBoard>({});

  static final BirthdaysController __instance = BirthdaysController._();

  BirthdaysController._();

  factory BirthdaysController() {
    return __instance;
  }

  String get currentListId => Get.parameters['id'] ?? '';

  BirthdayBoard? get currentList => birthdayLists[currentListId];

  static final Rx<BirthdayBoard?> listInView = Rx<BirthdayBoard?>(null);

  @override
  BirthdayBoard get empty => BirthdayBoard.empty();

  @override
  BirthdayBoardFactory get docFactory => BirthdayBoardFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference => firestore.collection('lists');

  @override
  void onInit() {
    super.onInit();

    authService.userLive.listen((UserAccount user) async {
      if (user.isAuthenticated) {
        // FeedbackService.spinnerUpdateState(key:FeedbackSpinKeys.appWide, isOn: true);

        final Map<String, BirthdayBoard> list =
            Map.fromIterable(await getCollectionAsList(null), key: (e) => e.id, value: (e) => e);

        birthdayLists.assignAll(list);
       await getTrackedLists();
        // trackedLists(Map.fromIterable(await getTrackedLists(), key: (e) => e.id, value: (e) => e));
        // FeedbackService.spinnerUpdateState(key:FeedbackSpinKeys.appWide, isOn: false);
        // BirthdaysController.instance.currentListId( orderedBoards.isNotEmpty ? orderedBoards[0].id:"");
        //         // BirthdaysController.instance.currentListId.refresh();
        // birthdayBoards.values.map((e)async{
        //   if(e.authorName != AuthController.instance.accountUser.value.displayName){
        //     await updateContent(e.id,{"authorName":AuthController.instance.accountUser.value.displayName});
        //   }
        // });
      }
    });
  }

  List<BirthdayBoard> get orderedBoards {
    // final String? idInRoute = Get.parameters["listId"];
    if (birthdayLists.isNotEmpty && currentList != null) {
      return [
        ...birthdayLists.values.where((element) {
          return element.id == currentListId;
        }).toList(),
        ...birthdayLists.values.where((element) {
          return element.id != currentListId;
        }).toList()
      ];
    } else {
      return birthdayLists.values.toList();
    }
  }

  @override
  Future<List<BirthdayBoard>> getCollectionAsList(ContentQuery? query) async {
    return await queryCollection(
        query ?? ContentQuery("authorId", QueryMethods.isEqualTo, authService.userLive.value.uid));
  }

  Future<List<BirthdayBoard>> getTrackedLists() async {
    final Map<String, BirthdayBoard> tracked =
    Map.fromIterable(await queryCollection(ContentQuery("watchers", QueryMethods.arrayContains, authService.userLive.value.uid)), key: (e) => e.id, value: (e) => e);
    trackedLists.assignAll(tracked);
    return tracked.values.toList();
  }

  @override
  Future<BirthdayBoard> updateContent(String id, Map<String, dynamic> changes) async {
    BirthdayBoard data = (await super.updateContent(id, {...changes}));
    birthdayLists[id] = data;
    return data;
  }

  @override
  Future<bool> setContent(BirthdayBoard data) async {
    birthdayLists[data.id] = data;
    bool success = (await super.setContent(data));
    return success;
  }

  @override
  Future<bool> deleteContent(String id) async {
    bool success = (await super.deleteContent(id));
    birthdayLists.remove(id);
    return success;
  }

  bool __colorUsedByOtherLists(int hex) {
    return birthdayLists.values.where((element) => element.hex == hex).toList().isNotEmpty;
  }

  List<int> __listsUsableColors({int? listColor}) {
    if (listColor != null) {
      return [
        listColor,
        ...StaticData.colorsList.where((int hex) {
          return !__colorUsedByOtherLists(hex);
        }).toList()
      ];
    } else {
      return StaticData.colorsList.where((int hex) {
        return !__colorUsedByOtherLists(hex);
      }).toList();
    }
  }

  /// creates a new birthday list
  Future<String?> createNewList() async {
    if (authService.user.isAuthenticated) {
      final String id = IDGenerator.generateId(10, authService.user.uid);

      final int unnamedListsLength = orderedBoards
          .where((element) => element.name.toLowerCase().replaceAll(' ', '').contains("newlist"))
          .toList()
          .length;

      final String name = unnamedListsLength == 0 ? "New List" : "New list $unnamedListsLength";

      String getListName() {
        if (unnamedListsLength == 0) {
          return "New List";
        }
        int number = unnamedListsLength;
        String listName = "New List";
        while (orderedBoards.where((element) => element.name == listName).isNotEmpty) {
          listName = "New list ${number + 1}";
          number++;
        }
        return listName;
      }

      /// set content to firestore
      await setContent(BirthdayBoard.empty().copyWith(
          id: id,
          name: getListName(),
          authorName: authService.userLive.value.name,
          hex: __listsUsableColors().first,
          authorId: authService.userLive.value.uid));

      /// route to list/id immediately,so the view shows this newly created list
      selectList(id);
      return id;
    }
    return null;
  }

  final RxString currentBirthdayInEdit = "".obs;

  void setBirthdayInEditMode(String id) {
    // Get.log("This birthday id is -$id-");
    // NavController.instance.withParam("editingBId", id);
    currentBirthdayInEdit(id);
  }

  void closeBirthdayEditor() {
    // NavController.instance.popParam("editingBId");
    // Get.back();
    currentBirthdayInEdit("");
  }

  Future<BirthdayBoard> loadBoardFromShareUrl() async {
    if (Get.parameters["code"] != null) {
      print("calling  the list!");
      try {
        final List<BirthdayBoard> list =
            await getCollectionAsList(ContentQuery("viewingId", QueryMethods.isEqualTo, Get.parameters["code"]!));
        if (list.isEmpty) {
          return BirthdayBoard.empty();
        }

        listInView(list.first);
        return list.first;
      } catch (_) {}
    }
    if (listInView.value == null) {
      print("Updated the list!");
      listInView(BirthdayBoard.empty());
    }
    print("Updated the list!");
    return BirthdayBoard.empty();
  }

  Future<ABirthday> birthdayFromBirthdayId() async {
    final String? listId = Get.parameters["list"];
    final String? birthdayId = Get.parameters["birthdayId"];

    if (listId == null || birthdayId == null) {
      FeedbackService.announce(
          notification: FeedbackService.announce(
        ///todo change Error Codes to notification codes
        notification: AppNotification(
            message: '',
            appWide: true,
            type: NotificationType.neutral,
            title: "Oops! something wrong with this route, this birthday isn't found",
            code: ResponseCode.accessRestricted,
            child: Theme(
              data: AppTheme.themeData,
              child: Row(
                children: [
                  AppButton(
                    onPressed: () {
                      navService.to(AppRoutes.home);
                      // todo assess why FeedbackService doesn't sort this out on its own
                      FeedbackService.clearErrorNotification();
                    },
                    label: "Report Error",
                  )
                ],
              ),
            )),
      ));
      return ABirthday.empty();
    } else {
      BirthdayBoard board = await getContent(listId);
      if (board.birthdays.containsKey(birthdayId)) {
        return board.birthdays[birthdayId]!;
      } else {
        FeedbackService.announce(
            notification: FeedbackService.announce(
          ///todo change Error Codes to notification codes
          notification: AppNotification(
              message: '',
              type: NotificationType.neutral,
              title: "Oops! something wrong with this route, this birthday isn't found",
              appWide: true,
              code: ResponseCode.accessRestricted,
              child: Theme(
                data: AppTheme.themeData,
                child: Row(
                  children: [
                    AppButton(
                      onPressed: () {
                        navService.to(AppRoutes.home);
                        // todo assess why FeedbackService doesn't sort this out on its own
                        FeedbackService.clearErrorNotification();
                      },
                      label: "Report Error",
                    )
                  ],
                ),
              )),
        ));
        return ABirthday.empty();
      }
    }
  }

  String getBirthdayShareRoute(String listId, String birthdayId) {
    return "${AppRoutes.birthday}?list=$listId&birthdayId=$birthdayId";
  }

  String getBirthdayShareUrl(String listId, String birthdayId) {
    return "${AppRoutes.domainUrlBase}${AppRoutes.birthday}?list=$listId&birthdayId=$birthdayId";
  }

  sendReminders() {}

  RxBool showNotificationSettings = false.obs;

  Rx<SettingBox> currentSettingBox = SettingBox.none.obs;

  Future<void> updateListsStartReminding(BirthdayBoard board, int remindTime) async {
    await updateContent(board.id, {'startReminding': remindTime});
  }

  Future<void> addBirthday(
    BirthdayBoard board,
  ) async {
    final String id = IDGenerator.generateId(10, board.id);
    currentBirthdayInEdit(id);
    await updateContent(board.id, {
      "birthdays": board
          .withAddedBirthday(ABirthday.empty().copyWith(id: id))
          .birthdays
          .values
          .map((value) => BirthdayFactory().toJson(value))
          .toList()
    });
  }

  Future<void> deleteBirthday(BirthdayBoard board, ABirthday birthday) async {
    await birthdaysController.updateContent(board.id, {
      "birthdays": board
          .withRemovedBirthday(birthday.id)
          .birthdays
          .values
          .map((value) => BirthdayFactory().toJson(value))
          .toList()
    });
    currentBirthdayInEdit("");
  }

  Future<void> saveBirthdayDetails(BirthdayBoard board, ABirthday birthday) async {
    await updateContent(board.id, {
      "birthdays":
          board.withAddedBirthday(birthday).birthdays.values.map((value) => BirthdayFactory().toJson(value)).toList()
    });
    closeBirthdayEditor();
  }

  void selectList(String id) {
    navService.to("${AppRoutes.lists}/$id");
  }

  Future<void> deleteList(String id) async {
    await deleteContent(id);
    navService.to(AppRoutes.lists);
  }

  Future<void> stopTrackingList(BirthdayBoard board) async {
    FeedbackService.prompt(title: "Stop reminders from this list?", actions: [
      OptionAction("Cancel", Icons.abc, () {
        FeedbackService.clearErrorNotification();
      }),
      OptionAction("Confirm", Icons.abc, () async {
        listInView(await updateContent(
            board.id, {"watchers": board.watchers.where((watcher) => watcher != authService.user.uid)}));
        FeedbackService.clearErrorNotification();
      })
    ]);
  }

  Future<void> trackList(BirthdayBoard board) async {
    if (authService.user.isUnauthenticated) {
      navService.routeKeepNext(AppRoutes.authSignUp, "${AppRoutes.shareList}/?${board.viewingId}&action=track");
    } else {
      listInView(await updateContent(board.id, {
        "watchers": [...board.watchers, authService.user.uid]
      }));
    }
  }
}

final BirthdaysController birthdaysController = BirthdaysController();
