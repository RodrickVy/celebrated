// ignore_for_file: must_be_immutable

import 'package:bremind/birthday/view/birthday.date.name.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.state.view.dart';
import 'package:bremind/domain/view/app.text.field.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/birthday/view/birthday.notify.when.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';


/// an editor for a birthday  can take , a full or empty object and returns you and edited one whent he user saves.
class BirthdayEditor extends AppStateView<BirthdaysController> {
  late TextEditingController _nameEditorController;
  late TextEditingController _birthdateController;
  late int _remindDaysBefore;
  late ABirthday birthday;
  final ABirthday? birthdayValue;
  final bool configureRemindTime;
  final Function() onDelete;
  final String id = const Uuid().v4();


  final Function(ABirthday birthday) onSave;
  final Function() onCancel;
  BirthdayEditor({required this.onSave,required this.onDelete,this.configureRemindTime = true,required this.onCancel, this.birthdayValue, Key? key})
      : super(key: key) {
    if (birthdayValue != null) {
      if (birthdayValue!.id.isEmpty) {
        birthday = birthdayValue!.copyWith(id: id);
      } else {
        birthday = birthdayValue!;
      }
    } else {
      birthday = ABirthday.empty().copyWith(id: id);
    }

    _nameEditorController = TextEditingController(text: birthday.name.capitalizeFirst);
    _birthdateController =
        TextEditingController(text: birthday.date.toString());
    _remindDaysBefore = birthday.dateWithThisYear.difference(birthday.remindMeWhen).inDays;
  }

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      width: adapter.adapt(phone: Get.width - 40, tablet: 400, desktop: 600),
      alignment: Alignment.center,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BirthdayDateForm(
                  birthdateController: _birthdateController,
                  nameTextController: _nameEditorController),
              if(configureRemindTime)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("Remind me      "),
                      Flexible(
                        child: NotifyWhen(
                            values: [(_remindDaysBefore > 15 || _remindDaysBefore < 0?_remindDaysBefore.toString():'16'),...List.generate(15, (index) => (index + 1).toString())],
                            defaultValue: _remindDaysBefore.toString(),
                            onSelect: (String day) {
                              _remindDaysBefore = int.parse(day);
                            }),
                      ),
                      const Text("   Before"),
                    ],
                  ),
                ),
              Row(
                children: [
                  AppButton(
                    key: UniqueKey(),
                    child: const Text(
                      "Cancel",
                    ),
                    onPressed: () async {
                      onCancel();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AppButton(
                    key: UniqueKey(),
                    child: const Text(
                      "Delete",
                    ),
                    onPressed: () async {
                      onDelete();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AppButton(
                    key: UniqueKey(),
                    child: const Text(
                      "Save",
                    ),
                    onPressed: () async {
                      onSave(birthday.copyWith(
                          name: _nameEditorController.text,
                          date: DateTime.parse(_birthdateController.value.text),
                          remindMeWhen: DateTime.parse(
                              _birthdateController.value.text)
                              .subtract(Duration(days: _remindDaysBefore))
                      )
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
