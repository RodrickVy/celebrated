import 'dart:ui';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';

class FormPhoneField extends AdaptiveUI {
  final Function(PhoneNumber? phoneNumber)? onChanged;
  final Function(PhoneNumber? phoneNumber)? onSaved;
  final bool autoFocus;
  final String? initialValue;


  const FormPhoneField({
    Key? key,
    this.autoFocus = false,
    this.onChanged,
    this.onSaved,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return PhoneFormField(
      key: const Key('phone-field'),
      controller: PhoneController(
        initialValue != null && initialValue!.isNotEmpty ? PhoneNumber.parse(initialValue!) : null,
      ),
      defaultCountry: IsoCode.CA,
      autofocus: autoFocus,

      decoration: AppTheme.inputDecoration.copyWith(
        hintText: "Phone number",
        labelText: "Phone number",
        suffixIcon: onSaved != null
            ? IconButton(
                onPressed: () {
                  onSaved!(PhoneNumber.parse(UIFormState.phoneNumber.value));
                },
                icon: const Icon(Icons.save))
            : null,
      ),
      validator: (PhoneNumber? number) {
        return Validators.phoneValidator.validate(number?.international ?? "");
      },
      countrySelectorNavigator:
          CountrySelectorNavigator.dialog(width: adapter.adapt(phone: Get.width - 50, tablet: 300, desktop: 400)),
      autofillHints: const [AutofillHints.telephoneNumber],
      selectionWidthStyle: BoxWidthStyle.tight,
      onChanged: (PhoneNumber? p) {
        onChanged != null ? onChanged!(p) : () {}();
        FeedbackService.clearErrorNotification();
      }, // default null
    );
  }
}
