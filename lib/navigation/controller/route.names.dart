import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/authenticate/models/auth.pages.dart';
import 'package:celebrated/domain/model/enum.dart';
import 'package:celebrated/navigation/model/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 'https://celebrated-app.web.app'
class AppRoutes {
  static const String domainUrlBase ='http://localhost:38421' ;
  static const String home = "/home";
  static const String about = "/about";
  static const String lists = "/lists";
  static const String plan = "/plan";
  static const String celebrate = "/celebrate";
  static const String splash = "/splash";
  // static const String profile = "/profile";
  static const String privacy = "/privacy";
  static const String shareBoard = '/shared';
  static const String openListEdit = '/open_edit';
  static const String birthday = '/birthday';
  static const String support = "/support";
  static const String auth = "/auth";
  static String authSignIn = "/auth/${AuthPages.sign_in.name}";
  static String authSignUp = "/auth/${AuthPages.sign_up.name}";
  static String authPasswordReset =
      "/auth/${AnEnum.toJson(AuthPages.password_reset)}";
  static const String bBoard = "/b-board";
  static const String avatarEditor = "/avatar-editor";
  static const String notFound = "/notfound";
  static const String docs = '/docs/:id';

  static List<String> showMVPBannerRoutes = [home,auth].map((e) => e.replaceFirst('/','').split("/").first).toList();

  static List<AppPage> get items => [
        AppPage(name: "Home", route: home, icon: Icons.home),
        AppPage(name: "Lists", route: lists, icon: Icons.calendar_today),
    // AppPage(name: "Plan", route: plan, icon: Icons.checklist),
    // AppPage(name: "Celebrate", route: celebrate, icon: Icons.cake),
        // AppPage(
        //     name: "boards",
        //     route: bBoard,
        //     icon: Icons.developer_board_outlined),
        AppPage(name: "Account", route: auth, icon: Icons.account_circle),

      ];

  /// for one depth route only
  static bool isCurrentRoute(String pageName) {
    String current = Get.currentRoute.split("?").first.replaceAll("/", "");
    String matcher = pageName.trim().replaceAll("/", "").toLowerCase();

    Get.log("$current  == $matcher");
    return current == matcher;
  }


  // routes that dont have any  back option
  static List<String> noBackOptionRoute = [home];
}
