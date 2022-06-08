import 'package:bremind/splash/models/splash.item.dart';

abstract class ISplashController {
  List<SplashItem> get splashItems;

  int get currentItemIndex;

  SplashItem get currentItem;

  bool get skipped;


  void nextScreen();

  void previousScreen();

  void skipSplash();
}
