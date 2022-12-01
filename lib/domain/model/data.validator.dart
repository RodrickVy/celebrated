import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:get/get.dart';

class Validator<T> {
  final String name;
  final List<Validation<T>> validations;

  Validator(this.name, this.validations);

  String? validate(T val) {
    for (var validation in validations) {
      if (validation.test(val) == false) {
        return validation.errorMessage?? validation.messageBuilder!(val);
      }
    }
    return null;
  }

  String? announceValidation(T value){
    final String? error = validate(value);

    if (error != null) {
      Get.log(error);
      FeedbackService.announce(
        notification:  AppNotification(
            message: error,
            title: error,
            code: ResponseCode.normal,
            route: Get.currentRoute,
            stack: "stack",
            appWide: false,
            timestamp: DateTime.now().microsecondsSinceEpoch)
      );
      return error;
    }
    return null;
  }

}

class Validation<T> {
  final bool Function(T value) test;
  final String? errorMessage;
 final Function(T value)? messageBuilder;
 
  Validation(this.test, { this.errorMessage,this.messageBuilder}){
    assert([messageBuilder != null , errorMessage !=null].contains(true), "Provide least a messageBuilder or a message, both cant be null");
    assert([messageBuilder != null , errorMessage !=null].contains(false), "Provide least a messageBuilder or a message, both cant be null");
  }
}
