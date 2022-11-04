// ignore_for_file: must_be_immutable

import 'package:celebrated/domain/view/app.text.field.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final Map<Key,RxBool>  states = <Key,RxBool>{};

/// A view that simplifies editing text values with a simple expansionTile view that opens textField to edit and closes to save and display the data.
class EditableTextView extends StatelessWidget {
  final String textValue;
  final String label;
  final IconData icon;
  // final Key spinnerKey;
  late TextEditingController _textEditingController;

  final Future Function(String value) onSave;
  final int? maxLines;
  final int? minLines;
  final Color? background;
  final bool editMode;

  final Function? onIconPressed;

  EditableTextView(
      {required Key key,
      required this.textValue,
      required this.label,
      // required this.spinnerKey,
      this.background,
      required this.onSave,
      this.onIconPressed,
      required this.icon,
      this.editMode = false,
      this.maxLines,
      this.minLines})
      : super(key: key) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   __editMode(editMode);
    // });

    _textEditingController = TextEditingController(text: textValue);
  }


   RxBool get __editMode {
    states.putIfAbsent(key!, () => editMode.obs);
     return states[key]!;
   }
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        child:


        __editMode.value == true
            ? Row(
                children: [
                  Expanded(
                  child: Center(
                    child: IconButton(
                        onPressed: () {
                          __editMode(false);
                          onSave(_textEditingController.value.text);
                        },
                        icon: const Icon(
                          Icons.save,
                          color: Colors.black,
                          size: 18,
                        )),
                  ),
                ),
                  Expanded(
                    flex: 3,
                    child: AppTextField(
                        key: UniqueKey(),
                        controller: _textEditingController,
                        label: label,
                        minLines: minLines,
                        maxLines: maxLines ?? 1,
                        // maxLength: 200,
                        autoFocus: true,
                        hint: textValue),
                  ),

                ],
              )
            :Row(
          children: [
            IconButton(
              onPressed: () {
                __editMode(true);
              },
                padding: const EdgeInsets.only(bottom: 12.0),
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              )),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(textValue),
            ),

          ],
        )
      ),
    );
  }
}
