import 'dart:async';

import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/appIntro/controller/intro.controller.dart';
import 'package:celebrated/authenticate/view/signout.view.dart';
import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/domain/view/app.page.view.dart';
import 'package:celebrated/home/controller/home.controller.dart';
import 'package:celebrated/home/model/target.group.dart';
import 'package:celebrated/home/model/value.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:url_launcher/url_launcher.dart';

/// the homepage for birthdays, has tips, current birthdays etc.
class HomePage extends AppPageView{
  HomePage({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      width: adapter.width,
      height: adapter.height,
      color: Colors.white,
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      child: Container(
        width: adapter.adapt(phone: adapter.width, tablet: adapter.width, desktop: 800),
        margin: EdgeInsets.zero,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Image.asset(
              HomeController.homeBanner,
              width: Get.width,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    text: "For  ",
                    style: adapter.textTheme.headlineSmall,
                    children: [
                      ...HomeController.targets
                          .map(
                            (TargetGroup group) => TextSpan(
                              text: '${group.name} , ',
                              style: adapter.textTheme.headlineSmall
                                  ?.copyWith( color: group.color),
                            ),
                          )
                          .toList(),
                       TextSpan(
                        text: " or any ", style: adapter.textTheme.headlineSmall
                      ),
                      TextSpan(
                        text: 'organizations',
                        style: adapter.textTheme.headlineSmall?.copyWith( color: Colors.blue),
                      ),
                      TextSpan(
                        text: " that want to express appreciation when it matters.",
                        style: adapter.textTheme.headlineSmall?.copyWith( color: Colors.black),
                      ),
                    ]),
              ),
            ),
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                HomeController.googlePlayStoreCTA,
                style: adapter.textTheme.headline6,
                textAlign: TextAlign.left,
              ),
            ),
            GestureDetector(
              onTap: () async {
                await launchUrl(Uri.parse(HomeController.playStoreUrl));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  HomeController.playStoreBtnImage,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Here is what you get for free",
                      style: adapter.textTheme.headlineSmall,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ...HomeController.mainFeatures.map((e) {
                    return ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      title: Text(
                        e.name,
                        style: adapter.textTheme.bodyLarge,
                      ),
                      leading:  Icon(
                      e.icon,
                        size: 25,
                      ),
                      subtitle: Text(e.description,  style: adapter.textTheme.bodyMedium,),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 50,),
            Text(
              "Transforming Organizations!",
              style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25,),
            Wrap(
              children: [

                ...HomeController.values.map((CoreValue value){
                  return SizedBox(
                    width: 200,
                    child: Card(
                      elevation: 1,

                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(   color: value.color)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 25,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value.name,
                              style: adapter.textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(value.description,textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    ),
                  );
                }),
                // ListTile(
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                //   leading: const Icon(
                //     Icons.check_box_outline_blank_outlined,
                //     size: 25,
                //   ),
                //   tileColor: Colors.green,
                //   title: Text(
                //     "Breaking Barriers",
                //     style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: const Text(
                //       "Celebrated is a great way for schools, churches and any organizations to break barriers"),
                // ),
                // ListTile(
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                //   leading: const Icon(
                //     Icons.check_box_outline_blank_outlined,
                //     size: 25,
                //   ),
                //   tileColor: Colors.red,
                //   title: Text(
                //     "Expression",
                //     style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: const Text(
                //       "We believe love, care and appreciation that find no authentic expression is useless, we help you express it when it matters."),
                // ),
                // ListTile(
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                //   tileColor: Colors.blue,
                //   title: Text(
                //     "Growing connection",
                //     style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: const Text(
                //       "We help organizations connect more, not as employees,students or members but humans celebrating each other."),
                //   leading: const Icon(
                //     Icons.check_box_outline_blank_outlined,
                //     size: 25,
                //   ),
                // ),
              ],
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
