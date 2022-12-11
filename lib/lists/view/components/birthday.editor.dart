// ignore_for_file: must_be_immutable

import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/support/view/notification.view.dart';
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
              Obx(()=> UIFormState.dateField(birthday.value.date)),
              //   (
              //   initialValue: birthday.value.date,
              //   onSave: (){
              //     Get.log(birthday.value.toString());
              //
              //   },
              //   onCancel: () {
              //
              //   },
              // ),
              const NotificationsView(),
              Row(mainAxisAlignment:MainAxisAlignment.end,children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(
                    isTextButton: true,
                    onPressed: (){
                      birthdaysController.currentBirthdayInEdit('');
                  },label: "Close",),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(onPressed: (){
                    if(Validators.birthdayValidator.announceValidation(UIFormState.birthdateString.value) == null){
                      onSave(birthday.value.copyWith(date: UIFormState.birthdate.value));
                    }

                  },label: "Save",),
                ),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
