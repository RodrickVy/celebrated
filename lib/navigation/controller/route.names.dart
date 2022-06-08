import 'package:bremind/navigation/model/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String home = "/home";
  static const String about = "/about";
  static const String lists = "/lists";
  static const String splash = "/splash";
  static const String profile = "/profile";
  static const String support = "/support";
  static const String auth = "/auth";
  static const String bBoard = "/b-board";
  static const String avatarEditor = "/avatar-editor";

  static List<AppPage> get items => [
        AppPage(name: "Home", route: home, icon: Icons.home),
        AppPage(name: "Lists", route: lists, icon: Icons.calendar_today),
        AppPage(
            name: "boards",
            route: bBoard,
            icon: Icons.developer_board_outlined),
        AppPage(name: "Account", route: profile, icon: Icons.account_circle),
      ];

  /// for one depth route only
  static bool isCurrentRoute(String pageName) {
    String current = Get.currentRoute.split("?").first.replaceAll("/", "");
    String matcher = pageName.trim().replaceAll("/", "").toLowerCase();

    Get.log("$current  == $matcher");
    return current == matcher;
  }
}

/// News and updates
//
// Report
// Profile
// Proverb contribution
// Search
