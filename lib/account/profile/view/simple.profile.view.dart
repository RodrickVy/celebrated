import 'package:bremind/account/view/expantion.text.editor.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/view/avatar.view.dart';
import 'package:bremind/authenticate/view/form.text.field.dart';
import 'package:bremind/authenticate/view/signout.view.dart';
import 'package:bremind/domain/view/page.view.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleProfile extends AppStateView<AuthController> {
  SimpleProfile({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptives adapter}) {
    return Obx(
      () {
        return Center(
          child: SizedBox(
            width: adapter.adapt(
                phone: adapter.width,
                tablet: adapter.width / 1.7,
                desktop: adapter.desktop(small: adapter.width / 2.5,medium:adapter.width / 3,large: adapter.width / 3.5)),
            child: Card(
              clipBehavior: Clip.hardEdge,
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        clipBehavior: Clip.hardEdge,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: AvatarView(
                          controller: controller,
                        ),
                      ),
                      Text(controller.accountUser.value.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          )),
                      ExpansionTextEditor(
                        icon: Icons.account_circle,
                        textValue: controller.accountUser.value.name,
                        label: 'username',
                        onSave: (String value) async {
                          FeedbackController.spinnerUpdateState(
                              key: AfroSpinKeys.updateNameForm, isOn: true);
                          await controller.updateUserName(name: value);
                          FeedbackController.spinnerUpdateState(
                              key: AfroSpinKeys.updateNameForm, isOn: false);
                        },
                        spinnerKey: AfroSpinKeys.updateNameForm,
                      ),
                      Card(
                          clipBehavior: Clip.hardEdge,
                          elevation: 0,
                          margin:
                              const EdgeInsets.only(left: 20, top: 12, right: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Icon(
                              Icons.email,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(controller.accountUser.value.email),
                            ),
                          )),
                      ExpansionTextEditor(
                        icon: Icons.message,
                        textValue: controller.accountUser.value.bio,
                        label: 'bio',
                        minLines: 4,
                        maxLines: 5,
                        onSave: (String value) async {
                          FeedbackController.spinnerUpdateState(
                              key: AfroSpinKeys.updateBioForm, isOn: true);
                          await controller.updateBio(bio: value);
                          FeedbackController.spinnerUpdateState(
                              key: AfroSpinKeys.updateBioForm, isOn: false);
                        },
                        spinnerKey: AfroSpinKeys.updateBioForm,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      SignOutView(),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
