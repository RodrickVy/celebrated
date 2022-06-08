import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/view/form.submit.button.dart';
import 'package:bremind/authenticate/view/form.text.field.dart';
import 'package:bremind/birthday/adapter/birthdays.factory.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/birthday/view/birthday.card.dart';
import 'package:bremind/birthday/view/birthday.drop.down.dart';
import 'package:bremind/domain/view/page.view.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class BirthdaysView extends AppView<BirthdaysController> {
  BirthdaysView({Key? key}) : super(key: key) {
    AuthController.instance.isAuthenticated
        .listen((bool isAuthenticated) async {
      if (isAuthenticated) {
        Get.log(
            "user is authenticated with ${AuthController.instance.user.value.uid}");
        BirthdaysController.instance.getBirthdays();
      }
    });
  }

  @override
  Widget view({required BuildContext ctx, required Adaptives adapter}) {
    return Center(
      child: Text(NavController.instance.currentItem.capitalizeFirst??"",style: adapter.textTheme.headline4,),
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Stack(
    //     children: [
    //       Positioned.fill(
    //         child: ListView(
    //           children: [
    //             Container(
    //               height: 54,
    //               width: Get.width,
    //               padding: const EdgeInsets.all(12),
    //               child: ListView(
    //                 scrollDirection: Axis.horizontal,
    //                 children: [
    //                   BirthdaysDropDown(
    //                       values: ["any", ...BirthdaysController.months],
    //                       onSelect: (String val) {},
    //                       defaultValue: "any"),
    //                   const SizedBox(
    //                     width: 5,
    //                   ),
    //                   BirthdaysDropDown(
    //                     values: const [
    //                       "Names: A-Z",
    //                       "Names: Z-A",
    //                     ],
    //                     defaultValue: "Names: Z-A",
    //                     onSelect: (String val) {},
    //                   ),
    //                   const SizedBox(
    //                     width: 5,
    //                   ),
    //                   FormSubmitButton(
    //                     key: UniqueKey(),
    //                     child: Text(
    //                       "Done",
    //                       style: GoogleFonts.poppins(fontSize: 16),
    //                     ),
    //                     onPressed: () async {
    //                       await BirthdaysController.instance.getBirthdays();
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Obx(() {
    //               if (BirthdaysController.instance.birthdays.value != null) {
    //                 return Wrap(
    //                   children: [
    //                     ...BirthdaysController.instance.birthdays.value!
    //                         .map((e) {
    //                       return BirthdayCard(
    //                         birthday: e,
    //                       );
    //                     }).toList()
    //                   ],
    //                 );
    //               } else {
    //                 return SizedBox(
    //                   width: Get.width,
    //                   height: Get.height / 3,
    //                 );
    //               }
    //             }),
    //           ],
    //         ),
    //       ),
    //       Positioned(child: Center(
    //         child: Obx(() {
    //           if (BirthdaysController.editMode.isTrue) {
    //             return BirthdayEditor();
    //           }
    //           return const SizedBox();
    //         }),
    //       ))
    //     ],
    //   ),
    //   floatingActionButton: Obx(
    //     () {
    //       return FloatingActionButton(
    //         onPressed: () {
    //           BirthdaysController.editMode.toggle();
    //         },
    //         backgroundColor: Colors.pink,
    //         child: BirthdaysController.editMode.isFalse
    //             ? const Icon(Icons.add)
    //             : const Icon(Icons.clear),
    //       );
    //     },
    //   ),
    // );
  }
}

class BirthdayEditor extends StatelessWidget {
  late TextEditingController _nameEditorController;
  late TextEditingController _birthdateController;
  late TextEditingController _remindDateController;
  late ABirthday birthday;
  final String id = const Uuid().v4();
  bool isUpdating = false;

  BirthdayEditor({Key? key}) : super(key: key) {
    birthday = BirthdaysController.instance.birthdayToUpdate.value ??
        ABirthday.empty().copyWith(id: id);
    _nameEditorController = TextEditingController(text: birthday.name);
    _birthdateController =
        TextEditingController(text: birthday.date.toString());
    _remindDateController = TextEditingController(
        text:
            birthday.date.difference(birthday.remindMeWhen).inDays.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - 40,
      alignment: Alignment.center,
      child: Container(
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  width: Get.width - 20,
                  child: FormTextField(
                    label: "Name",
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(width: 0.5))),
                    controller: _nameEditorController,
                    hint: 'full name',
                    key: UniqueKey(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',
                  fieldLabelText: 'Birthdate',
                  firstDate: DateTime(1200),
                  controller: _birthdateController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 0.5))),
                  lastDate: DateTime(9090),
                  icon: const Icon(Icons.event),
                  dateLabelText: 'Birthdate',
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    FormSubmitButton(
                      key: UniqueKey(),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      onPressed: () async {
                        BirthdaysController.editMode(false);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FormSubmitButton(
                      key: UniqueKey(),
                      child: Text(
                        "Save",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      onPressed: () async {
                        if (BirthdaysController
                                .instance.birthdayToUpdate.value !=
                            null) {
                          await BirthdaysController.instance.updateContent(
                              birthday.id,
                              BirthdayFactory().toJson(birthday.copyWith(
                                name: _nameEditorController.value.text,
                                date: DateTime.parse(
                                    _birthdateController.value.text),
                              )));
                        } else {
                          await BirthdaysController.instance
                              .setContent(birthday.copyWith(
                            name: _nameEditorController.value.text,
                            date:
                                DateTime.parse(_birthdateController.value.text),
                          ));
                        }

                        BirthdaysController.editMode(false);
                        BirthdaysController.instance.getBirthdays();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
