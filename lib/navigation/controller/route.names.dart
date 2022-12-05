
import 'package:celebrated/navigation/model/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 'https://celebrated-app.web.app'
class AppRoutes {
  static const String domainUrlBase ='https://celebratedapp.com' ;
  static const String home = "/home";
  static const String lists = "/lists";
  static const String gifts = "/gifts";
  static const String cards = "/cards";
  static const String parties = "/parties";
  static const String actions = "/actions";

  static const String about = "/about";
  static const String plan = "/plan";
  static const String celebrate = "/celebrate";
  static const String splash = "/";
  // static const String profile = "/profile";
  static const String privacy = "/privacy";
  static const String shareBoard = '/shared';
  static const String openListEdit = '/open_edit';
  static const String birthday = '/birthday';
  static const String support = "/support";

  static const String profile = "/profile";
  static const String authSignIn = "/sign_in";
  static const String authSignUp = "/sign_up";
  static const String subscriptions = "/subscriptions";
  static const String verifyEmail = "/verify_email";
  static const String completeSignIn = "/completeSignIn";
  static const String link = '/?link';
  static const String authPasswordReset =
      "/auth/password_reset";
  static const String bBoard = "/b-board";
  static const String avatarEditor = "/avatar-editor";
  static const String notFound = "/notfound";
  static const String docs = '/docs/:id';


  static List<String> noAppBarRoutes = [lists,splash,privacy ];

  static List<String> authRoutes = [profile,authSignIn,authSignIn,authPasswordReset];

  static List<AppPage> get items => [
    AppPage(name: "Home", route: home, icon: Icons.home),
        AppPage(name: "Lists", route: lists, icon: Icons.calendar_today),
        AppPage(name: "Gifts", route: gifts, icon: Icons.card_giftcard),
        AppPage(name: "Cards", route: cards, icon: Icons.email_sharp),
        AppPage(name: "Parties", route: parties, icon: Icons.cake),
        // AppPage(name: "Account", route: profile, icon: Icons.account_circle),

      ];
static AppPage homePage =     AppPage(name: "Home", route: home, icon: Icons.home);
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
