import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/app.page.view.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_fade/image_fade.dart';
import 'package:url_launcher/url_launcher.dart';

/// the homepage for birthdays, has tips, current birthdays etc.
class AboutDev extends AppPageView {
  const AboutDev({Key? key}) : super(key: key);



  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
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
        padding: const EdgeInsets.all(20),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const  Padding(
              padding:  EdgeInsets.all(8.0),
              child: ImageFade(
                image: AssetImage(
                  "assets/logos/Icon-192.png",
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "We make it stress-free & inexpensive to remember, plan and celebrate birthdays.",
                style: adapter.textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),

            Card(
              elevation: 0,
              color: AppSwatch.primary.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              margin: EdgeInsets.all(12),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Image.asset("assets/intro/party.png"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        " We want to add meaning, connection & fun to the days that matter.",
                        style: adapter.textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              margin: EdgeInsets.all(
                  adapter.adapt(phone: 6, tablet: 8, desktop: 12)),
              child: Padding(
                padding: EdgeInsets.all(
                    adapter.adapt(phone: 12, tablet: 14, desktop: 20)),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Join The Early Research",
                        style: adapter.textTheme.headline4?.copyWith(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Help us build an experience that solves the right problems. Taking this 5 min survey goes to tremendous lengths to help us create an app thats right for you!",
                        style: adapter.textTheme.headline6,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextButton(
                      key: UniqueKey(),
                      onPressed: () async {
                        final Uri _url = Uri.parse(
                            'https://docs.google.com/forms/d/e/1FAIpQLSfH_82VfzhlgEzsRrW0Jw_Y1sqd30kaChoGnRC5u0wpgqMYxQ/viewform?usp=sf_link');
                        if (!await launchUrl(_url)) {
                          FeedbackService.announce(
                              notification: AppNotification(
                                  title:
                                      "Oops! Looks like we can't open this url, copy  this link instead",
                                  appWide: true,
                                  child: AppButton(
                                      key: UniqueKey(),
                                      child: Text(
                                          "Click To Copy :https://forms.gle/yMqYcdVHchyKqza6A "),
                                      onPressed: () {
                                        Clipboard.setData(const ClipboardData(
                                                text:
                                                    "https://forms.gle/yMqYcdVHchyKqza6A"))
                                            .then((value) {
                                          FeedbackService.successAlertSnack(
                                              "Link Copied!");
                                        });
                                      })));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: AppSwatch.primary.shade500,
                          padding: const EdgeInsets.all(15),
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        " Take Survey ",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "We want to make your birthdays about: ",
                style: adapter.textTheme.headline6,
                textAlign: TextAlign.left,
              ),
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              title: Text(
                "Quality Time",
                style: adapter.textTheme.headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.access_time,size: 25,),
              subtitle: const Text(
                  "Planning & organizing to make someone day memorable can be hard and time-consuming, stress free planning tools, like auto-invites,guest-lists & budget help you focus on what matter meaningful time with the person. "),
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

            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              leading: const Icon(Icons.handshake,size: 25,),
              title: Text(
                "Connection",
                style: adapter.textTheme.headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("We help you focus on connection through ice breakers,group-games, virtual gifts  and more"),
            ),

            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              leading: const Icon(Icons.speaker_notes_rounded,size: 25,),
              title: Text(
                "Expression",
                style: adapter.textTheme.headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                  "Love, care and appreciation that find no authentic expression is useless, and our reminder tool helps you express it when it matters."),

            ),

            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              title: Text(
                "Fun",
                style: adapter.textTheme.headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                  "Birthday group icebreakers,live games and challenges to spice up the party."),
              leading: const Icon(Icons.games,size: 25,),
            ),

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
