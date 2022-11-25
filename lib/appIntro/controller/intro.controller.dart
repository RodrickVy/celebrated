import 'package:celebrated/appIntro/interface/intro.controller.interface.dart';
import 'package:celebrated/appIntro/models/intro.item.dart';
import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:get/get.dart';

/// manages the app intro slideshow adhering to the view's interface [IAppIntroController]
class IntroScreenController extends GetxController implements IAppIntroController {
  Rx<int> current = 0.obs;

  @override
  IntroItem get currentItem => __items[current.value];

  @override
  int get currentItemIndex => current.value;

  @override
  bool get skipped => current.value == __items.length - 1;

  @override
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

  @override
  final IntroItem homeItem = const IntroItem(
      title: "No more Belated Birthdays! ",
      description: "Express appreciation to your friends and loved ones when it matters.",
      image: "assets/logos/Icon-192.png");

  /// called when next is pressed in slideshow
  @override
  void nextScreen() {
    if (current < __items.length - 1) {
      current.value++;
    } else {
      NavController.instance.to(AppRoutes.profile);
    }
  }

  /// called when previous is pressed in slideshow
  @override
  void previousScreen() {
    if (current > 0) {
      current.value--;
    }
  }

  /// called when skip is pressed in slideshow
  @override
  void skipIntro() {
    NavController.instance.to(AppRoutes.profile);
  }
}
