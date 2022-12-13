import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/requests/signin.request.dart';
import 'package:celebrated/authenticate/requests/signup.request.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/domain/view/components/forms/phone.form.field.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';
import 'package:celebrated/util/fomatters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// A service to keep track of  all app's forms ephemeral state, this also helps us avoid request the user data twice, as it it can use data
/// from a form previously field.
///  eg. after truing to signing and it fails since unregistered, I can go to the sign up page and not have to reenter my email and password again.
///  This functionality is across different features, but context is considered when reusing data to avoid mismatching data.

class UIFormState {
  static String name = '';
  static String email = '';
  static String password = '';
  static String birthdate = '';
  static String phoneNumber = '';
  static String promoCode = '';
  static String authCode = '';
  static String recipientName = '';

  /// using text input instead of calender for inputing dates
  static RxBool textDateInput = true.obs;
  static Rx<SubscriptionPlan> subscriptionPlan = SubscriptionPlan.free.obs;
  static RxBool signInLinkSent = false.obs;

  static SignInEmailRequest get signInFormData => SignInEmailRequest(email: email, password: password);

  static SignUpEmailRequest get signUpFormData => SignUpEmailRequest(
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      plan: subscriptionPlan.value,
      promotionCode: promoCode,
      name: name,
      birthdate: birthdate);

  const UIFormState();

  static AppTextField get nameField => AppTextField(
        label: "name",
        autoFocus: GetPlatform.isDesktop,
        fieldIcon: Icons.account_circle_sharp,
        decoration: AppTheme.inputDecoration,
        controller: TextEditingController(text: UIFormState.name),
        onChanged: (data) {
          UIFormState.name =data;
        },
        hint: 'enter your name',
        autoFillHints: const [AutofillHints.name],
      );

  static AppTextField get sendToRecipientField => AppTextField(
    label: "Recipient ",
    autoFocus: GetPlatform.isDesktop,
    fieldIcon: Icons.account_circle_sharp,
    decoration: AppTheme.inputDecoration,
    controller: TextEditingController(text: UIFormState.recipientName),
    onChanged: (data) {
      UIFormState.recipientName =data;
    },
    hint: 'enter recipients name',
    autoFillHints: const [AutofillHints.name],
  );
  
  static AppTextField get emailField => AppTextField(
        fieldIcon: Icons.email,
        label: "Email",
        hint: "eg. example@gmail.com",
        autoFocus: GetPlatform.isDesktop,
        controller: TextEditingController(text: UIFormState.signUpFormData.email),
        onChanged: (data) {
          UIFormState.email =data.trim();
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
          UIFormState.password =data;
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
            UIFormState.phoneNumber =p.international;
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

  static String startValue(DateTime? initialVal) {
    if (initialVal != null) {
      UIFormState.birthdate = isoStringToDMYFormat(initialVal.toIso8601String());
    }
    return isoStringToDMYFormat(initialVal?.toIso8601String() ?? UIFormState.birthdate);
  }

  static String isoStringToDMYFormat(String date) {
    return date.split('T').first.split('-').reversed.join('/');
  }

  static Widget dateField({DateTime? initialValue, Function(DateTime? data)? onChanged}) {
    //

    return AppTextField(
      fieldIcon: Icons.cake,
      label: "Date (dd-mm-yyyy)",
      hint: "dd-mm-yyyy",
      autoFocus: GetPlatform.isDesktop,
      inputFormatters: [DateTextFormatter()],
      controller: TextEditingController(text: startValue(initialValue)),
      onChanged: (data) {
        UIFormState.birthdate = data;
        onChanged != null  && data.length == DateTextFormatter.maxChars+2 ? onChanged(parsedDate) : () {}();
      },
      keyboardType: TextInputType.datetime,
      autoFillHints: const [AutofillHints.birthday],
    );
  }

  static DateTime? get parsedDate {
    if(Validators.birthdayValidator.announceValidation(birthdate) == null){
      return DateTime.parse(birthdate.split("/").reversed.join('-'));
    }
    return null;

  }

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
