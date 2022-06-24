import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/navigation/model/route.dart';
import 'package:bremind/navigation/interface/controller.interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController implements INavController {
  @override
  String get currentItem {
    return "/${Get.currentRoute.split("?").first.split("/").sublist(1).first}";
  }

  @override
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  static NavController instance = Get.find<NavController>();

  final RxInt currentBottomBarIndex = RxInt(0);

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
  int get currentItemIndex => currentBottomBarIndex.value;

  @override
  toAppPageIndex(int index) {
    currentBottomBarIndex(index);
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

  void withParam(String key, String value) {
    Get.log("Adding $key with $value");
    Get.toNamed(currentRouteWithParams({...Get.parameters, key: value}));
  }

  String currentRouteWithParams(Map<String, String?> parameters) {
    String route = Get.currentRoute.split("?").first + paramsRouteSectionFromParams(parameters);
    Get.log("full route is $route is route");
    return route;
  }

  String paramsRouteSectionFromParams(Map<String, String?> parameters) {
    List<String> params = parameters.keys
        .where((key) =>
    parameters[key] != null && parameters[key]!.isNotEmpty)
        .map((key) {
      return "$key=${parameters[key]}";
    }).toList();
    if (params.isNotEmpty) {



      if (params.length == 1) {
        return "?${params.first}";
      } else {
        return "?${params.first}&${params.sublist(1).join("&")}";
      }
    } else {
      return "";
    }
  }

  void popParam(String key) {
    Get.toNamed(currentRouteWithParams(Get.parameters..remove(key)));
  }

  void back() {
    Get.back();
  }
}
