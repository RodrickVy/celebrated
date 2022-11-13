import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/birthday/view/birthday.date.name.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/domain/view/app.text.field.dart';
import 'package:celebrated/domain/view/drop.down.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_form_field/phone_form_field.dart';

import 'auth.button.dart';

/// auth sign up form , for authentication this is not a page just the form.
// ignore: must_be_immutable
class SignUpFormView extends AppStateView<AuthController> {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController(text: DateTime.now().toString());
  final PhoneController phoneController = PhoneController(null);
  final Rx<String> phoneNumber = "".obs;
  final Rx<String> orgSelected = typeOfOrgs.last.obs;

  SignUpFormView({Key? key}) : super(key: key);

  static final List<String> typeOfOrgs = ["Individual", "School", "Class", "Church", "Business", "Company", "Other"];

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: SizedBox(
        width: 320,
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            FeedbackSpinner(
              spinnerKey: FeedbackSpinKeys.signUpForm,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BirthdayDateForm(
                            showDate: true,
                            birthdateController: _birthdateController,
                            nameTextController: nameTextController),
                        const SizedBox(
                          height: 10,
                        ),
                        PhoneFormField(
                          key: const Key('phone-field'),
                          controller: null,
                          // controller & initialValue value
                          initialValue: null,
                          // can't be supplied simultaneously
                          shouldFormat: true,
                          // default
                          defaultCountry: IsoCode.CA,
                          // default
                          decoration:AppTextField.defaultDecoration.copyWith(
                            hintText: "Phone number",
                            labelText: "Phone number"
                          ),
                          validator: PhoneValidator.validMobile(),
                          // default PhoneValidator.valid()
                          isCountryChipPersistent: false,
                          // default
                          isCountrySelectionEnabled: true,
                          // default
                          countrySelectorNavigator: const CountrySelectorNavigator.bottomSheet(),
                          showFlagInInput: true,
                          // default
                          flagSize: 16,
                          // default
                          autofillHints: const [AutofillHints.telephoneNumber],
                          // default to null
                          enabled: true,
                          // default
                          autofocus: false,
                          // default
                          onSaved: (PhoneNumber? p) {
                            phoneNumber(p?.international);
                          },
                          // default null
                          onChanged: (PhoneNumber? p) {
                            phoneNumber(p?.international);
                          }, // default null
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          fieldIcon: Icons.email,
                          label: "Email",
                          hint: "eg. example@gmail.com",
                          controller: emailTextController,
                          key: UniqueKey(),
                          keyboardType: TextInputType.emailAddress,
                          autoFillHints: const [AutofillHints.email],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          fieldIcon: Icons.vpn_key,
                          label: "Password",
                          hint: "minimum 6 characters",
                          controller: passwordTextController,
                          obscureOption: true,
                          key: UniqueKey(),
                          keyboardType: TextInputType.visiblePassword,
                          autoFillHints: const [AutofillHints.password],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              const  Padding(
                                padding:  EdgeInsets.only(bottom: 8.0),
                                child:  Text("How are you using , Celebrated? "),
                              ),
                              ...typeOfOrgs.map((e) => ChoiceChip(
                                    label: Text(e),
                                    selectedColor: Theme.of(ctx).colorScheme.primary.withAlpha(34),
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    avatar: orgSelected.value == e ? const Icon(Icons.check) : const SizedBox(),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                    side: BorderSide(color: Colors.black12, width: 0.6),
                                    onSelected: (bool? selected) {
                                      orgSelected(selected ?? false ? e : typeOfOrgs.first);
                                    },
                                    selected: orgSelected.value == e,
                                  ))
                            ],
                          ),
                        ),
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
                          height: 10 / 2,
                        ),

                        const NotificatonsView(),
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
                            if (phoneNumber.isEmpty) {
                              FeedbackService.announce(
                                  notification: AppNotification(
                                      title: 'Sorry phone number must be provided',
                                      appWide: false,
                                      type: NotificationType.error));
                            }
                            await controller.signUpWithEmail(
                                name: nameTextController.value.text,
                                email: emailTextController.value.text,
                                phone: phoneNumber.value,
                                birthdate: DateTime.parse(_birthdateController.value.text),
                                password: passwordTextController.value.text, accountType: orgSelected.value);
                            FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: false);
                          },
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
