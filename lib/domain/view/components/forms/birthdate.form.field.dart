import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class BirthdayDateForm extends AdaptiveUI {
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
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return SizedBox(
      height: 133,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showName)
            SizedBox(
              // padding: const EdgeInsets.only(top: 4),
              height: 64,
              child: AppTextField(
                label: "name",
                decoration: AppTheme.inputDecoration,
                controller: nameTextController,
                hint: 'name',
                autoFillHints: const [AutofillHints.name],
                key: UniqueKey(),
              ),
            ),
          if (showName)
            const SizedBox(
              height: 5,
            ),
          if (showDate)
            SizedBox(
              height: 64,

              child: DateTimePicker(
                type: DateTimePickerType.date,
                // dateMask: 'DD,MM, yyyy',
                fieldLabelText: 'birthdate',
                onChanged: (String? date) {

                  onDateFieldSubmitted != null
                      ? onDateFieldSubmitted!(date!)
                      : () {};
                },
                firstDate: DateTime(1200),
                style: const TextStyle(fontSize: 12),
                controller: birthdateController,
                decoration: AppTheme.inputDecoration.copyWith(
                  contentPadding: const EdgeInsets.only(left: 6),
                  prefixIcon: const Icon(Icons.date_range),
                  labelText: "Birthdate",
                  hintText: 'click to change',
                ),
                lastDate: DateTime(9090),
                icon: const Icon(Icons.event),
                dateLabelText: 'birthdate',
              ),
            ),
        ],
      ),
    );
  }
}