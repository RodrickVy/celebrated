import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/navigation/model/route.dart';
import 'package:bremind/navigation/interface/controller.interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController implements INavController {
  @override
  String get currentItem {
    return "/${Get.currentRoute.split("/").sublist(1).first}";
  }

  @override
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  static NavController instance  = Get.find<NavController>();

  final RxInt _currentIndex = RxInt(0);

  @override
  List<AppPage> get items => AppRoutes.items;

  @override
  String decodeNextToFromRoute() {
    if (Get.parameters["nextTo"] != null) {
      return Get.parameters["nextTo"]!.split("9").join("/").trim();
    } else {
      return "";
    }
  }

  @override
  String addNextToOnRoute(String route, String nextRoute) {
    String routeToBeResumed = nextRoute.split("/").join("9").trim();

    return "$route/?nextTo=${routeToBeResumed.trim()}";
  }

  @override
  to(String route) {
    Get.toNamed(route);
  }

  @override
  int get currentItemIndex => _currentIndex.value;

  @override
  toAppPageIndex(int index) {
    _currentIndex(index);
    to(AppRoutes.items[index].route);
  }

  @override
  void closeDrawer() {
    scaffoldKey.currentState!.closeDrawer();
    Get.log("closing");
  }

  @override
  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
    Get.log("opening");
  }
}
