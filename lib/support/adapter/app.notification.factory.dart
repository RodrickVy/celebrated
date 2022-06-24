import 'package:bremind/domain/model/imodel.factory.dart';
import 'package:bremind/support/models/app.error.code.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/support/models/notification.type.dart';

class AppNotificationFactory extends IModelFactory<AppNotification> {

  @override
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

  @override
  AppNotification fromJson(Map<String, dynamic> json) {
    return AppNotification(
      type: json['type'] as NotificationType,
      code: json['code'] as ResponseCode,
      title: json['title'] as String,
      stack: json['stack'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as int,
      route: json['route'] as String,
      appWide: false,
    );
  }

}
