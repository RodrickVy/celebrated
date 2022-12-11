import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/authenticate/view/components/user.avatar.dart';
import 'package:celebrated/authenticate/view/components/signout.button.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/forms/phone.form.field.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/model/request.dart';
import 'package:celebrated/domain/view/interface/app.page.view.dart';
import 'package:celebrated/domain/view/components/editable.text.field.dart';
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


  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: Obx(
        () {
          authService.userLive.value;

          return Container(
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

                      Padding(
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
                      Text(
                        authService.userLive.value.email,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
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
                      if (authService.userLive.value.subscription != null)
                        SubscriptionPreviewCard(
                          subscription: authService.userLive.value.subscription!,
                        ),
                      if (authService.userLive.value.subscription == null)
                        AppButton(
                          
                          isTextButton: true,
                          child: const Text(
                            "Select a plan",
                          ),
                          onPressed: () async {
                            navService.routeKeepNext(AppRoutes.subscriptions);
                          },
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      EditableTextView(
                        key: const Key("_display_name_editor"),
                        icon: Icons.account_circle,
                        textValue: authService.userLive.value.name,
                        label: 'username',
                        onSave: (String value) async {
                          await authService.updateUserName(name: value);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FormPhoneField(
                        initialValue: authService.user.phone,
                        onSaved: (PhoneNumber? p) async {
                          Get.log('Saved phone number as ${p?.international}');
                          if (p != null && Request.validateField(Validators.phoneValidator, p.international)) {
                            await authService.updatePhoneNumber(newPhone: p.international);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      UIFormState.dateField(authService.userLive.value.birthdate),
                      ///    onSave: (String? date) {
                      //                           if (date != null) {
                      //                             authService.updateBirthdate(date: DateTime.parse(date));
                      //                           }
                      //                         },
                      const NotificationsView(),
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
                        height: 28,
                      ),
                      const SignOutView(),
                      const SizedBox(
                        height: 30,
                      ),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
