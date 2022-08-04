import 'dart:async';

import 'package:bremind/app.swatch.dart';
import 'package:bremind/appIntro/controller/intro.controller.dart';
import 'package:bremind/authenticate/view/signout.view.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.page.view.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:url_launcher/url_launcher.dart';

/// the homepage for birthdays, has tips, current birthdays etc.
class BirthdaysExplorer extends AppPageView<IntroScreenController> {
  BirthdaysExplorer({Key? key}) : super(key: key);

  final RxInt textIndex = 0.obs;
  final List<String> words = [
    'families',
    'businesses',
    'churches',
    'organizations'
  ];

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    int index = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      index++;
      textIndex(index);
      if (index == words.length - 1) {
        index = 0;
      }
    });
    return Container(
      width: adapter.width,
      height: adapter.height,
      color: Colors.white,
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      child: Container(
        width: adapter.adapt(
            phone: adapter.width, tablet: adapter.width, desktop: 800),
        margin: EdgeInsets.zero,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          padding: const EdgeInsets.all(20),
          children: [
            // Container(
            //   alignment: Alignment.centerLeft,
            //   padding: EdgeInsets.all(4),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(0)
            //   ),
            //   child: Image.asset(
            //     controller.homeItem.image,
            //     width: 230,
            //     fit: BoxFit.fitWidth,
            //   ),
            // ),
            Container(
                child: Image.asset(
              "assets/logos/banner.png",
              width: Get.width,
              fit: BoxFit.fitWidth,
            )),

            Card(
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              margin: EdgeInsets.all(12),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    // Image.asset("assets/intro/party.png"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(text: "For  ", style:adapter.textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black),children: [
                          TextSpan(
                            text: "families",
                            style: adapter.textTheme.headline4?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          const TextSpan(text:" / "),
                          TextSpan(
                            text: "schools",
                            style: adapter.textTheme.headline4?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          const TextSpan(text:" / "),
                          TextSpan(
                            text: "businesses",
                            style: adapter.textTheme.headline4?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:        Colors.orange,),
                          ),
                          const TextSpan(text:" / "),
                          TextSpan(
                            text: 'churches',
                            style: adapter.textTheme.headline4?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:     Colors.green,),
                          ),
                        const TextSpan(text:" / "),
                        const TextSpan(
                            text: " or any ",
                        ),
                          TextSpan(
                            text: 'organizations',
                            style: adapter.textTheme.headline4?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),

                          ),
                          TextSpan(
                            text:" that want to express appreciation when it matters.",
                            style: adapter.textTheme.headline4?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ]),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Keep track & remember birthdays across your organization.",
                        style: adapter.textTheme.headline6,
                        textAlign: TextAlign.left,
                      ),
                    ),

                    GestureDetector(
                      onTap: () async {
                        await launchUrl(Uri.parse(
                            "https://play.google.com/apps/test/com.rudo.bereminder/1"));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/logos/playbutton.png",
                          height: 60,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Card(
            //   elevation: 3,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(0)),
            //   margin: EdgeInsets.all(
            //       adapter.adapt(phone: 6, tablet: 8, desktop: 12)),
            //   child: Padding(
            //     padding: EdgeInsets.all(
            //         adapter.adapt(phone: 12, tablet: 14, desktop: 20)),
            //     child: Column(
            //       children: [
            //         Container(
            //           alignment: Alignment.centerLeft,
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text(
            //             "Join The Early Research",
            //             style: adapter.textTheme.headline4
            //                 ?.copyWith(fontWeight: FontWeight.w500),
            //             textAlign: TextAlign.left,
            //           ),
            //         ),
            //         Container(
            //           alignment: Alignment.centerLeft,
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text(
            //             "Help us build an experience that solves the right problems. Taking this 5 min survey goes to tremendous lengths to help us create an app that's positively impactful!",
            //             style: adapter.textTheme.headline6,
            //             textAlign: TextAlign.left,
            //           ),
            //         ),
            //         TextButton(
            //           key: UniqueKey(),
            //           onPressed: () async {
            //             final Uri _url = Uri.parse(
            //                 'https://docs.google.com/forms/d/e/1FAIpQLSfH_82VfzhlgEzsRrW0Jw_Y1sqd30kaChoGnRC5u0wpgqMYxQ/viewform?usp=sf_link');
            //             if (!await launchUrl(_url)) {
            //               FeedbackService.announce(
            //                   notification: AppNotification(
            //                       title:
            //                           "Oops! Looks like we can't open this url, copy  this link instead",
            //                       appWide: true,
            //                       child: AppButton(
            //                           key: UniqueKey(),
            //                           child: Text(
            //                               "Click To Copy :https://forms.gle/yMqYcdVHchyKqza6A "),
            //                           onPressed: () {
            //                             Clipboard.setData(const ClipboardData(
            //                                     text:
            //                                         "https://forms.gle/yMqYcdVHchyKqza6A"))
            //                                 .then((value) {
            //                               FeedbackService.successAlertSnack(
            //                                   "Link Copied!");
            //                             });
            //                           })));
            //             }
            //           },
            //           style: ElevatedButton.styleFrom(
            //               primary: AppSwatch.primary.shade500,
            //               padding: const EdgeInsets.all(15),
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(0)),
            //               minimumSize: const Size.fromHeight(50)),
            //           child: const Text(
            //             " Take Survey ",
            //             style: TextStyle(color: Colors.black),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

   Card(
     elevation: 4,
     color: Colors.redAccent,
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Wrap(
         children: [
           Container(
             padding: const EdgeInsets.all(8.0),
             child: Text(
               "Here is what you get for free: ",
               style: adapter.textTheme.headline4,
               textAlign: TextAlign.left,
             ),
           ),
           ListTile(
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(0)),
             title: Text(
               "Group related birthdays into lists",
               style: adapter.textTheme.headline6
                   ?.copyWith(fontWeight: FontWeight.bold),
             ),
             leading: const Icon(
               Icons.list_alt_outlined,
               size: 25,
             ),
             subtitle: const Text(
                 "group birthdays into your wanted lists eg. department,teams or custom"),
           ),
           ListTile(
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(0)),
             title: Text(
               "Send out birthday collection link",
               style: adapter.textTheme.headline6
                   ?.copyWith(fontWeight: FontWeight.bold),
             ),
             leading: const Icon(
               Icons.add_link,
               size: 25,
             ),
             subtitle: const Text(
                 "Easily collect birthdays of from everyone with a link"),
           ),
           ListTile(
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(0)),
             title: Text(
               "Members can subscribe to lists to get notified",
               style: adapter.textTheme.headline6
                   ?.copyWith(fontWeight: FontWeight.bold),
             ),
             leading: const Icon(
               Icons.notifications,
               size: 25,
             ),
             subtitle: const Text(
                 "any member of organization can subscribe to a birthday list notification, to get a phone text notification when its someones birthday."),
           ),
           ListTile(
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(0)),
             title: Text(
               "Birthday note card that all can sign",
               style: adapter.textTheme.headline6
                   ?.copyWith(fontWeight: FontWeight.bold),
             ),
             leading: const Icon(
               Icons.edit,
               size: 25,
             ),
             subtitle: const Text(
                 "Birthday note card that all members can sign"),
           ),
           ListTile(
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(0)),
             title: Text(
               "all managed from one account",
               style: adapter.textTheme.headline6
                   ?.copyWith(fontWeight: FontWeight.bold),
             ),
             leading: const Icon(
               Icons.account_circle,
               size: 25,
             ),
             subtitle: const Text(
                 "no need for any confusing accounts for member, all is managed by one account"),
           ),
         ],
       ),
     ),
   ),

            // ListTile(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(0)),
            //   title: Text(
            //     "Connection",
            //     style: adapter.textTheme.headline6
            //         ?.copyWith(fontWeight: FontWeight.bold),
            //   ),
            //   subtitle: const Text(
            //       "the value of time is measured by the memories around it, we make them count."),
            //   trailing: const Icon(Icons.check),
            // ),

         Container(
           padding: EdgeInsets.all(12),
           // color: Colors.redAccent.withAlpha(78),
           child: Wrap(
             children: [
               Text(
                 "Transforming Organizations!",
                 style: adapter.textTheme.headline6
                     ?.copyWith(fontWeight: FontWeight.bold),
               ),
               ListTile(
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(0)),
                 leading: const Icon(
                   Icons.check_box_outline_blank_outlined,
                   size: 25,
                 ),
                 tileColor: Colors.green,

                 title: Text(
                   "Breaking Barriers",
                   style: adapter.textTheme.headline6
                       ?.copyWith(fontWeight: FontWeight.bold),
                 ),
                 subtitle: const Text(
                     "Celebrated is a great way for schools, churches and any organizations to break barriers"),
               ),

               ListTile(
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(0)),
                 leading: const Icon(
                   Icons.check_box_outline_blank_outlined,
                   size: 25,
                 ),
                 tileColor: Colors.red,
                 title: Text(
                   "Expression",
                   style: adapter.textTheme.headline6
                       ?.copyWith(fontWeight: FontWeight.bold),
                 ),
                 subtitle: const Text(
                     "We believe love, care and appreciation that find no authentic expression is useless, we help you express it when it matters."),
               ),

               ListTile(
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(0)),
                 tileColor: Colors.blue,
                 title: Text(
                   "Growing connection",
                   style: adapter.textTheme.headline6
                       ?.copyWith(fontWeight: FontWeight.bold),
                 ),
                 subtitle: const Text(
                     "We help organizations connect more, not as employees,students or members but humans celebrating each other."),
                 leading: const Icon(
                   Icons.check_box_outline_blank_outlined,
                   size: 25,
                 ),
               ),
             ],
           ),
         )

/*
*
*
*  - the value of time is measured by the memories around it, we make them count.
 - .
  -
Novelty - we are all about new and different.
Authentic - we do it, say it and sell it like it is
Fun -  we find fun and joy in what we do.
* */
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     controller.homeItem.title,
            //     style: adapter.textTheme.headline3,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     controller.homeItem.description,
            //     style: adapter.textTheme.bodyLarge,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Get started, create your first Account!",
            //     style: adapter.textTheme.bodyLarge,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// class BirthdayEditor extends StatelessWidget {
//   late TextEditingController _nameEditorController;
//   late TextEditingController _birthdateController;
//   late TextEditingController _remindDateController;
//   late ABirthday birthday;
//   final String id = const Uuid().v4();
//   bool isUpdating = false;
//
//   BirthdayEditor({Key? key}) : super(key: key) {
//     birthday = BirthdaysController.instance.birthdayToUpdate.value ??
//         ABirthday.empty().copyWith(id: id);
//     _nameEditorController = TextEditingController(text: birthday.name);
//     _birthdateController =
//         TextEditingController(text: birthday.date.toString());
//     _remindDateController = TextEditingController(
//         text:
//             birthday.date.difference(birthday.remindMeWhen).inDays.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.width - 40,
//       alignment: Alignment.center,
//       child: Container(
//         child: Card(
//           elevation: 2,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//           child: Container(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: 60,
//                   width: Get.width - 20,
//                   child: FormTextField(
//                     label: "Name",
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(0),
//                             borderSide: BorderSide(width: 0.5))),
//                     controller: _nameEditorController,
//                     hint: 'full name',
//                     key: UniqueKey(),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 DateTimePicker(
//                   type: DateTimePickerType.date,
//                   dateMask: 'd MMM, yyyy',
//                   fieldLabelText: 'Birthdate',
//                   firstDate: DateTime(1200),
//                   controller: _birthdateController,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(0),
//                           borderSide: BorderSide(width: 0.5))),
//                   lastDate: DateTime(9090),
//                   icon: const Icon(Icons.event),
//                   dateLabelText: 'Birthdate',
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   children: [
//                     FormSubmitButton(
//                       key: UniqueKey(),
//                       child: Text(
//                         "Cancel",
//                         style: GoogleFonts.poppins(fontSize: 16),
//                       ),
//                       onPressed: () async {
//                         BirthdaysController.editMode(false);
//                       },
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     FormSubmitButton(
//                       key: UniqueKey(),
//                       child: Text(
//                         "Save",
//                         style: GoogleFonts.poppins(fontSize: 16),
//                       ),
//                       onPressed: () async {
//                         if (BirthdaysController
//                                 .instance.birthdayToUpdate.value !=
//                             null) {
//                           await BirthdaysController.instance.updateContent(
//                               birthday.id,
//                               BirthdayFactory().toJson(birthday.copyWith(
//                                 name: _nameEditorController.value.text,
//                                 date: DateTime.parse(
//                                     _birthdateController.value.text),
//                               )));
//                         } else {
//                           await BirthdaysController.instance
//                               .setContent(birthday.copyWith(
//                             name: _nameEditorController.value.text,
//                             date:
//                                 DateTime.parse(_birthdateController.value.text),
//                           ));
//                         }
//
//                         BirthdaysController.editMode(false);
//                         BirthdaysController.instance.getBirthdays();
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
