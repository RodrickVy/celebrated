import 'package:celebrated/appIntro/controller/intro.controller.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/navigation/controller/links.handler/dynamic.links.stub.dart'
    if (dart.library.io) 'package:celebrated/navigation/controller/links.handler/dyanimiclinks.service.io.dart'
    if (dart.library.js) 'package:celebrated/navigation/controller/links.handler/dyanimiclinks.service.web.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/model/route.dart';
import 'package:celebrated/navigation/model/route.guard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavService extends GetxController {
  static AppRouteObservers onRouteListeners = AppRouteObservers.configure([
    OnRouteObserver(
        when: (route, _) => navService.routeIs(AppRoutes.splash, route),
        run: (_, __, ___) {
          introScreenController.videoController.flickControlManager?.autoPause();
        }),
    OnRouteObserver(
      when: RUN_AlWAYS,
      run: (String route, Map<String, String?> parameters, _) {
        switch (navService.baseRoute(route)) {
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
          case AppRoutes.authPasswordReset:
          case AppRoutes.authSignIn:
          case AppRoutes.authSignUp:
          case AppRoutes.verifyEmail:
          case AppRoutes.profile:
          case AppRoutes.home:
          case AppRoutes.splash:
          case AppRoutes.support:
          default:
            navService.currentBottomBarIndex(0);
        }
      },
    ),
    OnRouteObserver(
      when: (route, _) => authService.userNeedsToBeAuthenticated(route),
      run: (String route, Map<String, String?> parameters, rerouteTo) {
        rerouteTo(AppRoutes.authSignIn);
      },
    ),
    OnRouteObserver(
      when: (route, _) => authService.emailNeedsVerification(route),
      run: (String route, Map<String, String?> parameters, rerouteTo) {
        print(
            'UserNeedAuthentication: ${authService.userNeedsToBeAuthenticated(route)}   Email needs verification: ${authService.emailNeedsVerification(route)} ');
        rerouteTo(AppRoutes.verifyEmail);
      },
    ),
    OnRouteObserver(
      when: (route, _) => authService.userNeedsToSelectPlan(route),
      run: (String route, Map<String, String?> parameters, rerouteTo) {
        rerouteTo(AppRoutes.subscriptions);
      },
    ),
  ]);

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

  /// all the routes, that require users authentication for access.
  List<String> get authProtectedRoutes => [AppRoutes.profile, AppRoutes.verifyEmail];

  /// all the routes to pages where the user can authenticate
  List<String> get authRoutes => [AppRoutes.authSignIn, AppRoutes.authSignUp, AppRoutes.authPasswordReset,AppRoutes.authEmailSignInForm,AppRoutes.authEmailSignInComplete];

  /// all the routes that require to know the users current subscription
  List<String> get subscriptionClarityRoutes => [AppRoutes.parties];

  toNextRoute() {
    to(getNextRoute!);
  }

  String? get getNextRoute {
    if (nextRouteExists) {
      return Get.parameters[nextParameterId]!.split(nextRouteSlashReplacer).join("/").trim();
    }
    return null;
  }

  bool get nextRouteExists =>
      Get.parameters[nextParameterId] != null &&
      Get.parameters[nextParameterId]!
          .replaceAll(nextRouteSlashReplacer, '')
          .replaceAll('/', '')
          .trim()
          .isNotEmpty;

  String get nextRouteSlashReplacer => '--';

  String get nextParameterId => "nextTo";

  /// route tot he given route, but keeps the next parameter on the new route. the [to] method will route to a complete new route and will not preserve the next route.
  String routeKeepNext(String route, [String nextRoute = '']) {
    if (nextRoute.replaceAll(nextRouteSlashReplacer, '').replaceAll('/', '').trim().isNotEmpty) {
      String routeToBeResumed = (nextRoute).split("/").join(nextRouteSlashReplacer).trim();
      return to("$route/?$nextParameterId=$routeToBeResumed");
    } else if (nextRouteExists) {
      return to("$route/?$nextParameterId=${Get.parameters[nextParameterId]!}");
    } else {
      return to(route);
    }
  }

  void withParameter(String key, String value) {
    Map<String, String> parameters = Get.parameters.entries
        .where((element) => element.value != null)
        .fold({}, (previousValue, element) => {...previousValue, element.key: element.value!});
    parameters[key] = value;
    Get.toNamed('${Get.currentRoute.split('/?').first}/?${parameters.entries.map((e) => '${e.key}=${e.value}').join('&')}',);
  }

  /// route to a given route.
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

  @override
  onReady() {
    DynamicLinksHandler.instance.listen();
  }

  callOnRoute(String route, Map<String, String?> parameters) {
    onRouteListeners.run(route, parameters);
  }

  String baseRoute([String? route]) {

    String routePath = (route ?? Get.currentRoute).split('/?').first;
    if(routePath.replaceAll("/", '').trim().isNotEmpty){
      print( '/${routePath}');
      List<String> routeSegments = routePath.split("/").where((element) => element.trim().isNotEmpty).toList();

      return '/${routeSegments.first}';
    }else{
      return '/';
    }

  }

  ///  checks whether the given base route is the current route, ignores the parameters and any child routes,
  ///  will return true if [route] is part of the current app's route.
  bool routeIs(String route, [String? currentRoute]) {
    return (currentRoute ?? Get.currentRoute).contains(route);
  }

  /// checks the opposite of [routeIs]
  bool routeIsNot(String route, [String? currentRoute]) {
    return routeIs(route, currentRoute) == false;
  }
}

final NavService navService = NavService.instance;
