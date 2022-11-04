import 'package:celebrated/domain/repository/amen.content/repository/repository.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/adapter/app.notification.factory.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Service that handles feedback related business in the app:
/// It manages two systems currently:
///
/// 1. AppNotification - a system for easily showing error,success and warning messages to the user.
/// 2. FeedbackSpinners - simple widget wrapper to add a live feedback to the user. explained well in [FeedbackSpinner] comments.
/// 3. UserBug reporting - system that allows the user to report an error , right when it happens and see how we are dealing with it.
class FeedbackService extends GetxController
    with ContentRepository<AppNotification, AppNotificationFactory> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  @override
  AppNotification get empty => AppNotification.empty();

  @override
  AppNotificationFactory get docFactory => AppNotificationFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference =>
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

  /// called anytime one wants to send a message to user.
  static announce({required AppNotification notification}) {
    Get.log(notification.message.toString());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeedbackService.appNotification.value = notification;
      if (notification.aliveFor != null) {
        Future.delayed(notification.aliveFor!, () {
          if (FeedbackService.appNotification.value?.id == notification.id) {
            FeedbackService.clearErrorNotification();
          }
        });
      }
    });
  }

  /// clears all notifications , whether app wide or local
  static clearErrorNotification() {
    appNotification.value = null;
  }

  /// simple way to check if is experiencing any errors at the moment
  static bool errorOccurring() {
    return FeedbackService.appNotification.value != null &&
        FeedbackService.appNotification.value!.type == NotificationType.error;
  }

  /// method called by routerCallback in MaterialApp so that notifications
  /// are cleared whenever user navigates to another page.
  static void listenToRoute(Routing route) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      clearErrorNotification();
      __listeners.forEach((key, value) {
        if (_keyToRoute[key] != Get.currentRoute) {
          spinnerUpdateState(key: key, isOn: false);
        }
      });


    });

  }

  ///
  static reportBug(AppNotification notification) async {
    Get.log("Called to report");
    if (notification.type == NotificationType.error) {
      try {
        bool success = await FeedbackService().setContent(notification);
        if (success) {
          FeedbackService.clearErrorNotification();
          FeedbackService.announce(
              notification: AppNotification.empty().copyWith(
                  title: "Thank So Much!",
                  message: "The report has been sent and we are on it",
                  type: NotificationType.success));
        } else {
          FeedbackService.announce(
              notification: AppNotification.empty().copyWith(
                  title: "Sorry, An Error occurred",
                  message:
                      "Looks like we cant send the report at the moment, will do it later",
                  type: NotificationType.success));
        }
      } catch (_) {
        FeedbackService.announce(
            notification: AppNotification.empty().copyWith(
                title: _.toString(),
                message:
                    "Looks like we cant send the report at the moment, will do it later",
                type: NotificationType.success));
      }
    }

    FeedbackService.clearErrorNotification();
  }

  @override
  onInit() {
    super.onInit();
    appNotification.listen((p0) {
      Get.log("notified");
    });
  }

  static void announceSignUpPromo() {
    FeedbackService.announce(
        notification: AppNotification.empty().copyWith(
            title:
                "Make 'Happy belated birthdays' a thing of the past. 100% Free & Privacy Guaranteed.  ",
            type: NotificationType.neutral,
            appWide: false,
            icon: const Icon(
              Icons.cake,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 5,
                runSpacing: 5,
                children: [
                  AppButton(
                      key: UniqueKey(),
                      child: const Text("Signup"),
                      onPressed: () {
                        NavController.instance.to(AppRoutes.authSignUp);
                      }),
                  AppButton(
                      key: UniqueKey(),
                      child: const Text("more-info"),
                      onPressed: () {
                        NavController.instance.to(AppRoutes.splash);
                      }),
                ],
              ),
            )));
  }

  static void successAlertSnack(String title,[time = 800]) {
    FeedbackService.announce(
        notification: AppNotification.empty().copyWith(
            type: NotificationType.success,
            title: title,
            aliveFor:  Duration(milliseconds: time)));
  }

  static void blockPrompt({required String title, required Widget child}) {
    FeedbackService.announce(
        notification: AppNotification.empty().copyWith(
            icon: const Icon(
              Icons.cake,
            ),
          appWide: true,
            type: NotificationType.neutral, title: title,child: child, canDismiss: true));
  }
}
