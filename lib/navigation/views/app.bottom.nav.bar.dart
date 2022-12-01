
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/components/nav/bottom.navybar.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/list.extension.dart';
import 'package:flutter/material.dart';

class AppBottomNavBar extends AdaptiveUI {

  const AppBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {


    final BottomNavyBar bar =  BottomNavyBar(
      selectedIndex: navService.currentItemIndex,
      showElevation: true,
      itemCornerRadius: 24,
      backgroundColor: Colors.white,
      curve: Curves.easeIn,
      onItemSelected: (index) {
        navService.toAppPageIndex(index );
      },

      items: <BottomNavyBarItem>[
        ...navService.items.map2((item, index) {
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
