// ignore_for_file: must_be_immutable

import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



/// A view that simplifies editing text values with a simple expansionTile view that opens textField to edit and closes to save and display the data.
class EditableTextView extends StatelessWidget {
  final String textValue;
  final String label;
  final IconData icon;
  late TextEditingController _textEditingController;
  final Future Function(String value) onSave;
  final int? maxLines;
  final int? minLines;
  final Color? background;
  final bool autoFocus;
  final String hint;
  final Function? onIconPressed;
  final Key _key;
  final RxBool  needsToSave = RxBool(false);
  final bool asText;
  final TextStyle? textStyle;
  final bool noBorder;

  EditableTextView(
      {Key? key,
      required this.textValue,
      required this.label,
      // required this.spinnerKey,
        this.hint = '',
      this.background,
      required this.onSave,
        this.textStyle,
        this.noBorder = false,
      this.onIconPressed,
      required this.icon,
      this.autoFocus = false,
        this.asText = false,
      this.maxLines,
      this.minLines})
      : _key = key?? UniqueKey(), super(key: key) {

    _textEditingController = TextEditingController(text: textValue);
  }


  @override
  Widget build(BuildContext context) {
    return FeedbackSpinner(
      spinnerKey: _key,
      child: AppTextField(
          
          controller: _textEditingController,
          label: asText ? '':label,
          decoration: (asText ? AppTheme.inputDecorationNoBorder:AppTheme.inputDecoration).copyWith(
            prefixIcon: asText ? null:Icon(icon),
            hintText: hint,
            prefixIconConstraints: asText ? const BoxConstraints(maxWidth:0 ):null,
            border: noBorder? const OutlineInputBorder(borderSide: BorderSide.none) : null,
            focusedBorder: noBorder? const OutlineInputBorder(borderSide: BorderSide.none) : null,
            errorBorder: noBorder? const OutlineInputBorder(borderSide: BorderSide.none) : null,
            suffixIcon: Obx(
                ()=> IconButton(
                  onPressed: () {
                    FeedbackService.spinnerDefineState(key: _key, isOn: true);
                    onSave(_textEditingController.text);
                    needsToSave(false);
                    FeedbackService.spinnerDefineState(key: _key, isOn: false);
                  },
                  icon:  Icon( needsToSave.isTrue ? Icons.save :Icons.edit,color: needsToSave.isTrue ? AppSwatch.primary:Colors.black38,)),
            ),
          ),
          style: textStyle,
          minLines: minLines,
          onChanged: (String val){
            if(val != textValue){
              needsToSave(true);
            }else{
              needsToSave(false);
            }

          },
          maxLines: maxLines ?? 1,
          // maxLength: 200,
          autoFocus: autoFocus,

          hint: label),
    );
    // return Obx(
    //   () => AnimatedSwitcher(
    //     duration: const Duration(milliseconds: 800),
    //     child:
    //
    //
    //     __editMode.value == true
    //         ? Row(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               IconButton(
    //                   onPressed: () {
    //                     __editMode(false);
    //                     onSave(_textEditingController.value.text);
    //                   },
    //                   icon: const Icon(
    //                     Icons.save,
    //                     color: Colors.black,
    //                     size: 18,
    //                   )),
    //               Flexible(
    //                 flex: 3,
    //                 child: AppTextField(
    //                     
    //                     controller: _textEditingController,
    //                     label: label,
    //                     minLines: minLines,
    //                     maxLines: maxLines ?? 1,
    //                     // maxLength: 200,
    //                     autoFocus: true,
    //                     hint: textValue),
    //               ),
    //
    //             ],
    //           )
    //         :Row(
    //       children: [
    //         IconButton(
    //           onPressed: () {
    //             __editMode(true);
    //           },
    //             padding: const EdgeInsets.only(bottom: 12.0),
    //           icon: const Icon(
    //             Icons.edit,
    //             color: Colors.black,
    //           )),
    //         Padding(
    //           padding: const EdgeInsets.all(2.0),
    //           child: Text(textValue),
    //         ),
    //
    //       ],
    //     )
    //   ),
    // );
  }
}
