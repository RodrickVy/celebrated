import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// used to filer birthdays
class DropContextMenu extends AdaptiveUI {
  static final OptionAction _empty = OptionAction("    ",Icons.circle, (){});
   late List<OptionAction> _actions;



   DropContextMenu(
      {Key? key, required final List<OptionAction> actions})
      : super(key: key){
     _actions = [...actions,_empty];

   }



  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return SizedBox(
      width: 100,
      child: DropdownButton<OptionAction>(
        value: _empty,
        icon: Row(mainAxisAlignment: MainAxisAlignment.end,children: const [Icon(Icons.more_vert)],),
        elevation: 16,
        borderRadius: BorderRadius.circular(0),

        selectedItemBuilder: (c){
          /// showing all actions as empty values
          return _actions.map((e) => const SizedBox(width: 50,)).toList();
        },
        underline: Container(
          height: 2,
        ),
        onChanged: (OptionAction? newValue) {
          newValue?.action();
        },
        items: _actions.map<DropdownMenuItem<OptionAction>>((OptionAction value) {
          if(value.name.isEmpty){
            return DropdownMenuItem<OptionAction>(value:value,child:const SizedBox(width: 50,));
          }
          return DropdownMenuItem<OptionAction>(
            value: value,
            child: Row(
              children: [
                Icon(value.icon),
                Text(
                  value.name,
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ],

            ),
          );
        }).toList(),
      ),
    );
  }
}


