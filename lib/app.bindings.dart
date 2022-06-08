import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/splash/controller/splash.controller.dart';
import 'package:get/get.dart';

class AppBindings extends  Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>IntroScreenController());
    Get.put(NavController());
    Get.put(AuthController());
    Get.put(BirthdaysController());
  }
}
