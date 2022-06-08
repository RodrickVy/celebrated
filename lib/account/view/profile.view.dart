import 'package:bremind/account/profile/view/simple.profile.view.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/interface/auth.controller.interface.dart';
import 'package:bremind/authenticate/view/form.submit.button.dart';
import 'package:bremind/domain/view/page.view.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends AppView<AuthController> {
  ProfileView({Key? key}) : super(key: key) {
    // updateProverbs().then((value) {
    //   Get.log("Uploading to firestore was a sucess: $value");
    // });
  }

  @override
  Widget view({required BuildContext ctx, required Adaptives adapter}) {
    return   SimpleProfile();
  }
}

class AccountProfileView extends StatelessWidget {
  final IAuthController controller = Get.find<AuthController>();

  AccountProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isAuthenticated.isTrue
          ? Center(
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  // side: BorderSide(color: Colors.orange.withAlpha(120), width: 1.7),
                ),
                child: ExpansionTile(
                    collapsedBackgroundColor: Colors.blue.withAlpha(120),
                    backgroundColor: Colors.orange.withAlpha(120),
                    title: Text(controller.accountUser.value.displayName,
                        style: GoogleFonts.mavenPro(
                          fontSize: 18,
                          color: Colors.white.withAlpha(125),
                          fontWeight: FontWeight.bold,
                        )),
                    leading: Card(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: controller.user.value.hasAvatar()
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image.asset(
                                  controller.user.value.avatar,
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: Text(
                                  controller.user.value.userName
                                      .substring(0, 2),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                    initiallyExpanded: true,
                    children: [
                      Card(
                          clipBehavior: Clip.hardEdge,
                          margin: const EdgeInsets.only(
                              left: 20, top: 12, right: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ExpansionTile(
                              title: ListTile(
                                leading: Icon(
                                  Icons.person,
                                  color:
                                      controller.accountUser.value.emailVerified
                                          ? Colors.green.withAlpha(150)
                                          : Colors.white,
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      controller.accountUser.value.displayName),
                                ),
                                trailing: Text(
                                  'Expand To Edit'.tr.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              children: [])),
                      Card(
                        clipBehavior: Clip.hardEdge,
                        margin:
                            const EdgeInsets.only(left: 20, top: 12, right: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Icon(
                            controller.accountUser.value.emailVerified
                                ? Icons.mark_email_read
                                : Icons.email,
                            color: controller.accountUser.value.emailVerified
                                ? Colors.green
                                : Colors.white,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(controller.accountUser.value.email),
                          ),
                          // trailing: TextButton(
                          //   child: const Text(
                          //     'EDIT',
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          //   style: TextButton.styleFrom(
                          //     primary: Colors.white,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(12.0),
                          //     ),
                          //     backgroundColor: Get.theme.colorScheme.secondary.withAlpha(0),
                          //     padding: const EdgeInsets.all(20),
                          //   ),
                          //   onPressed: () {
                          //     controller.account.updatingUserEmail.value = true;
                          //   },
                          // ),
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.hardEdge,
                        margin: const EdgeInsets.only(
                            left: 20, top: 12, right: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        // child: ListTile(
                        //     trailing: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Image.asset(
                        //         controller.accountUser.value.usesPasswordAuth
                        //             ? "assets/logos/email.png"
                        //             : "assets/logos/google.png",
                        //         // color: Colors.green.withAlpha(150),
                        //       ),
                        //     ),
                        //     title: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Text(
                        //           "${'signed_in_with'.tr} ${controller.account.user.providerData[0].providerId}'"),
                        //     ))
                      )
                    ]),
              ),
            )
          : Container(
              width: Get.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Looks like you are not authenticated. ",
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    FormSubmitButton(
                      key: UniqueKey(),
                      child: Text(
                        "Sign in Or Create Account",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      onPressed: () async {
                        NavController.instance.to(AppRoutes.auth);
                      },
                    ),
                  ]),
            );
    });
  }
}

// class UserNameEditor extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<FormState> _formKey = GlobalKey();
//     TextEditingController nameController = TextEditingController(text: controller.account.displayName);
//     // TextEditingController photoUrlController = TextEditingController(text: controller.account.photoUrl);
//
//     return Padding(
//       padding: const EdgeInsets.all(18.0),
//       child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(
//                     hintText: '${controller.account.displayName}',
//                     hintStyle: TextStyle(color: Colors.white54),
//                     labelText: "form_name".tr),
//                 cursorColor: Get.theme.textSelectionTheme.cursorColor,
//                 autofillHints: [AutofillHints.email],
//                 enableSuggestions: true,
//                 onChanged: (String? value) {},
//                 controller: nameController,
//                 autocorrect: false,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 keyboardType: TextInputType.name,
//                 validator: (value) {},
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       child: Text("cancel".tr, style: TextStyle(fontSize: 17)),
//                       style: TextButton.styleFrom(
//                         primary: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(12.0),
//                         ),
//                         backgroundColor: Get.theme.colorScheme.secondary.withAlpha(0),
//                         padding: const EdgeInsets.all(20),
//                       ),
//                       onPressed: () {
//                         controller.account.updatingUserName.value = false;
//                       },
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     TextButton(
//                       child: Text(
//                         'update'.tr,
//                         style: TextStyle(fontSize: 17),
//                       ),
//                       style: TextButton.styleFrom(
//                         primary: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(12.0),
//                         ),
//                         backgroundColor: Get.theme.colorScheme.secondary.withAlpha(17),
//                         padding: const EdgeInsets.all(20),
//                       ),
//                       onPressed: () {
//
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }
// //
// // class UserEmailEditor extends GetView<AppPresenter> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final GlobalKey<FormState> _formKey = GlobalKey();
// //     TextEditingController newEmail = TextEditingController(text: controller.account.user.email);
// //     return Form(
// //         key: _formKey,
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           mainAxisAlignment: MainAxisAlignment.start,
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.all(15.0),
// //               child: TextFormField(
// //                 decoration: InputDecoration(
// //                     hintText: 'e.g john@gmail.com',
// //                     hintStyle: TextStyle(color: Colors.white54),
// //                     labelText: "form_email".tr,
// //                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
// //                 cursorColor: Get.theme.textSelectionTheme.cursorColor,
// //                 autofillHints: [AutofillHints.email],
// //                 enableSuggestions: true,
// //                 onChanged: (String? value) {
// //                   controller.account.formErrors.clear();
// //                 },
// //                 controller: newEmail,
// //                 autocorrect: false,
// //                 autovalidateMode: AutovalidateMode.onUserInteraction,
// //                 keyboardType: TextInputType.name,
// //                 validator: (value) {
// //                   return controller.account.validateEmail(value!);
// //                 },
// //               ),
// //             ),
// //             FireAuthErrorView(),
// //             Padding(
// //               padding: const EdgeInsets.only(left: 10.0, bottom: 7, top: 0),
// //               child: Row(
// //                 children: [
// //                   SizedBox(
// //                     width: 10,
// //                   ),
// //                   TextButton(
// //                     child: Text("cancel".tr, style: TextStyle(fontSize: 17)),
// //                     style: TextButton.styleFrom(
// //                       primary: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: new BorderRadius.circular(12.0),
// //                       ),
// //                       backgroundColor: Get.theme.colorScheme.secondary.withAlpha(0),
// //                       padding: const EdgeInsets.all(20),
// //                     ),
// //                     onPressed: () {
// //                       controller.account.updatingUserEmail.value = false;
// //                     },
// //                   ),
// //                   SizedBox(
// //                     width: 10,
// //                   ),
// //                   TextButton(
// //                     child: Text(
// //                       'update'.tr,
// //                       style: TextStyle(fontSize: 17),
// //                     ),
// //                     style: TextButton.styleFrom(
// //                       primary: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: new BorderRadius.circular(12.0),
// //                       ),
// //                       backgroundColor: Get.theme.colorScheme.secondary.withAlpha(17),
// //                       padding: const EdgeInsets.all(20),
// //                     ),
// //                     onPressed: () {
// //                       if (_formKey.currentState!.validate()) {
// //                         controller.account.updateEmail(newEmail.value.text);
// //                         controller.account.updatingUserName.value = false;
// //                       }
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ));
// //   }
// // }
