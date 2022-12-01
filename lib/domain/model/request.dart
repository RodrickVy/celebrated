import 'package:celebrated/domain/model/data.validator.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';

abstract class Request {
  bool validate();

  static bool validateField<T>(Validator<T> validator, T value) {
    return validator.announceValidation(value) == null;
  }

  const Request();
}
