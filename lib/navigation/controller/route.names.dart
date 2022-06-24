import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/models/auth.pages.dart';
import 'package:bremind/domain/model/enum.dart';
import 'package:bremind/navigation/model/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String domainUrlBase = 'https://breminderapp.firebaseapp.com';
  static const String home = "/home";
  static const String about = "/about";
  static const String lists = "/lists";
  static const String splash = "/splash";
  // static const String profile = "/profile";
  static const String privacy = "/privacy";
  static const String shareBoard = '/shared';
  static const String openListEdit = '/open_edit';
  static const String birthday = '/birthday';
  static const String support = "/support";
  static const String auth = "/auth";
  static String authSignIn = "/auth/${AnEnum.toJson(AuthPages.sign_in)}";
  static String authSignUp = "/auth/${AnEnum.toJson(AuthPages.sign_up)}";
  static String authPasswordReset =
      "/auth/${AnEnum.toJson(AuthPages.password_rest)}";
  static const String bBoard = "/b-board";
  static const String avatarEditor = "/avatar-editor";
  static const String notFound = "/notfound";

  static List<AppPage> get items => [
        AppPage(name: "Home", route: home, icon: Icons.home),
        AppPage(name: "Lists", route: lists, icon: Icons.calendar_today),
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
}
