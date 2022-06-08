import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/splash/interface/splash.controller.interface.dart';
import 'package:bremind/splash/models/splash.item.dart';
import 'package:get/get.dart';

class IntroScreenController extends GetxController
    implements ISplashController {
  Rx<int> current = 0.obs;


  @override
  SplashItem get currentItem => __items[current.value];

  @override
  int get currentItemIndex => current.value;

  @override
  bool get skipped => current.value == __items.length - 1;

  @override
  List<SplashItem> get splashItems => __items;

  final List<SplashItem> __items = [
    const SplashItem(
        title: "Save Dates",
        description:
            "Save birthday dates, customize when to be reminded. ",
        image: "assets/intro/man_time.png"),
    const SplashItem(
        title: "Group Birthdays",
        description:
            "Group related birthdays in lists, eg friends, co-workers,class list etc.",
        image: "assets/intro/plan.png"),
    const SplashItem(
        title: "Share Birthday Lists",
        description:
            "Share a birthday lits so others are notfied too.",
        image: "assets/intro/thoughts_pc.png"),
  ];



  @override
  void onInit() {
    super.onInit();
  }

  @override
  void nextScreen() {
    if (current < __items.length - 1) {
      current.value++;
    } else {
      Get.toNamed(AppRoutes.auth);
    }
  }

  @override
  void previousScreen() {
    if (current > 0) {
      current.value--;
    }
  }

  @override
  void skipSplash() {
    Get.toNamed(AppRoutes.auth);
  }

}
