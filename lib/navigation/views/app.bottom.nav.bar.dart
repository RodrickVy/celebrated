import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/navigation/interface/controller.interface.dart';
import 'package:celebrated/util/list.extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBottomNavBar<T extends INavController> extends StatelessWidget {
  final T controller = Get.find<T>();

  AppBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: controller.currentItemIndex,
      showElevation: true,
      itemCornerRadius: 24,
      backgroundColor: AppSwatch.primaryAccent,
      curve: Curves.easeIn,
      onItemSelected: (index) {
        controller.toAppPageIndex(index );
      },

      items: <BottomNavyBarItem>[
        ...controller.items.map2((item, index) {
          return BottomNavyBarItem(
            icon: Icon(
              item.icon,
              color: controller.currentItemIndex == index ? AppSwatch.primary.shade500:Colors.black54,
            ),
            activeColor: controller.currentItemIndex == index ? AppSwatch.primary.shade500:Colors.black54,

            title: Text(item.name,style: TextStyle(color: controller.currentItemIndex == index ? AppSwatch.primary.shade500:Colors.black54),),
          );
        }).toList()
      ],
    );
    // return BottomNavigationBar(
    //     currentIndex: controller.currentItemIndex,
    //     onTap: (int? index) {
    //       controller.toAppPageIndex(index ?? 0);
    //     },
    //     selectedItemColor: AppSwatch.primary.shade500,
    //     items: controller.items.map2((item, index) {
    //       return BottomNavigationBarItem(
    //         icon: Icon(
    //           item.icon,
    //           color: Colors.black87,
    //         ),
    //         label: item.name,
    //       );
    //     }).toList());
  }
}
