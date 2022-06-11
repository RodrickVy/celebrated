import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormTextField extends StatelessWidget {
  final FormFieldValidator? formValidator;
  final TextEditingController? controller;
  final String label;
  final String hint;
  final IconData? fieldIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<String>? autoFillHints;
  final bool autoCorrect;
  final bool autoFocus;
  final InputDecoration? decoration;
  final ToolbarOptions? toolbarOptions;
  final int maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final bool readOnly;
  final TextStyle? style;
  final bool enabled;
  final GestureTapCallback? onTap;

  const FormTextField(
      {required Key key,
      required this.label,
      required this.hint,
      this.formValidator,
      this.onTap,
      this.controller,
      this.fieldIcon,
      this.enabled = true,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.autoFillHints,
      this.autoCorrect = false,
      this.toolbarOptions,
      this.decoration,
      this.style,
      this.maxLines = 1,
      this.readOnly = false,
      this.minLines,
      this.expands = false,
      this.maxLength,
      this.autoFocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: _decoration,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      cursorColor: Colors.black,
      onTap: onTap,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: style,
      autofillHints: autoFillHints,
      autocorrect: autoCorrect,
      autofocus: autoFocus,
      enabled: enabled,
      onChanged: (_){
        FeedbackService.clearErrorNotification();
      },
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      focusNode: FocusNode(),
    );
  }

  InputDecoration get _decoration {
    InputDecoration defaultDecoration = InputDecoration(
      labelText: label,
      // prefixIcon: Icon(
      //   fieldIcon,
      // ),
      focusColor: Colors.black,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black38)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black38)
      ),
      hintText: hint,
      labelStyle: Get.theme.textTheme.bodyText2!.copyWith(color: Colors.black),
      contentPadding: const EdgeInsets.all(8).copyWith(left: 15),
      hintStyle: Get.theme.textTheme.bodyText2!.copyWith(color: Colors.black),
      //fillColor: Colors.green
    );
    return InputDecoration(
      icon: decoration?.icon ?? defaultDecoration.icon,
      labelText: decoration?.labelText ?? defaultDecoration.labelText,
      labelStyle: decoration?.labelStyle ?? defaultDecoration.labelStyle,
      helperText: decoration?.helperText ?? defaultDecoration.helperText,
      helperStyle: decoration?.helperStyle ?? defaultDecoration.helperStyle,
      helperMaxLines: decoration?.helperMaxLines ?? defaultDecoration.helperMaxLines,
      hintText: decoration?.hintText ?? defaultDecoration.hintText,
      hintStyle: decoration?.hintStyle ?? defaultDecoration.hintStyle,
      hintTextDirection: decoration?.hintTextDirection ?? defaultDecoration.hintTextDirection,
      hintMaxLines: decoration?.hintMaxLines ?? defaultDecoration.hintMaxLines,
      errorText: decoration?.errorText ?? defaultDecoration.errorText,
      errorStyle: decoration?.errorStyle ?? defaultDecoration.errorStyle,
      errorMaxLines: decoration?.errorMaxLines ?? defaultDecoration.errorMaxLines,
      floatingLabelBehavior: decoration?.floatingLabelBehavior ?? defaultDecoration.floatingLabelBehavior,
      isCollapsed: decoration?.isCollapsed ?? defaultDecoration.isCollapsed,
      isDense: decoration?.isDense ?? defaultDecoration.isDense,
      contentPadding: decoration?.contentPadding ?? defaultDecoration.contentPadding,
      prefixIcon: decoration?.prefixIcon ?? defaultDecoration.prefixIcon,
      prefixIconConstraints: decoration?.prefixIconConstraints ?? defaultDecoration.prefixIconConstraints,
      prefix: decoration?.prefix ?? defaultDecoration.prefix,
      prefixText: decoration?.prefixText ?? defaultDecoration.prefixText,
      prefixStyle: decoration?.prefixStyle ?? defaultDecoration.prefixStyle,
      suffixIcon: decoration?.suffixIcon ?? defaultDecoration.suffixIcon,
      suffix: decoration?.suffix ?? defaultDecoration.suffix,
      suffixText: decoration?.suffixText ?? defaultDecoration.suffixText,
      suffixStyle: decoration?.suffixStyle ?? defaultDecoration.suffixStyle,
      suffixIconConstraints: decoration?.suffixIconConstraints ?? defaultDecoration.suffixIconConstraints,
      counter: decoration?.counter ?? defaultDecoration.counter,
      counterText: decoration?.counterText ?? defaultDecoration.counterText,
      counterStyle: decoration?.counterStyle ?? defaultDecoration.counterStyle,
      filled: decoration?.filled ?? defaultDecoration.filled,
      fillColor: decoration?.fillColor ?? defaultDecoration.fillColor,
      focusColor: decoration?.focusColor ?? defaultDecoration.focusColor,
      hoverColor: decoration?.hoverColor ?? defaultDecoration.hoverColor,
      errorBorder: decoration?.errorBorder ?? defaultDecoration.errorBorder,
      focusedBorder: decoration?.focusedBorder ?? defaultDecoration.focusedBorder,
      focusedErrorBorder: decoration?.focusedErrorBorder ?? defaultDecoration.focusedErrorBorder,
      disabledBorder: decoration?.disabledBorder ?? defaultDecoration.disabledBorder,
      enabledBorder: decoration?.enabledBorder ?? defaultDecoration.enabledBorder,
      border: decoration?.border ?? defaultDecoration.border,
      enabled: decoration?.enabled ?? defaultDecoration.enabled,
      semanticCounterText: decoration?.semanticCounterText ?? defaultDecoration.semanticCounterText,
    );
  }
}
