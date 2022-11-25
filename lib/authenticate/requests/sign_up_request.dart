import 'package:celebrated/domain/controller/validators.dart';
import 'package:celebrated/domain/model/Request.dart';

class SignUpEmailRequest extends Request {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final DateTime birthdate;

  SignUpEmailRequest(
      {required this.phoneNumber,
      required this.name,
      required this.email,
      required this.password,
      required this.birthdate});

  @override
  bool validate() {
    return Request.validateField(Validators.userNameValidator, name) &&
        Request.validateField(Validators.emailFormValidator, email) &&
        Request.validateField(Validators.phoneValidator, phoneNumber) &&
        Request.validateField(Validators.passwordValidator, password);
  }

  static SignUpEmailRequest empty() {
    return SignUpEmailRequest(phoneNumber: '', name: "", email: "", password: "", birthdate: DateTime.now());
  }

  SignUpEmailRequest copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    DateTime? birthdate,
  }) {
    return SignUpEmailRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      birthdate: birthdate ?? this.birthdate,
    );
  }
}
