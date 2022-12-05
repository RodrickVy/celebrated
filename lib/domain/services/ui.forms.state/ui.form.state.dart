import 'package:celebrated/authenticate/requests/signin.request.dart';
import 'package:celebrated/authenticate/requests/signup.request.dart';
import 'package:celebrated/subscription/models/subscription.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';
import 'package:get/get.dart';

/// A service to keep track of  all app's forms ephemeral state, this also helps us avoid request the user data twice, as it it can use data
/// from a form previously field.
///  eg. after truing to signing and it fails since unregistered, I can go to the sign up page and not have to reenter my email and password again.
///  This functionality is across different features, but context is considered when reusing data to avoid mismatching data.

class UIFormState {
  static RxString name = ''.obs;
  static RxString email = ''.obs;
  static RxString password = ''.obs;
  static Rx<DateTime> birthdate = DateTime.now().obs;
  static RxString phoneNumber = ''.obs;
  static RxString promoCode = ''.obs;
  static RxString authCode = ''.obs;
  static Rx<SubscriptionPlan> subscriptionPlan = SubscriptionPlan.free.obs;
  static RxBool signInLinkSent  = false.obs;
  static SignInEmailRequest get signInFormData => SignInEmailRequest(email: email.value, password: password.value);

  static SignUpEmailRequest get signUpFormData => SignUpEmailRequest(
      email: email.value, password: password.value, phoneNumber: phoneNumber.value,plan: subscriptionPlan.value,promotionCode: promoCode.value, name: name.value, birthdate: birthdate.value);


  const UIFormState();



}
