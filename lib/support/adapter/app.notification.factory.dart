import 'package:bremind/domain/model/imodel.factory.dart';
import 'package:bremind/support/models/app.error.code.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/support/models/notification.type.dart';

class AppNotificationFactory extends IModelFactory<AppNotification> {

  Map<String, dynamic> toJson(AppNotification model) {
    return {
      'type': model.type,
      'code': model.code,
      'title': model.title,
      'stack': model.stack,
      'message': model.message,
      'timestamp': model.timestamp,
      'route': model.route,
    };
  }

  fromJson(Map<String, dynamic> map) {
    return AppNotification(
      type: map['type'] as NotificationType,
      code: map['code'] as AppErrorCodes,
      title: map['title'] as String,
      stack: map['stack'] as String,
      message: map['message'] as String,
      timestamp: map['timestamp'] as int,
      route: map['route'] as String,
    );
  }

}
