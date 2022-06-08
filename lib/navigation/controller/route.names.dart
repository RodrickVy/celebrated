import 'package:bremind/navigation/model/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String home = "/home";
  static const String dev = "/about";
  static const String splash = "/splash";
  static const String search = "/search";
  static const String profile = "/profile";
  static const String support = "/support";
  static const String auth = "/auth";
  static const String proverb = "/proverb";
  static const String leaderBoard = "/leader_board";
  static const String games = "/games";
  static const String proverbContribution = "/proverbContribution";
  static const String avatarEditor = "/avatar-editor";
  static const String proverbs = "/proverbs";

  static List<AppPage> get items => [
        AppPage(name: "Home", route: home, icon: Icons.home),
        AppPage(name: "About", route: dev, icon: Icons.info),
        AppPage(name: "Search", route: search, icon: Icons.search),
        AppPage(name: "Profile", route: profile, icon: Icons.account_circle),
        AppPage(name: "Support", route: support, icon: Icons.support),
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
