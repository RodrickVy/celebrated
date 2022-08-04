import 'package:bremind/domain/view/app.text.field.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BirthdayDateForm extends StatelessWidget {
  final TextEditingController? nameTextController;
  final TextEditingController? birthdateController;

  final bool showName;
  final bool showDate;

  final Function(String value)? onDateFieldSubmitted;

  const BirthdayDateForm(
      {super.key,
      this.onDateFieldSubmitted,
       this.birthdateController,
      this.showName = true,
      this.nameTextController,  this.showDate =true}):assert((showName == false && showDate == false) == false,"showName and showDate both cant be false!");

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showName)
          Expanded(
            flex: 10,
            child: Container(
              padding: const EdgeInsets.only(top: 4),
              height: 64,
              child: AppTextField(
                label: "name",
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(width: 0.5))),
                controller: nameTextController,
                hint: 'organization name',
                key: UniqueKey(),
              ),
            ),
          ),
        if (showName)
          const SizedBox(
            height: 10,
          ),
        if (showDate)
            Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(4),
            child: DateTimePicker(
              type: DateTimePickerType.date,
              // dateMask: 'DD,MM, yyyy',
              fieldLabelText: 'birthdate',
              onChanged: (String? date) {
                Get.log("updated field");
                onDateFieldSubmitted != null
                    ? onDateFieldSubmitted!(date!)
                    : () {};
              },
              firstDate: DateTime(1200),
              style: const TextStyle(fontSize: 12),
              controller: birthdateController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(width: 0.5))),
              lastDate: DateTime(9090),
              icon: const Icon(Icons.event),
              dateLabelText: 'birthdate',
            ),
          ),
        ),
      ],
    );
  }
}
