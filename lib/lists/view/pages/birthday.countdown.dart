import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/app.page.view.dart';
import 'package:celebrated/domain/view/pages/loading.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:share_plus/share_plus.dart';



/// the homepage for birthdays, has tips, current birthdays etc.
class BirthdayCountDown extends AppPageView {
   BirthdayCountDown({Key? key}) : super(key: key);

  final Future<ABirthday> birthday = birthdaysController.birthdayFromBirthdayId();
  
  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return FutureBuilder(
        future: birthday,
        builder: (context, AsyncSnapshot<ABirthday> snapshot) {
          if (!snapshot.hasData) {
            return const LoadingSpinner();
          }else if(snapshot.hasError){

          }

          final ABirthday birthday = snapshot.data!;
          return Container(
            width: adapter.width,
            height: adapter.height,
            color: Colors.white,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            child: Container(
              width: adapter.adapt(
                  phone: adapter.width, tablet: adapter.width, desktop: 800),
              height: adapter.height,
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ImageFade(
                        width: 300,
                        image: AssetImage(
                          "assets/intro/announcement.png",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${birthday.name.trim().replaceAll("\n", '')}'s",
                      style: adapter.textTheme.headline5
                          ?.copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "birthday is in",
                    style: adapter.textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    color: AppSwatch.primary.shade500.withAlpha(1),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CountdownTimer(
                        textStyle: Adaptive(ctx).adapt(phone: adapter.textTheme.headline5, tablet: adapter.textTheme.headline5, desktop: adapter.textTheme.headline3)
                            ?.copyWith(fontWeight: FontWeight.bold),

                        endTime: birthday.isPast
                            ? DateTime(
                                    DateTime.now().year + 1,
                                    birthday.dateWithThisYear.month,
                                    birthday.dateWithThisYear.day)
                                .millisecondsSinceEpoch
                            : birthday.dateWithThisYear.millisecondsSinceEpoch,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: AppButton(
                      isTextButton:true,
                      onPressed: () async {
                        if (GetPlatform.isWeb) {
                          Clipboard.setData(
                              ClipboardData(text:AppRoutes.domainUrlBase+Get.currentRoute));
                          FeedbackService.clearErrorNotification();
                          FeedbackService.successAlertSnack('Link Copied!');
                        } else {
                          await Share.share(AppRoutes.domainUrlBase+Get.currentRoute);
                          FeedbackService.clearErrorNotification();
                        }
                      },
                      
                      child: const Text("Share Reminder to others"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "",
                      style: adapter.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
//                     
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
//                       
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
//                       
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
