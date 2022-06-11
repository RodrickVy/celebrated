import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'birthday.editor.dart';

class BirthdayCard extends StatelessWidget {
  final RxBool __inEditMode = RxBool(false);
  final ABirthday birthday;
  final double? width;
  final double? height;
  final Function(ABirthday birthday) onEdit;
  final Function(ABirthday birthday) onDelete;

  BirthdayCard(
      {Key? key,
      this.width = 160,
      this.height = 260,
      required this.onDelete,
      required this.birthday,
      required this.onEdit})
      : super(key: key) {
    // Timer(const Duration(seconds: 5), () {
    //   BirthdaysController.instance.update([birthday.id]);
    //   __counter.value++;
    // });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: __inEditMode.value
            ? BirthdayEditor(
                onSave: (ABirthday birthday) {
                  onEdit(birthday);
                },
                birthdayValue: birthday,
              )
            : Card(
                elevation: 1,
                color: birthday.isPast
                    ? Colors.blueGrey.withAlpha(50)
                    : Get.theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: Get.width,
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.white12,
                                      Colors.white24
                                    ])),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                    BirthdaysController.monthsShortForm[
                                        birthday.date.month - 1],
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 17)),
                                Text(birthday.date.day.toString(),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40)),
                                Text(birthday.name,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                CountdownTimer(
                                  endWidget: const SizedBox(),
                                  endTime: birthday
                                      .dateWithThisYear.millisecondsSinceEpoch,
                                  onEnd: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  BirthdaysController.editMode.value = true;
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  onDelete(birthday);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
