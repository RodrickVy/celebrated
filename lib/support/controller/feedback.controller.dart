import 'package:bremind/domain/repository/amen.content/repository/repository.dart';
import 'package:bremind/support/adapter/app.notification.factory.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/support/models/notification.type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController
    with ContentRepository<AppNotification, AppNotificationFactory> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  final AppNotification empty = AppNotification.empty();

  final AppNotificationFactory docFactory = AppNotificationFactory();

  @override
  final CollectionReference<Map<String, dynamic>> collectionReference =
      firestore.collection('support/feedback/errors');

  static final Rx<AppNotification?> appNotification =
      Rx<AppNotification?>(null);

  static final RxMap<Key, RxBool> __listeners = <Key, RxBool>{}.obs;

  ///kept to remove a spinner to turn spinner off is route is inactive
  static final RxMap<Key, String> _keyToRoute = <Key, String>{}.obs;

  static RxBool listenToSpinner({required Key key}) {
    _keyToRoute.putIfAbsent(key, () => Get.currentRoute);
    __listeners.putIfAbsent(key, () => false.obs);
    return __listeners[key]!;
  }

  static RxBool spinnerDefineState({required Key key, required bool isOn}) {
    _keyToRoute.putIfAbsent(key, () => Get.currentRoute);
    __listeners.putIfAbsent(key, () => isOn.obs);
    return __listeners[key]!;
  }

  static RxBool spinnerUpdateState({required Key key, required bool isOn}) {
    _keyToRoute.putIfAbsent(key, () => Get.currentRoute);
    __listeners.putIfAbsent(key, () => isOn.obs);
    __listeners[key]!(isOn);
    return __listeners[key]!;
  }

  static announce({required AppNotification notification}) {
    FeedbackController.appNotification.value = notification;
    FeedbackController.appNotification.refresh();
    Get.log(
        "error just took place, ${appNotification.value!.message}  ${notification.message} ${notification.appWide}");
  }

  static clearErrorNotification() {
    appNotification.value = null;
    appNotification.refresh();
  }

  static void listenToRoute(Routing route) {
    __listeners.forEach((key, value) {
      if (_keyToRoute[key] != Get.currentRoute) {
        spinnerUpdateState(key: key, isOn: false);
      }
    });
    Get.log("ListenToRoute tapped");
    clearErrorNotification();
  }

  static reportBug(AppNotification notification) async {
    Get.log("Called to report");
     if(notification.type == NotificationType.error){
       try {
         bool success = await FeedbackController().setContent(notification);
         if (success) {
           FeedbackController.clearErrorNotification();
           FeedbackController.announce(
               notification: AppNotification.empty().copyWith(
                   title: "Thank So Much!",
                   message: "The report has been sent and we are on it",
                   type: NotificationType.success));
         } else {
           FeedbackController.announce(
               notification: AppNotification.empty().copyWith(
                   title: "Sorry, An Error occurred",
                   message:
                   "Looks like we cant send the report at the moment, will do it later",
                   type: NotificationType.success));
         }
       }catch(_){
         FeedbackController.announce(
             notification: AppNotification.empty().copyWith(
                 title: _.toString(),
                 message:
                 "Looks like we cant send the report at the moment, will do it later",
                 type: NotificationType.success));
       }
     }


      FeedbackController.clearErrorNotification();

  }


  static bool errorOccurring(){
    return FeedbackController.appNotification.value != null && FeedbackController.appNotification.value!.type == NotificationType.error;
  }
  @override
  onInit() {
    super.onInit();
    appNotification.listen((p0) {
      Get.log("notified");
    });
  }
}
