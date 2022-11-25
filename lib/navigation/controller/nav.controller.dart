import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/model/route.dart';
import 'package:celebrated/navigation/interface/controller.interface.dart';
import 'package:celebrated/navigation/model/route.guard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController implements INavController {
  static List<OnRouteObserver> onRouteListeners = [];

  @override
  String get currentItem {
    return "/${Get.currentRoute.split("?").first.split("/").sublist(1).first}";
  }

  @override
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  static NavController instance = Get.find<NavController>();

  final RxInt currentBottomBarIndex = RxInt(0);

  final RxBool _drawerExpanded = false.obs;

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
    List<String> params =
        parameters.keys.where((key) => parameters[key] != null && parameters[key]!.isNotEmpty).map((key) {
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

  @override
  void toggleDrawerExpansion() {
    _drawerExpanded.toggle();
  }

  @override
  bool get drawerExpanded => _drawerExpanded.value;

  static  OnRouteObserver routeCategoryListener = OnRouteObserver(
      run: (String route, Map<String, String?> parameters, Function cancel) {

        String itemName = "/${Get.currentRoute.split("?").first.split("/").sublist(1).first}";
        Get.log("Gourd working $itemName ");
        switch (itemName) {
          case AppRoutes.authPasswordReset:
          case AppRoutes.authSignIn:
          case AppRoutes.authSignUp:
          case AppRoutes.verifyEmail:
          case AppRoutes.profile:
          case AppRoutes.home:
          case AppRoutes.splash:
            case AppRoutes.support:
           NavController.instance.currentBottomBarIndex(0);
           break;
          case AppRoutes.lists:
          case AppRoutes.openListEdit:
          case AppRoutes.birthday:
          case AppRoutes.shareBoard:
            NavController.instance.currentBottomBarIndex(1);
            break;
          case AppRoutes.gifts:
            NavController.instance.currentBottomBarIndex(2);
            break;
          case AppRoutes.cards:
            NavController.instance.currentBottomBarIndex(3);
            break;
          case AppRoutes.parties:
            NavController.instance.currentBottomBarIndex(4);
            break;
        }

      },
      when: (_,__)=>true);

  @override
  onInit() {
    super.onInit();
    registerRouteObserver(routeCategoryListener);
  }

  registerRouteObserver(OnRouteObserver guard) {
      onRouteListeners.add(guard);
  }

  removeOnRoute(String key) {
    onRouteListeners.remove(key);
  }

  callOnRoute(String route, Map<String, String?> parameters) {
    for (var guard in onRouteListeners) {
      if (guard.when(route, parameters)) {
        guard.run(route, parameters, removeOnRoute);
      }
    }
  }
}
