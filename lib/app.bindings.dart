import 'package:celebrated/appIntro/controller/intro.controller.dart';
import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/document/controller/document.view.controller.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/support/controller/support.controller.dart';
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
