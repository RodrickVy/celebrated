import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// service that handles device notifications
class NotificationService extends GetxController {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<String?> get fcmToken async {
    if (GetPlatform.isWeb) {
      return await FirebaseMessaging.instance.getToken(
          vapidKey: "BHjXYobRuDg78x674QLTK5mAUw9gwbMMOKHDhY2Vmq4Ob-qKF5EcZ6Qoug_pGgZUrkmwBEz0J4KRGKBMltOG2KU");
    }
    return await FirebaseMessaging.instance.getToken();
  }

  //Singleton pattern
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  @override
  void onInit() async {
    super.onInit();

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.denied:
      case AuthorizationStatus.notDetermined:
        FeedbackService.announce(
            notification: AppNotification(
          appWide: true,
          title: "Want to use phone notifications for reminders? allow celebrated on your permissions",
        ));
        break;
      case AuthorizationStatus.provisional:
      case AuthorizationStatus.authorized:
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        FeedbackService.announce(
            notification: AppNotification(
          appWide: true,
          title: "${message.data['message']}",
        ));
      }
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      if (message.notification != null) {
        sendNotification(message.data['message'], '');
      }
    });
  }

  Future selectNotification(String payload) async {
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  Future<void> showBirthdayNotification(ABirthday birthday) async {
    const AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
      'channel ID',
      'channel name',
      // 'channel description',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: _androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      "🥳🎉🎉${birthday.name}'s birthday in  ${birthday.daysRemaining() > 1 ? 's' : ''}!",
      '${birthday.name} is turning ${birthday.age()}. ',
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  Future<void> sendNotification(String message, String body) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel ID',
      'channel name',
      // 'channel description',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      message,
      body,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }
//
// Future<void> showBirthdayNotification(ABirthday birthday) async {
//   const AndroidNotificationDetails _androidNotificationDetails =
//   AndroidNotificationDetails(
//     'channel ID',
//     'channel name',
//     'channel description',
//     playSound: true,
//     priority: Priority.high,
//     importance: Importance.high,
//   );
//
//   const NotificationDetails platformChannelSpecifics =
//   NotificationDetails(android: _androidNotificationDetails);
//
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     "🥳🎉🎉${birthday.name}'s birthday in  ${birthday.daysRemaining()>1?'s':''}!",
//     '${birthday.name} is turning ${birthday.age()}. ',
//     platformChannelSpecifics,
//     payload: 'Notification Payload',
//   );
// }
}

NotificationService notificationService = NotificationService();
