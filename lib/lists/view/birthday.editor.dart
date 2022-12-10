// ignore_for_file: must_be_immutable

import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

/// an editor for a birthday  can take , a full or empty object and returns you and edited one whent he user saves.
class BirthdayEditor extends AdaptiveUI {
  static late Rx<ABirthday> birthday;
  final String id = const Uuid().v4();
  final Function() onDelete;
  final Function(ABirthday birthday) onSave;
  final Function() onCancel;

  BirthdayEditor(
      {required this.onSave, required this.onDelete, required this.onCancel, final ABirthday? birthdayValue, Key? key})
      : super(key: key) {
    if (birthdayValue != null) {
      if (birthdayValue.id.isEmpty) {
        birthday = birthdayValue.copyWith(id: id).obs;
      } else {
        birthday = birthdayValue.obs;
      }
    } else {
      birthday = ABirthday.empty().copyWith(id: id).obs;
    }
  }

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      width: adapter.adapt(phone: Get.width - 10, tablet: 400, desktop: 600),
      alignment: Alignment.center,
      child: Card(
        elevation: 0,
        shape: AppTheme.shape,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: AppTextField(
                  label: "name",
                  decoration: AppTheme.inputDecoration,
                  hint: 'name',
                  onChanged: (String name) {
                    birthday.value = birthday.value.copyWith(name: name);
                  },
                  controller: TextEditingController(text: birthday.value.name),
                  autoFillHints: const [AutofillHints.name],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              UIFormState.dateFieldWith(
                initialValue: birthday.value.date,
                onSave: (){
                  Get.log(birthday.value.toString());
                  onSave(birthday.value.copyWith(date: UIFormState.birthdate.value));
                },
                onCancel: () {
                  birthdaysController.currentBirthdayInEdit('');
                },
              ),
              // DateTimePicker(
              //   type: DateTimePickerType.date,
              //   fieldLabelText: 'birthdate',
              //   onChanged: (String? date) {
              //
              //   },
              //   // controller: TextEditingController(text:  birthday.value.date.toIso8601String()),
              //   firstDate: DateTime(1200),
              //   style: const TextStyle(fontSize: 12),
              //   decoration: AppTheme.inputDecoration.copyWith(
              //     contentPadding: const EdgeInsets.only(left: 6),
              //     prefixIcon: const Icon(Icons.date_range),
              //     labelText: "Birthdate",
              //     hintText: 'click to change',
              //   ),
              //   lastDate: DateTime(9090),
              //   icon: const Icon(Icons.event),
              //   dateLabelText: 'birthdate',
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 18.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       AppButton(
              //         isTextButton: true,
              //         child: const Text(
              //           "Cancel",
              //         ),
              //         onPressed: () async {
              //           onCancel();
              //         },
              //       ),
              //       const SizedBox(
              //         width: 10,
              //       ),
              //       AppButton(
              //         isTextButton: true,
              //         child: const Text(
              //           "Delete",
              //         ),
              //         onPressed: () async {
              //           onDelete();
              //         },
              //       ),
              //       const SizedBox(
              //         width: 10,
              //       ),
              //       AppButton(
              //         isTextButton: true,
              //         child: const Text(
              //           "Save",
              //         ),
              //         onPressed: () async {
              //           Get.log(birthday.value.toString());
              //           onSave(birthday.value.copyWith(date: UIFormState.birthdate.value));
              //         },
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
