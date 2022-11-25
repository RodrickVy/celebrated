import 'package:celebrated/domain/model/data.validator.dart';

class Validators {
  /// validators
  static Validator get userNameValidator => Validator("user-name", [
    Validation((value) => value.isNotEmpty, "User name can't be empty"),
    Validation(
            (value) => value.length >= 3, "Your user-name is to short, usernames must have at-list 3 characters"),
    Validation((value) => value.length <= 40,
        "Your user-name is to long, usernames must have no  greater than 40 characters"),
  ]);

  static Validator get emailFormValidator => Validator("user-name", [
    Validation((value) => value.isNotEmpty, "Email can't be empty"),
    Validation((value) => value.length >= 4,
        "Your email is invalid , its too short, emails must have at-list 3 characters"),
    Validation((value) => value.length <= 320,
        "Your email is too long , are you sure its valid? Valid emails cannot be longer than 320 chaarcters."),
  ]);

  static Validator get passwordValidator => Validator("password", [
    Validation((value) => value.isNotEmpty, "Password cannot be empty"),
    Validation((value) => value.length >= 6,
        "Your password is too short and weak, try adding a number, letters and at-list a symbol"),
    Validation((value) => !value.trim().contains(" "), "Your password can't have spaces"),
    Validation((value) => value.length <= 100,
        "Your password is too long is to long,passwords can't exceed 100 characters"),
  ]);

  static Validator get phoneValidator => Validator("phone", [
    Validation((value) => value.isNotEmpty, "Phone number cannot be empty"),
    Validation((value) => value.length >= 5, "Invalid phone number"),
  ]);
}
