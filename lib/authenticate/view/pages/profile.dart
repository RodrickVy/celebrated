import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/authenticate/view/components/user.avatar.dart';
import 'package:celebrated/authenticate/view/components/signout.button.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';

import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/forms/phone.form.field.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/model/request.dart';
import 'package:celebrated/domain/view/interface/app.page.view.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/subscription/view/subscription.preview.card.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_form_field/phone_form_field.dart';

class ProfilePage extends AppPageView {
  const ProfilePage({Key? key}) : super(key: key);
  static Rx<String?> nameChanges = Rx<String?>(null);
  static Rx<String?> phoneChanges = Rx<String?>(null);
  static Rx<DateTime?> dateChanges = Rx<DateTime?>(null);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 360,
          height: Get.height,
          child: Card(
            clipBehavior: Clip.hardEdge,
            elevation: 0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: ListView(padding: const EdgeInsets.all(8.0),
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AvatarView(),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        authService.userLive.value.name,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      authService.userLive.value.email,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "joined ${authService.userLive.value.timeCreated.relativeToNowString(ctx)}",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black45,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Obx(
                    () {
                      if (authService.userLive.value.subscription != null) {
                        return SubscriptionPreviewCard(
                          subscription: authService.userLive.value.subscription!,
                        );
                      } else {
                        return AppButton(
                          isTextButton: true,
                          child: const Text(
                            "Select a plan",
                          ),
                          onPressed: () async {
                            navService.routeKeepNext(AppRoutes.subscriptions);
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => UIFormState.nameField.copyWith(
                        onChanged: (d) {
                          UIFormState.name = d;
                          nameChanges(d);
                        },
                        controller: TextEditingController(text: authService.userLive.value.name)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => FormPhoneField(
                      initialValue: authService.user.phone,
                      onChanged: (PhoneNumber? d) {
                        phoneChanges(d?.international);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => UIFormState.dateField(
                      initialValue: authService.userLive.value.birthdate,
                      onChanged: (d) {

                          dateChanges(d);


                      },
                    ),
                  ),
                  const NotificationsView(),
                  Obx(
                    () {

                      print("rerun");
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: AppButton(
                          isTextButton:nameChanges.value == null &&  phoneChanges.value == null && dateChanges.value == null,
                          onPressed: () async {
                            if (dateChanges.value != null) {
                              authService.updateBirthdate(date: UIFormState.parsedDate!);
                            }
                            if (phoneChanges.value != null) {
                              if (Request.validateField(Validators.phoneValidator, UIFormState.phoneNumber)) {
                                await authService.updatePhoneNumber(newPhone: UIFormState.phoneNumber);
                              }
                            }
                            if (nameChanges.value != null) {
                              await authService.updateUserName(name: UIFormState.name);
                            }

                            nameChanges.value = null;
                            dateChanges.value = null;
                            phoneChanges.value = null;
                            print("rerun   ${nameChanges.value}  ");
                          },
                          label: "Save Changes",
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 28,
                  ),
                  const SignOutView(),
                  const SizedBox(
                    height: 30,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
