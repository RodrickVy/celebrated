import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListNameFormField extends StatelessWidget {
  final String label;
  final String value;
  final Function(String? value) onSave;

  const ListNameFormField({super.key, required this.label, required this.value, required this.onSave});

  @override
  Widget build(BuildContext context) {
   return AppTextField(
     label: "name",
     decoration: InputDecoration(
         border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(0),
             borderSide: const BorderSide(width: 0.5))),
     controller: TextEditingController(),
     hint: 'organization name',
     key: UniqueKey(),
   );
  }



}
