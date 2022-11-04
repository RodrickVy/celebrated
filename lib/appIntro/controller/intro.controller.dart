import 'package:celebrated/appIntro/interface/intro.controller.interface.dart';
import 'package:celebrated/appIntro/models/intro.item.dart';
import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:get/get.dart';

/// manages the app intro slideshow adhering to the view's interface [IAppIntroController]
class IntroScreenController extends GetxController
    implements IAppIntroController {
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
        title: "Save Dates",
        description: "Save birthday dates, customize when to be reminded. ",
        image: "assets/intro/man_time.png"),
    const IntroItem(
        title: "Group Birthdays",
        description:
            "Group related birthdays in lists, eg friends, co-workers,class list etc.",
        image: "assets/intro/plan.png"),
    const IntroItem(
        title: "Share Birthday Lists",
        description: "Share a birthday lits so others are notfied too.",
        image: "assets/intro/thoughts_pc.png"),
  ];

  @override
  final IntroItem  homeItem =     const IntroItem(
      title: "No more Belated Birthdays! ",
      description: "Express appreciation to your friends and loved ones when it matters.",
      image: "assets/logos/Icon-192.png");


  /// called when next is pressed in slideshow
  @override
  void nextScreen() {
    if (current < __items.length - 1) {
      current.value++;
    } else {
      NavController.instance.to(AppRoutes.auth);
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
    NavController.instance.to(AppRoutes.auth);
  }
}
