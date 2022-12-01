import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/authenticate/view/components/provider.buttons.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/forms/phone.form.field.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/date.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// auth sign up form , for authentication this is not a page just the form.
// ignore: must_be_immutable
class SignUpPage extends AdaptiveUI {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 320,
        height: Get.height,
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            FeedbackSpinner(
              spinnerKey: FeedbackSpinKeys.signUpForm,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  child: stageView(adapter),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int get currentIndex => int.parse(Get.parameters['stage'] ?? '0');

  AppTextField get  nameField =>AppTextField(
    label: "name",
    autoFocus: true,
    fieldIcon: Icons.account_circle_sharp,
    decoration: AppTheme.inputDecoration,
    controller: TextEditingController(text: UIFormState.signUpFormData.name),
    onChanged: (data) {
      UIFormState.name(data);
    },
    hint: 'name',
    autoFillHints: const [AutofillHints.name],
    key: UniqueKey(),
  );
  AppTextField get  emailField =>AppTextField(
    fieldIcon: Icons.email,
    label: "Email",
    hint: "eg. example@gmail.com",
    autoFocus: true,
    controller: TextEditingController(text: UIFormState.signUpFormData.email),
    onChanged: (data) {
      UIFormState.email(data.trim());
    },
    key: UniqueKey(),
    keyboardType: TextInputType.emailAddress,
    autoFillHints: const [AutofillHints.email, AutofillHints.username],
  );
  AppTextField get passwordField => AppTextField(
    fieldIcon: Icons.vpn_key,
    label: "Password",
    autoFocus: true,
    hint: "minimum 6 characters",
    controller: TextEditingController(text: UIFormState.signUpFormData.password),
    onChanged: (data) {
      UIFormState.password(data);
    },
    obscureOption: true,
    key: UniqueKey(),
    keyboardType: TextInputType.visiblePassword,
    autoFillHints: const [AutofillHints.password],
  );
  FormPhoneField get phoneField => FormPhoneField(
    autoFocus: true,
    initialValue: UIFormState.signUpFormData.phoneNumber,
    onChanged: (PhoneNumber? p) {
      if (p != null) {
        UIFormState.phoneNumber(p.international);
      }
    },
  );
  DateTimePicker get dateField => DateTimePicker(
    type: DateTimePickerType.date,
    // dateMask: 'DD,MM, yyyy',
    fieldLabelText: 'birthdate',
    autofocus: true,
    initialDate: UIFormState.signUpFormData.birthdate,
    onChanged: (String? date) {
      if (date != null) {
        UIFormState.birthdate(DateTime.parse(date));
      }
    },
    firstDate: DateTime(1200),
    style: const TextStyle(fontSize: 12),
    decoration: AppTheme.inputDecoration.copyWith(
      contentPadding: const EdgeInsets.only(left: 6),
      prefixIcon: const Icon(Icons.date_range),
      labelText: "Birthdate",
      hintStyle: AppTheme.themeData.textTheme.bodySmall,
      hintText: UIFormState.signUpFormData.birthdate.readable,
    ),
    lastDate: DateTime.now(),
    icon: const Icon(Icons.event),
    dateLabelText: 'birthdate',
  );
  Column stageView(Adaptive adapter) {
    switch (currentIndex) {
      case 0:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // AuthProviderButtons(key: UniqueKey()),
              heading("Whats ur name?", adapter),
              const SizedBox(
                height: 10,
              ),
              nameField,
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              nextButton,
              signInButton,

            ]);
      case 1:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("  Hey  ${UIFormState.signUpFormData.name}"),
              heading("What's ur email?", adapter),
              const SizedBox(
                height: 10,
              ),
              emailField,
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              nextButton,
              backButton,
              signInButton
            ]);
      case 2:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              heading("Set a password", adapter),
              const SizedBox(
                height: 10,
              ),
              passwordField,
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              nextButton,
              backButton,
              signInButton
            ]);
      case 3:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              heading("When's your birthday?", adapter),
              const SizedBox(
                height: 10,
              ),
              dateField,
              const SizedBox(
                height: 10,
              ),
              const NotificationsView(),
              const SizedBox(
                height: 10,
              ),
              nextButton,
              backButton,
              signInButton
            ]);
      case 4:
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            heading("Set your phone number", adapter),
            const SizedBox(
              height: 10,
            ),

            phoneField,
            const SizedBox(
              height: 10,
            ),
            const NotificationsView(),
            const SizedBox(
              height: 10,
            ),
            signUpButton,
            backButton,
            signInButton,
          ]);

    }
  }



  Widget get signInButton {
    return Padding(
      padding: const EdgeInsets.only(top:18.0),
      child: AppButton(
        key: UniqueKey(),
        isTextButton: true,
        onPressed: () async {
          navService.to(AppRoutes.authSignIn);
        },
        child: Text(
          "or sign in",
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ),
    );
  }

  String? validateCurrentStage() {
    switch (currentIndex) {
      case 0:
        return Validators.userNameValidator.announceValidation(UIFormState.name.value);

      case 1:

        return Validators.emailFormValidator.announceValidation(UIFormState.email.value);

      case 2:
        return Validators.passwordValidator.announceValidation(UIFormState.password.value);

      case 3:
        return Validators.birthdayValidator.announceValidation(UIFormState.birthdate.value);

      case 4:
        return Validators.phoneValidator.announceValidation(UIFormState.phoneNumber.value);
    }
    return null;
  }

  AppButton get nextButton {

    return AppButton(
      key: UniqueKey(),
      onPressed: () async {
        if (currentIndex < 4) {
          if(validateCurrentStage() == null){
            navService.to("${AppRoutes.authSignUp}?stage=${currentIndex + 1}");
          }else{

          }

        }
      },
      child: Text(
        "next",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
    );
  }

  AppButton get backButton {
    return AppButton(
      key: UniqueKey(),
      isTextButton: true,
      child: Text(
        "Back",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      onPressed: () async {
        if (currentIndex > 0) {
          navService.to("${AppRoutes.authSignUp}?stage=${currentIndex - 1}");
        }
      },
    );
  }

  AppButton get signUpButton {
    return AppButton(
      key: UniqueKey(),
      child: Text(
        "Sign Up",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      onPressed: () async {
        FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: true);
        await authService.signUp(UIFormState.signUpFormData);
        FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: false);
      },
    );
  }

  Widget heading(String title, adapter) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: adapter.textTheme.headlineSmall),
    );
  }
}
