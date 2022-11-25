
import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/domain/view/bottom.navybar.dart';
import 'package:celebrated/navigation/interface/controller.interface.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/list.extention.dart';
import 'package:flutter/material.dart';

class AppBottomNavBar<T extends INavController> extends AppStateView<T> {

  AppBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {


    final BottomNavyBar bar =  BottomNavyBar(
      selectedIndex: controller.currentItemIndex,
      showElevation: true,
      itemCornerRadius: 24,
      backgroundColor: Colors.white,
      curve: Curves.easeIn,
      onItemSelected: (index) {
        controller.toAppPageIndex(index );
      },

      items: <BottomNavyBarItem>[
        ...controller.items.map2((item, index) {
          return BottomNavyBarItem(
            icon: Icon(
              item.icon,
            ),

            title: Text(item.name,),
          );
        }).toList()
      ],
    );

    return bar;
  }
}
