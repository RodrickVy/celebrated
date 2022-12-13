import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/model/request.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';

class SignUpEmailRequest extends Request {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final   birthdate;
  final SubscriptionPlan plan;
  final String promotionCode;

  SignUpEmailRequest({
    required this.phoneNumber,
    required this.name,
    required this.plan,
    this.promotionCode = '',
    required this.email,
    required this.password,
    required this.birthdate,
  });

  @override
  bool validate() {
    return Request.validateField(Validators.userNameValidator, name) &&
        Request.validateField(Validators.emailFormValidator, email) &&
        Request.validateField(Validators.passwordValidator, password) &&
        Request.validateField(Validators.phoneValidator, phoneNumber.length > 5 ? phoneNumber: '+17782393874');
  }

  static SignUpEmailRequest empty() {
    return SignUpEmailRequest(
        phoneNumber: '',
        name: "",
        email: "",
        password: "",
        birthdate: DateTime.now(),
        plan: SubscriptionPlan.none);
  }

  SignUpEmailRequest copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    DateTime? birthdate,
    SubscriptionPlan? plan,
    String? promotionCode,
  }) {
    return SignUpEmailRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      birthdate: birthdate ?? this.birthdate,
      plan: plan ?? this.plan,
      promotionCode: promotionCode ?? this.promotionCode,
    );
  }
}
