import 'package:bremind/domain/model/drop.down.action.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// used to filer birthdays
class ActionDropDown extends StatelessWidget {
  final List<DropDownAction> actions;



  const ActionDropDown(
      {Key? key, required this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: const Border.fromBorderSide(
                BorderSide(color: Colors.black45, width: 0.8))),
        child: DropdownButton<DropDownAction>(
          value: actions.first,
          icon: const Icon(Icons.more_vert),
          elevation: 16,
          borderRadius: BorderRadius.circular(12),
          style: GoogleFonts.poppins(),
          underline: Container(
            height: 2,
          ),
          onChanged: (DropDownAction? newValue) {

          },
          items: actions.map<DropdownMenuItem<DropDownAction>>((DropDownAction value) {
            return DropdownMenuItem<DropDownAction>(
              value: value,
              onTap: () {
                value.action();
              },
              child: Text(
                " ${value.name}",
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
