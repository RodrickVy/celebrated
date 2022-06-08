import 'package:bremind/domain/page.view.dart';
import 'package:bremind/navigation/interface/controller.interface.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:bremind/util/list.extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBottomNavBar<T extends INavController> extends StatelessWidget {
  final T controller = Get.find<T>();

  AppBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return BottomNavigationBar(
        currentIndex: controller.currentItemIndex,
        onTap: (int? index) {
          controller.toAppPageIndex(index ?? 0);
        },
        items: controller.items.map2((item, index) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.name,
          );
        }).toList());
  }
}
