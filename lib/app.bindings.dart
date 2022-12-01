import 'package:celebrated/appIntro/controller/intro.controller.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:get/get.dart';


/// appWide dependency injection , all loaded initially ,
/// todo: change this for lazy loading
class AppBindings extends  Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>IntroScreenController());
    Get.put(BirthdaysController());

  }
}
