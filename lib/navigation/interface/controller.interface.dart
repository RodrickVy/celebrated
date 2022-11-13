import 'package:celebrated/navigation/model/route.dart';
import 'package:flutter/material.dart';

abstract class INavController {
  String get currentItem;

  List<AppPage> get items;

  int get currentItemIndex;
  void toggleDrawerExpansion();
  bool get drawerExpanded;
  to(String route);

  toAppPageIndex(int index);
  String decodeNextToFromRoute();

  String addNextToOnRoute(String route, String nextRoute);

   GlobalKey<ScaffoldState> get scaffoldKey;

  void closeDrawer();

  void openDrawer();

}
