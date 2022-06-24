import 'package:bremind/domain/view/app.text.field.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class BirthdayDateForm extends StatelessWidget {
  final TextEditingController nameTextController;
 final TextEditingController birthdateController ;

  const BirthdayDateForm({super.key, required this.birthdateController, required this.nameTextController});

  @override
  Widget build(BuildContext context) {
    return         Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex:10,
          child: Container(
            padding: const EdgeInsets.only(top: 6),
            height: 60,

            child: AppTextField(
              label: "your name",
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(width: 0.5))),
              controller: nameTextController,
              hint: 'full name',
              key: UniqueKey(),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          flex:6,
          child: Container(
            padding: const EdgeInsets.all(6),

            child: DateTimePicker(
              type: DateTimePickerType.date,
              // dateMask: 'DD,MM, yyyy',
              fieldLabelText: 'birthdate',

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
