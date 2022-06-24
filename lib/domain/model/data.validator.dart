import 'package:bremind/support/models/app.error.code.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:get/get.dart';

class Validator {
  final String name;
  final List<Validation> validations;

  Validator(this.name, this.validations);

  String? validate(String val) {
    for (var validation in validations) {
      if (validation.test(val) == false) {
        return validation.errorMessage;
      }
    }
    return null;
  }

  AppNotification asError(String val) {
    return AppNotification(
        message: validations.first.errorMessage,
        title: validate(val) ?? "",
        code: ResponseCode.unknownError,
        route: Get.currentRoute,
        stack: "stack",
        appWide: true,
        timestamp: DateTime.now().microsecondsSinceEpoch);
  }
}

class Validation {
  final bool Function(String value) test;
  final String errorMessage;

  Validation(this.test, this.errorMessage);
}
