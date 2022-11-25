import 'package:celebrated/domain/model/data.validator.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';

abstract class Request {
  bool validate();

  static bool validateField(Validator validator, String value) {
    if (validator.validate(value) != null) {
      FeedbackService.announce(
        notification: validator.asError(value).copyWith(appWide: false),
      );
      return false;
    }
    return true;
  }
}
