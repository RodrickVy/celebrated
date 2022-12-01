import 'package:celebrated/domain/model/data.validator.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:phone_form_field/phone_form_field.dart';

class Validators {

  static Validator get birthdayValidator => Validator<DateTime>("birthdate", [

  ]);
  /// validators
  static Validator get userNameValidator => Validator<String>("user-name", [
    Validation((value) => value.isNotEmpty, errorMessage: "User name can't be empty"),
    Validation(
            (value) => value.length >= 3, errorMessage: "Your user-name is to short, usernames must have at-list 3 characters"),
    Validation((value) => value.length <= 40,errorMessage:
    "Your user-name is to long, usernames must have no  greater than 40 characters"),
  ]);

  static Validator get emailFormValidator => Validator<String>("user-email", [
    Validation((value) => value.isNotEmpty,errorMessage:  "Email can't be empty"),
    Validation((value) => value.contains('.'),errorMessage:  "Email is invalid format"),
    Validation((value) => value.contains('@'),errorMessage:  "Email is invalid format"),
    Validation((value) => value.length >= 4,errorMessage:
    "Your email is invalid , its too short, emails must have at-list 3 characters"),
    Validation((value) => value.length <= 320,errorMessage:
    "Your email is too long , are you sure its valid? Valid emails cannot be longer than 320 chaarcters."),
  ]);

  static Validator get passwordValidator => Validator<String>("password", [
    Validation((value) => value.isNotEmpty,errorMessage: "Password cannot be empty"),
    Validation((value) => value.length >= 6,errorMessage:
    "Your password is too short and weak, try adding a number, letters and at-list a symbol"),
    Validation((value) => !value.trim().contains(" "), errorMessage: "Your password can't have spaces"),
    Validation((value) => value.length <= 100,errorMessage:
    "Your password is too long is to long,passwords can't exceed 100 characters"),
  ]);

  static Validator<String> get phoneValidator => Validator<String>("phone", [

    Validation((value) => value.isNotEmpty, errorMessage: "Phone number cannot be empty"),
    Validation((value) => value.length >= 5, errorMessage: "Invalid phone number"),
    Validation((value) => PhoneNumber.parse(value).isValid() !=  false,errorMessage: "Invalid phone number.")
  ]);


  static bool validateField(Validator validator, String value) {
    if (validator.validate(value) != null) {
       validator.announceValidation(value);

      return false;
    }
    return true;
  }
}