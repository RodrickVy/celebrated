import 'package:bremind/authenticate/view/form.text.field.dart';
import 'package:bremind/support/view/afro_spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpansionTextEditor extends StatelessWidget {
  final String textValue;
  final String label;
  final IconData icon;
  final Key spinnerKey;
  late TextEditingController _textEditingController;
  final RxBool editing = false.obs;
  final Future Function(String value) onSave;
  final int? maxLines;
  final int? minLines;
  ExpansionTextEditor(
      {Key? key,
      required this.textValue,
      required this.label,
        required this.spinnerKey,
      required this.onSave,
      required this.icon,  this.maxLines, this.minLines})
      : super(key: key) {
    _textEditingController = TextEditingController(text: textValue);
  }

  @override
  Widget build(BuildContext context) {
    return SpinnerView(
      spinnerKey: spinnerKey,
      child: Card(
          clipBehavior: Clip.hardEdge,
          elevation: 0,
          margin: const EdgeInsets.only(left: 20, top: 12, right: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
              leading: Icon(
                icon,
              ),
              title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(textValue),
              ),
              onExpansionChanged: (expanding) {
                if (expanding) {

                  editing(true);
                } else {
                  onSave(_textEditingController.text);
                  editing(false);
                }
              },
              trailing: Obx(() {
                return editing.value
                    ? const Icon(
                        Icons.save,
                        color: Colors.orange,
                      )
                    : const Icon(Icons.edit);
              }),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FormTextField(
                      key: UniqueKey(),
                      controller: _textEditingController,
                      label: label,
                      minLines: minLines,
                      maxLines: maxLines?? 1,
                      maxLength: 200,
                      hint: textValue),
                )
              ])),
    );
  }
}
