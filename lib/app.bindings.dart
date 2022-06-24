import 'package:bremind/appIntro/controller/intro.controller.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:get/get.dart';


/// appWide dependency injection , all loaded initially ,
/// todo: change this for lazy loading
class AppBindings extends  Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>IntroScreenController());
    Get.put(NavController());
    Get.put(AuthController());
    Get.put(BirthdaysController());
  }
}
