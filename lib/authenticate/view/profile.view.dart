import 'package:celebrated/authenticate/controller/auth.controller.dart';

import 'package:celebrated/authenticate/view/avatar.view.dart';
import 'package:celebrated/authenticate/view/signout.view.dart';
import 'package:celebrated/birthday/view/birthday.date.name.dart';
import 'package:celebrated/domain/view/app.page.view.dart';
import 'package:celebrated/domain/view/app.text.field.dart';
import 'package:celebrated/domain/view/editable.text.field.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// simple UI for showing user profile, needs any class that impliments of [IAuthController]
class ProfileView extends AppPageView {
  late TextEditingController _birthdateController;
  static final AuthController controller = Get.find<AuthController>();
  late Rx<String> phoneNumber;
  ProfileView({Key? key}) : super(key: key) {
    if (controller.isAuthenticated.isFalse) {
      NavController.instance.to(AppRoutes.auth);
    }
    _birthdateController = TextEditingController(text: controller.accountUser.value.birthdate.toString());
    phoneNumber = controller.accountUser.value.phone.obs;
  }

  final RxBool showBirthdayEditor = false.obs;
  final RxBool showPhoneEditor = false.obs;


  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: Obx(
            () {
          controller.user.value;


          return SizedBox(
            width: adapter.adapt(
                phone: adapter.width,
                tablet: adapter.width / 1.7,
                desktop:
                adapter.desktop(small: adapter.width / 2.5, medium: adapter.width / 3, large: adapter.width / 3.5)),
            child: Card(
              clipBehavior: Clip.hardEdge,
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AvatarView(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          controller.user.value.userName,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "joined ${controller.accountUser.value.timeCreated.relativeToNowString(ctx)}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black45,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: EditableTextView(
                          key: const Key("_display_name_editor"),
                          icon: Icons.account_circle,
                          textValue: controller.user.value.userName,
                          label: 'username',
                          onSave: (String value) async {
                            await controller.updateUserName(name: value);
                          },
                        ),
                      ),
                      Obx(() =>
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    if(showPhoneEditor.isTrue){
                                      if (phoneNumber!.isEmpty) {
                                        FeedbackService.announce(
                                            notification: AppNotification(
                                                title: 'Sorry phone number must be provided',
                                                appWide: false,
                                                type: NotificationType.error));
                                      }
                                      FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: true);
                                      await controller
                                          .updateContent(controller.user.value.uid, {"phone": phoneNumber!.value}).then((
                                          value) {

                                        showPhoneEditor.toggle();
                                        FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: false);

                                      });
                                    }else{
                                      showPhoneEditor.toggle();
                                    }

                                  },
                                  icon: Icon(showPhoneEditor.value ? Icons.save : Icons.edit)),
                              Expanded(
                                child: AnimatedSwitcher(
                                    duration: const Duration(seconds: 1),
                                    child: showPhoneEditor.value
                                        ? PhoneFormField(
                                      key: const Key('phone-field'),
                                      controller: null,
                                      // controller & initialValue value
                                      initialValue: controller.accountUser.value.phone.isNotEmpty
                                          ? PhoneNumber.parse(controller.accountUser.value.phone)
                                          : null,
                                      // can't be supplied simultaneously
                                      shouldFormat: true,
                                      // default
                                      defaultCountry: IsoCode.CA,
                                      // default
                                      decoration: AppTextField.defaultDecoration.copyWith(
                                        hintText: "Phone number",
                                        labelText: "Phone number",
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
                                      onChanged: (PhoneNumber? p) {
                                        phoneNumber!(p?.international ?? '');
                                        FeedbackService.clearErrorNotification();
                                      },
                                    )
                                        : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Phone : ${controller.accountUser.value.phone}"),
                                    )),
                              )
                            ],
                          )),

                      const NotificatonsView(),
                      Card(
                          clipBehavior: Clip.hardEdge,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          child: ListTile(
                            leading: const Icon(
                              Icons.email,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(controller.user.value.email),
                            ),
                          )),
                      // Card(
                      //   clipBehavior: Clip.hardEdge,
                      //   elevation: 0,
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(0)),
                      //   child: ListTile(
                      //     leading: const Icon(
                      //       Icons.cake,
                      //     ),
                      //     title: BirthdayDateForm(
                      //       onDateFieldSubmitted: (String date) async{
                      //        await controller.updateBirthdate(
                      //             date: DateTime.parse(date));
                      //       },
                      //       birthdateController: _birthdateController,
                      //       showName: false,
                      //     ),
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: EditableTextView(
                      //     icon: Icons.message,
                      //     key: const Key("_bio_editor"),
                      //     textValue: controller.accountUser.value.bio,
                      //     label: 'bio',
                      //     minLines: 4,
                      //     maxLines: 5,
                      //     onSave: (String value) async {
                      //       FeedbackService.spinnerUpdateState(
                      //           key: FeedbackSpinKeys.updateBioForm, isOn: true);
                      //       await controller.updateBio(bio: value);
                      //       FeedbackService.spinnerUpdateState(
                      //           key: FeedbackSpinKeys.updateBioForm, isOn: false);
                      //     },
                      //   ),
                      // ),
                      const SizedBox(
                        height: 50,
                      ),
                      SignOutView(),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
