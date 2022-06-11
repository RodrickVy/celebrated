import 'package:bremind/appIntro/interface/intro.controller.interface.dart';
import 'package:bremind/appIntro/models/splash.item.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:get/get.dart';

/// manages the app intro slideshow adhering to the view's interface [IAppIntroController]
class IntroScreenController extends GetxController
    implements IAppIntroController {
  Rx<int> current = 0.obs;


  @override
  SplashItem get currentItem => __items[current.value];

  @override
  int get currentItemIndex => current.value;

  @override
  bool get skipped => current.value == __items.length - 1;

  @override
  List<SplashItem> get splashItems => __items;


  /// the data for the splash screen
  final List<SplashItem> __items = [
    const SplashItem(
        title: "Save Dates",
        description: "Save birthday dates, customize when to be reminded. ",
        image: "assets/intro/man_time.png"),
    const SplashItem(
        title: "Group Birthdays",
        description:
            "Group related birthdays in lists, eg friends, co-workers,class list etc.",
        image: "assets/intro/plan.png"),
    const SplashItem(
        title: "Share Birthday Lists",
        description: "Share a birthday lits so others are notfied too.",
        image: "assets/intro/thoughts_pc.png"),
  ];

  @override
  void onInit() {
    super.onInit();
    /// if user is authenticated already no need to do app intro , must go to home page.
    if (AuthController.instance.isAuthenticated.isTrue) {
      NavController.instance.to(AppRoutes.home);
    }
  }

  /// called when next is pressed in slideshow
  @override
  void nextScreen() {
    if (current < __items.length - 1) {
      current.value++;
    } else {
      Get.toNamed(AppRoutes.auth);
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
    Get.toNamed(AppRoutes.auth);
  }
}
