import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/requests/signin.request.dart';
import 'package:celebrated/authenticate/requests/signup.request.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/domain/view/components/forms/phone.form.field.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/util/date.dart';
import 'package:celebrated/util/fomatters.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  /// using text input instead of calender for inputing dates
  static RxBool textDateInput = true.obs;
  static Rx<SubscriptionPlan> subscriptionPlan = SubscriptionPlan.free.obs;
  static RxBool signInLinkSent = false.obs;

  static RxString birthdateString = ''.obs;

  static SignInEmailRequest get signInFormData => SignInEmailRequest(email: email.value, password: password.value);

  static SignUpEmailRequest get signUpFormData => SignUpEmailRequest(
      email: email.value,
      password: password.value,
      phoneNumber: phoneNumber.value,
      plan: subscriptionPlan.value,
      promotionCode: promoCode.value,
      name: name.value,
      birthdate: birthdate.value);

  const UIFormState();

  static AppTextField get nameField => AppTextField(
        label: "name",
        autoFocus: GetPlatform.isDesktop,
        fieldIcon: Icons.account_circle_sharp,
        decoration: AppTheme.inputDecoration,
        controller: TextEditingController(text: UIFormState.signUpFormData.name),
        onChanged: (data) {
          UIFormState.name(data);
        },
        hint: 'enter your name',
        autoFillHints: const [AutofillHints.name],
      );

  static AppTextField get emailField => AppTextField(
        fieldIcon: Icons.email,
        label: "Email",
        hint: "eg. example@gmail.com",
        autoFocus: GetPlatform.isDesktop,
        controller: TextEditingController(text: UIFormState.signUpFormData.email),
        onChanged: (data) {
          UIFormState.email(data.trim());
        },
        keyboardType: TextInputType.emailAddress,
        autoFillHints: const [AutofillHints.email, AutofillHints.username],
      );

  static AppTextField get passwordField => AppTextField(
        fieldIcon: Icons.vpn_key,
        label: "Password",
        autoFocus: GetPlatform.isDesktop,
        hint: "minimum 6 characters",
        controller: TextEditingController(text: UIFormState.signUpFormData.password),
        onChanged: (data) {
          UIFormState.password(data);
        },
        obscureOption: true,
        keyboardType: TextInputType.visiblePassword,
        autoFillHints: const [AutofillHints.password],
      );

  static FormPhoneField get phoneField => FormPhoneField(
        autoFocus: GetPlatform.isDesktop,
        initialValue: UIFormState.signUpFormData.phoneNumber,
        onChanged: (PhoneNumber? p) {
          if (p != null) {
            UIFormState.phoneNumber(p.international);
          }
        },
      );

  // static SfDateRangePicker get dateField => SfDateRangePicker(
  //       selectionMode: DateRangePickerSelectionMode.single,
  //       onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
  //         UIFormState.birthdate(args.value);
  //       },
  //       view: DateRangePickerView.century,
  //       showNavigationArrow: true,
  //       // showActionButtons: true,
  //       maxDate: DateTime.now(),
  //     );

  static Widget dateField([DateTime? initialValue]) {
    if(initialValue != null){
      UIFormState.birthdate(initialValue);

    }
    return AppTextField(
      fieldIcon: Icons.email,
      label: "Date (dd-mm-yyyy)",
      hint: "dd-mm-yyyy",
      autoFocus: GetPlatform.isDesktop,
      inputFormatters: [DateTextFormatter()],
      controller:
          TextEditingController(text: (initialValue??UIFormState.birthdate.value).toIso8601String().split('T').first.split('-').reversed.join('/')),
      onChanged: (data) {
        birthdateString(data);
       if(data.length == 10){
          DateTime date = DateTime.parse(data.split("/").reversed.join('-'));
          UIFormState.birthdate(date);
        }

      },
      keyboardType: TextInputType.datetime,
      autoFillHints: const [AutofillHints.email, AutofillHints.username],
    );

    // return SfDateRangePicker(
    //   selectionMode: DateRangePickerSelectionMode.single,
    //   onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
    //     UIFormState.birthdate(args.value);
    //   },
    //   selectionColor: AppSwatch.primary,
    //   selectionRadius: 12,
    //   showNavigationArrow: true,
    //   onSubmit: (d) {
    //     onSave != null ? onSave() : () {};
    //   },
    //   onCancel: () {
    //     onCancel != null ? onCancel() : () {};
    //   },
    //   showActionButtons: true,
    //   initialDisplayDate: initialValue,
    //   maxDate: DateTime.now(),
    // );
  }

  //
  //     DateTimePicker(
  //   type: DateTimePickerType.date,
  //   // dateMask: 'DD,MM, yyyy',
  //   fieldLabelText: 'birthdate',
  //   autofocus: GetPlatform.isDesktop,
  //   initialDate: UIFormState.signUpFormData.birthdate,
  //
  //   firstDate: DateTime(1200),
  //   style: const TextStyle(fontSize: 12),
  //   decoration: AppTheme.inputDecoration.copyWith(
  //     contentPadding: const EdgeInsets.only(left: 6),
  //     prefixIcon: const Icon(Icons.date_range),
  //     labelText: "Birthdate",
  //     hintStyle: AppTheme.themeData.textTheme.bodySmall,
  //     hintText: UIFormState.signUpFormData.birthdate.readable,
  //   ),
  //   lastDate: DateTime.now(),
  //   icon: const Icon(Icons.event),
  //   dateLabelText: 'birthdate',
  // );

  static AppButton get emailLinkButton {
    return AppButton(
      color: AppSwatch.primary.withAlpha(80),
      isTextButton: true,
      onPressed: () async {
        navService.to(AppRoutes.authEmailSignInForm);
      },
      minWidth: Get.width,
      child: Text(
        "Sign in with email only",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
    );
  }
}


