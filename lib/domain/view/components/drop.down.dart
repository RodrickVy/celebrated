import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/util/list.extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
RxInt selectedIndex = 0.obs;
/// used to filer birthdays
class ButtonDropDown extends StatelessWidget {

    late List<DropDownAction> _actions;



   ButtonDropDown(
      {Key? key, required final List<DropDownAction> actions})
      : super(key: key){
     if(_actions.isEmpty){
       _actions = [...actions];
     }


   }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      selectedIndex.value;
      return DropdownButton<DropDownAction>(
        value: _actions[selectedIndex.value],
        // icon: Row(mainAxisAlignment: MainAxisAlignment.end,children: [const Icon(Icons.more_vert)],),
        elevation: 16,
        borderRadius: BorderRadius.circular(0),
        //
        // selectedItemBuilder: (c){
        //   /// showing all actions as empty values
        //   return _actions.map((e) => const SizedBox(width: 50,)).toList();
        // },
        underline: Container(
          height: 2,
        ),
        onChanged: (DropDownAction? value) {
          _actions.forEach2((e,index){
            if(e.name.toLowerCase() == value?.name.toLowerCase()){
              selectedIndex.value = index;
            }
          });
          value?.action();
        },
        items: _actions.map<DropdownMenuItem<DropDownAction>>((DropDownAction value) {
          return DropdownMenuItem<DropDownAction>(
            value: value,
            onTap: (){
              _actions.map2((e,index){
                if(e.name.toLowerCase() == value.name.toLowerCase()){
                  selectedIndex.value = index;
                }
              });
              value.action();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value.name,
                style: GoogleFonts.poppins(color: Colors.black),
              ),
            ),
          );
        }).toList(),
      );
    },
    );
  }
}
