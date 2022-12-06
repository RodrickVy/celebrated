import 'package:celebrated/appIntro/interface/intro.controller.interface.dart';
import 'package:celebrated/appIntro/models/intro.item.dart';

import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/model/route.observer.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/// manages the app intro slideshow adhering to the view's interface [IAppIntroController]
class IntroScreenController extends GetxController {

  RxBool videoPlaying = true.obs;


  Rx<int> current = 0.obs;

  IntroScreenController();

  FlickManager videoController = FlickManager(
    autoPlay: false,
    autoInitialize: true,
    videoPlayerController:
    VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/celebrated-app.appspot.com/o/test.mp4?alt=media&token=2b704ee7-68d1-4958-9eb6-a8ad6b91329d'),
  );

  IntroItem get currentItem => __items[current.value];


  int get currentItemIndex => current.value;


  bool get skipped => current.value == __items.length - 1;


  List<IntroItem> get splashItems => __items;

  /// the data for the splash screen
  final List<IntroItem> __items = [
    const IntroItem(
        title: "Lists",
        description:
        "Never forget birthdays with phone,email or whatsapp message reminders. Group related birthdays into lists, and share them for others to be reminded + more.",
        image: "assets/intro/forget.png"),
    const IntroItem(
        title: "Gifts",
        description:
        "Create and share virtual gifts of any online product with personal note and packaging.Share Gift cards,subscriptions or any gift. ",
        image: "assets/intro/online_wish.png"),
    const IntroItem(
        title: "Cards",
        description:
        "Create unique birthday cards that you can invite others to sign.  Ad image/video etc on card and easily share via link.",
        image: "assets/intro/thank_you.png"),
    const IntroItem(
        title: "Parties",
        description:
        "Organize parties, with easy forms for invites, and  lists for planning. Fun birthday games from deep meaningful to funny and trivial.",
        image: "assets/intro/party_many.png"),
    const IntroItem(
        title: "Everyone Celebrated!",
        description:
        "We want to add meaning, connection and fun to the days that matter!",
        image: "assets/logos/Icon-maskable-512.png"),
  ];


  final IntroItem homeItem = const IntroItem(
      title: "No more Belated Birthdays! ",
      description: "Express appreciation to your friends and loved ones when it matters.",
      image: "assets/logos/Icon-192.png");

  String get name => "Celebrated";

  String get tagline => "adding meaning connection and fun to the days that matter";

  /// called when next is pressed in slideshow

  void nextScreen() {
    if (current < __items.length - 1) {
      current.value++;
    } else {
      navService.to(AppRoutes.profile);
    }
  }

  /// called when previous is pressed in slideshow

  void previousScreen() {
    if (current > 0) {
      current.value--;
    }
  }

  /// called when skip is pressed in slideshow

  void skipIntro() {
    navService.to(AppRoutes.profile);
  }
}


final IntroScreenController introScreenController = Get.find<IntroScreenController>();