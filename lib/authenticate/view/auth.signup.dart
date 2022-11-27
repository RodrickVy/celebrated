import 'dart:ui';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/requests/sign_up_request.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/app.state.view.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// auth sign up form , for authentication this is not a page just the form.
// ignore: must_be_immutable
class SignUpPage extends AdaptiveUI {
  final Rx<SignUpEmailRequest> formData = Rx(SignUpEmailRequest.empty());

  final Rx<String> orgSelected = typeOfOrgs.last.obs;

  SignUpPage({Key? key}) : super(key: key);

  static final List<String> typeOfOrgs = ["Individual", "School", "Class", "Church", "Business", "Company", "Other"];

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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AppTextField(
                          label: "name",
                          fieldIcon: Icons.account_circle_sharp,
                          decoration: AppTheme.inputDecoration,
                          controller: TextEditingController(text: formData.value.name),
                          onChanged: (data) {
                            formData(formData.value.copyWith(name: data));
                          },
                          hint: 'name',
                          autoFillHints: const [AutofillHints.name],
                          key: UniqueKey(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          fieldIcon: Icons.email,
                          label: "Email",
                          hint: "eg. example@gmail.com",
                          controller: TextEditingController(text: formData.value.email),
                          onChanged: (data) {
                            formData(formData.value.copyWith(email: data));
                          },
                          key: UniqueKey(),
                          keyboardType: TextInputType.emailAddress,
                          autoFillHints: const [AutofillHints.email, AutofillHints.username],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          fieldIcon: Icons.vpn_key,
                          label: "Password",
                          hint: "minimum 6 characters",
                          controller: TextEditingController(text: formData.value.password),
                          onChanged: (data) {
                            formData(formData.value.copyWith(password: data));
                          },
                          obscureOption: true,
                          key: UniqueKey(),
                          keyboardType: TextInputType.visiblePassword,
                          autoFillHints: const [AutofillHints.password],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.date,
                          // dateMask: 'DD,MM, yyyy',
                          fieldLabelText: 'birthdate',
                          onChanged: (String? date) {
                            if (date != null) {
                              formData.update((data) => data?.copyWith(birthdate: DateTime.parse(date)));
                            }
                          },
                          firstDate: DateTime(1200),
                          style: const TextStyle(fontSize: 12),
                          decoration: AppTheme.inputDecoration.copyWith(
                            contentPadding: const EdgeInsets.only(left: 6),
                            prefixIcon: const Icon(Icons.date_range),
                            labelText: "Birthdate",
                            hintText: 'click to change',
                          ),
                          lastDate: DateTime(9090),
                          icon: const Icon(Icons.event),
                          dateLabelText: 'birthdate',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        PhoneField(
                          onChanged: (PhoneNumber? p) {
                            if (p != null) {
                              formData.update((val) => val?.copyWith(phoneNumber: p.international));
                            }
                          },
                        ),
                        // Obx(
                        //   () => Wrap(
                        //     spacing: 5,
                        //     runSpacing: 5,
                        //     children: [
                        //       const  Padding(
                        //         padding:  EdgeInsets.only(bottom: 8.0),
                        //         child:  Text("How are you using , Celebrated? "),
                        //       ),
                        //       ...typeOfOrgs.map((e) => ChoiceChip(
                        //             label: Text(e),
                        //             selectedColor: Theme.of(ctx).colorScheme.primary.withAlpha(34),
                        //             backgroundColor: Colors.white,
                        //             elevation: 0,
                        //             avatar: orgSelected.value == e ? const Icon(Icons.check) : const SizedBox(),
                        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                        //             side: BorderSide(color: Colors.black12, width: 0.6),
                        //             onSelected: (bool? selected) {
                        //               orgSelected(selected ?? false ? e : typeOfOrgs.first);
                        //             },
                        //             selected: orgSelected.value == e,
                        //           ))
                        //     ],
                        //   ),
                        // ),
                        // AppToggleButton(
                        //   multiselect: true,
                        //   options: [
                        //     ToggleOption(view: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: const Text("Just Me"),
                        //     ), state: true, onSelected: (){}),
                        //     ToggleOption(view: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: const Text("Youth Group"),
                        //     ), state: false, onSelected: (){}),
                        //     ToggleOption(view: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: const Text("Organization"),
                        //     ), state: false, onSelected: (){}),
                        //   ],
                        //
                        // ),
                        const SizedBox(
                          height: 5,
                        ),

                        const NotificationsView(),
                        const SizedBox(
                          height: 10,
                        ),

                        AppButton(
                          key: UniqueKey(),
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          onPressed: () async {
                            FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: true);
                            await authService.signUp(formData.value);
                            FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: false);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppButton(
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
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneField extends StatelessWidget {
  final Function(PhoneNumber? phoneNumber)? onChanged;
  final Function(PhoneNumber? phoneNumber)? onSaved;
  final String? initialValue;
  final Rx<PhoneNumber?> number = const PhoneNumber(isoCode: IsoCode.CA, nsn: '23434456567').obs;

  PhoneField({
    Key? key,
    this.onChanged,
    this.onSaved, this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhoneFormField(
      key: const Key('phone-field'),
      controller: null,
      initialValue: initialValue != null && initialValue?.length != 0? PhoneNumber.parse(initialValue!):null,
      defaultCountry: IsoCode.CA,
      decoration: AppTheme.inputDecoration.copyWith(
        hintText: "Phone number",
        labelText: "Phone number",
        suffixIcon: onSaved != null
            ? IconButton(
                onPressed: () {
                  onSaved!(number.value);
                },
                icon: const Icon(Icons.save))
            : null,
      ),
      validator: PhoneValidator.validMobile(),
      countrySelectorNavigator: CountrySelectorNavigator.dialog(
          width: Adaptive(context).adapt(phone: Get.width - 50, tablet: 300, desktop: 400)),
      autofillHints: const [AutofillHints.telephoneNumber],
      selectionWidthStyle: BoxWidthStyle.tight,

      onChanged: (PhoneNumber? p) {
        number(p);
        onChanged != null ? onChanged!(p) : () {}();
        FeedbackService.clearErrorNotification();
      }, // default null
    );
  }
}
