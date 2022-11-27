import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/model/route.dart';
import 'package:celebrated/navigation/model/route.guard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavService extends GetxController {
  static List<OnRouteObserver> onRouteListeners = [];

  String get currentItem {
    return "/${Get.currentRoute.split("?").first.split("/").sublist(1).first}";
  }

  NavService._() {
    onInit();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  static NavService instance = NavService._();

  final RxInt currentBottomBarIndex = RxInt(0);

  final RxBool _drawerExpanded = false.obs;

  List<AppPage> get items => AppRoutes.items;

  String decodeNextToFromRoute() {
    if (Get.parameters["nextTo"] != null) {
      return Get.parameters["nextTo"]!.split("9").join("/").trim();
    } else {
      return "";
    }
  }

  String addNextToOnRoute(String route, String nextRoute) {
    String routeToBeResumed = nextRoute.split("/").join("9").trim();

    return "$route/?nextTo=${routeToBeResumed.trim()}";
  }

  to(String route) {
    Get.toNamed(route);
  }

  int get currentItemIndex => currentBottomBarIndex.value;

  toAppPageIndex(int index) {
    currentBottomBarIndex(index);
    to(AppRoutes.items[index].route);
  }

  void closeDrawer() {
    scaffoldKey.currentState!.closeDrawer();
    Get.log("closing");
  }

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
    Get.log("opening");
  }

  void withParam(String key, String value) {
    Get.log("Adding $key with $value");
    navService.to(currentRouteWithParams({...Get.parameters, key: value}));
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
    navService.to(currentRouteWithParams(Get.parameters..remove(key)));
  }

  void back() {
    Get.back();
  }

  void toggleDrawerExpansion() {
    _drawerExpanded.toggle();
  }

  bool get drawerExpanded => _drawerExpanded.value;

  static OnRouteObserver routeCategoryListener = OnRouteObserver(
      run: (String route, Map<String, String?> parameters,_,__) {

        final String itemName = '/${route.split("/").last}';
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
           navService.currentBottomBarIndex(0);
            break;
          case AppRoutes.lists:
          case AppRoutes.openListEdit:
          case AppRoutes.birthday:
          case AppRoutes.shareBoard:
           navService.currentBottomBarIndex(1);
            break;
          case AppRoutes.gifts:
           navService.currentBottomBarIndex(2);
            break;
          case AppRoutes.cards:
           navService.currentBottomBarIndex(3);
            break;
          case AppRoutes.parties:
           navService.currentBottomBarIndex(4);
            break;
        }
      },
      when: (_, __) => true);

  @override
  onInit() {
    super.onInit();
    registerRouteObserver(routeCategoryListener);
  }

  registerRouteObserver(OnRouteObserver guard) {
    onRouteListeners.add(guard);
  }

  removeOnRoute(OnRouteObserver observer) {
    onRouteListeners.remove(observer);
  }

  callOnRoute(String route, Map<String, String?> parameters) {
    for (var guard in onRouteListeners) {
      if (guard.when(route, parameters)) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          guard.run(route, parameters, removeOnRoute,to);
        });
      }
    }
  }
}

final NavService navService = NavService.instance;
