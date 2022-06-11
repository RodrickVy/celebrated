// ignore_for_file: must_be_immutable

import 'package:bremind/domain/view/app.text.field.dart';
import 'package:bremind/support/view/feedback.spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A view that simplifies editing text values with a simple expansionTile view that opens textField to edit and closes to save and display the data.
class EditableTextView extends StatelessWidget {
  final String textValue;
  final String label;
  final IconData icon;
  final Key spinnerKey;
  late TextEditingController _textEditingController;
  final RxBool editing = false.obs;
  final Future Function(String value) onSave;
  final int? maxLines;
  final int? minLines;
  final Color? background;

  EditableTextView(
      {Key? key,
      required this.textValue,
      required this.label,
      required this.spinnerKey,
      this.background,
      required this.onSave,
      required this.icon,
      this.maxLines,
      this.minLines})
      : super(key: key) {
    _textEditingController = TextEditingController(text: textValue);
  }

  @override
  Widget build(BuildContext context) {
    return FeedbackSpinner(
      spinnerKey: spinnerKey,
      child: SizedBox(
        height: 60,
          // clipBehavior: Clip.hardEdge,
          // elevation: 0,
          // color: background,
          // margin: const EdgeInsets.only(left: 20, top: 12, right: 12),
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Obx(
            ()=> GestureDetector(
              onTap: (){
                if(editing.value == false){
                  editing.value =true;
                }

              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child: editing.value
                    ? ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppTextField(
                              key: UniqueKey(),
                              controller: _textEditingController,
                              label: label,
                              minLines: minLines,
                              maxLines: maxLines ?? 1,
                              // maxLength: 200,

                              hint: textValue),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              editing(false);
                              onSave(_textEditingController.value.text);
                            },
                            icon: const Icon(
                              Icons.save,
                              color: Colors.black,
                            )),
                      )
                    : ListTile(
                        leading: Icon(
                          icon,
                          color: Colors.black38,
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              editing(true);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            )),
                        title: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(textValue),
                        ),
                      ),
              ),
            ),
          )),
    );
  }
}
