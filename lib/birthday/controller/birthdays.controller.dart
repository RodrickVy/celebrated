// ignore_for_file: prefer_for_elements_to_map_fromiterable

import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/birthday/adapter/birthday.list.factory.dart';
import 'package:celebrated/birthday/controller/birthday.board.view.controller.dart';
import 'package:celebrated/birthday/data/static.data.dart';
import 'package:celebrated/birthday/interface/birthday.controller.interface.dart';
import 'package:celebrated/birthday/model/birthday.dart';
import 'package:celebrated/birthday/model/birthday.list.dart';
import 'package:celebrated/domain/repository/amen.content/model/query.dart';
import 'package:celebrated/domain/repository/amen.content/model/query.methods.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/domain/repository/amen.content/repository/repository.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class BirthdaysController extends GetxController
    with
        ContentRepository<BirthdayBoard, BirthdayBoardFactory>,
        BoardsViewController
    implements BirthdayControllerInterface {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  @override
  RxMap<String, BirthdayBoard> birthdayBoards =
      RxMap<String, BirthdayBoard>({});

  static BirthdaysController instance = Get.find<BirthdaysController>();

  @override
  BirthdayBoard get empty => BirthdayBoard.empty();

  @override
  BirthdayBoardFactory get docFactory => BirthdayBoardFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference =>
      firestore.collection('lists');

  @override
  void onInit() {
    super.onInit();
    AuthController.instance.isAuthenticated.listen((authenticated) async {
      if (authenticated) {
        birthdayBoards(Map.fromIterable(await getCollectionAsList(null),
            key: (e) => e.id, value: (e) => e));
        BirthdaysController.instance.currentListId( orderedBoards.isNotEmpty ? orderedBoards[0].id:"");
        BirthdaysController.instance.currentListId.refresh();
        // birthdayBoards.values.map((e)async{
        //   if(e.authorName != AuthController.instance.accountUser.value.displayName){
        //     await updateContent(e.id,{"authorName":AuthController.instance.accountUser.value.displayName});
        //   }
        // });
      }
    });
    FeedbackService.appNotification.listen((AppNotification? error) {
      if (error != null) {
        FeedbackService.spinnerUpdateState(
            key: FeedbackSpinKeys.signUpForm, isOn: false);
        FeedbackService.spinnerUpdateState(
            key: FeedbackSpinKeys.signInForm, isOn: false);
        FeedbackService.spinnerUpdateState(
            key: FeedbackSpinKeys.authProviderButtons, isOn: false);
        FeedbackService.spinnerUpdateState(
            key: FeedbackSpinKeys.passResetForm, isOn: false);
      }
    });
  }

  @override
  Future<List<BirthdayBoard>> getCollectionAsList(ContentQuery? query) async {
    return await queryCollection(query ??
        ContentQuery("authorId", QueryMethods.isEqualTo,
            AuthController.instance.accountUser.value.uid));
  }

  @override
  Future<BirthdayBoard> updateContent(
      String id, Map<String, dynamic> changes) async {
    BirthdayBoard data = (await super.updateContent(id, {...changes}));
    birthdayBoards[id] = data;
    return data;
  }

  @override
  Future<bool> setContent(BirthdayBoard data) async {
    birthdayBoards[data.id] = data;
    bool success = (await super.setContent(data));
    return success;
  }

  @override
  Future<bool> deleteContent(String id) async {
    bool success = (await super.deleteContent(id));
    birthdayBoards.remove(id);
    return success;
  }

  bool __colorUsedByOtherLists(int hex) {
    return birthdayBoards.values
        .where((element) => element.hex == hex)
        .toList()
        .isNotEmpty;
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
  @override
  Future<String?> createNewList() async {
    if (AuthController.instance.isAuthenticated.isTrue) {
      final String id = const Uuid().v4();

      /// set content to firestore
      await setContent(BirthdayBoard.empty().copyWith(
          id: id,
          name: "New List",
          authorName: AuthController.instance.accountUser.value.name,
          hex: __listsUsableColors().first,
          authorId: AuthController.instance.accountUser.value.uid));

      /// route to list/id immediately,so the view shows this newly created list
      currentListId(id);
      return id;
    }
    return null;
  }

  final RxString currentBirthdayInEdit = "".obs;

  void editBirthday(String id) {
    // Get.log("This birthday id is -$id-");
    // NavController.instance.withParam("editingBId", id);
    currentBirthdayInEdit(id);
  }

  void closeBirthdayEditor() {
    // NavController.instance.popParam("editingBId");
    // Get.back();
    currentBirthdayInEdit("");
  }

  Future<BirthdayBoard> boardFromViewId() async {
    if (Get.parameters["link"] != null) {
      try {
        return (getCollectionAsList(ContentQuery(
                "viewingId", QueryMethods.isEqualTo, Get.parameters["link"]!)))
            .then((value) {
          if (value.isEmpty) {
            return BirthdayBoard.empty();
          }
          if (AuthController.instance.isAuthenticated.isFalse) {
            /// asks user to sign up if they are just visiting to view list
            FeedbackService.announceSignUpPromo();
          }

          return value.first;
        }).catchError((_) => throw _.message);
      } catch (_) {
        return BirthdayBoard.empty();
      }
    } else {
      return BirthdayBoard.empty();
    }
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
                    key: UniqueKey(),
                    onPressed: () {
                      NavController.instance.to(AppRoutes.home);
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
              title:
                  "Oops! something wrong with this route, this birthday isn't found",
              appWide: true,
              code: ResponseCode.accessRestricted,
              child: Theme(
                data: AppTheme.themeData,
                child: Row(
                  children: [
                    AppButton(
                      key: UniqueKey(),
                      onPressed: () {
                        NavController.instance.to(AppRoutes.home);
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


  sendReminders(){

  }
}
