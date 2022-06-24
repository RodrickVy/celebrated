import 'package:bremind/domain/model/drop.down.action.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// used to filer birthdays
class ActionDropDown extends StatelessWidget {
   final DropDownAction _empty =DropDownAction("    ", (){});
  late List<DropDownAction> _actions;



   ActionDropDown(
      {Key? key, required final List<DropDownAction> actions})
      : super(key: key){
     _actions = [...actions,_empty];

   }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<DropDownAction>(
      value: _empty,
      icon: Row(mainAxisAlignment: MainAxisAlignment.end,children: [const Icon(Icons.more_vert)],),
      elevation: 16,
      borderRadius: BorderRadius.circular(0),
      selectedItemBuilder: (c){
        /// showing all actions as empty values
        return _actions.map((e) => const SizedBox(width: 50,)).toList();
      },
      underline: Container(
        height: 2,
      ),
      onChanged: (DropDownAction? newValue) {
        newValue?.action();
      },
      items: _actions.map<DropdownMenuItem<DropDownAction>>((DropDownAction value) {
        return DropdownMenuItem<DropDownAction>(
          value: value,
          child: Text(
            value.name,
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        );
      }).toList(),
    );
  }
}
