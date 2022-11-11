import 'package:celebrated/birthday/model/birthday.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// service that handles device notifications
class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future selectNotification(String payload) async {
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }



  Future<void> showBirthdayNotification(ABirthday birthday) async {
     const AndroidNotificationDetails _androidNotificationDetails =
    AndroidNotificationDetails(
      'channel ID',
      'channel name',
      // 'channel description',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );

     const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: _androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      "🥳🎉🎉${birthday.name}'s birthday in  ${birthday.daysRemaining()>1?'s':''}!",
      '${birthday.name} is turning ${birthday.age()}. ',
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
