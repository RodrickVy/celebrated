import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/model/request.dart';

class SignInEmailRequest extends Request {

  final String email;
  final String password;

  SignInEmailRequest(
      {
      required this.email,
      required this.password});

  @override
  bool validate() {
    return Request.validateField(Validators.emailFormValidator, email) &&
        Request.validateField(Validators.passwordValidator, password);
  }

  static SignInEmailRequest empty() {
    return SignInEmailRequest( email: "", password: "");
  }

  SignInEmailRequest copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    DateTime? birthdate,
  }) {
    return SignInEmailRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
