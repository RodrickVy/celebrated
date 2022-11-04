import 'package:celebrated/appIntro/models/intro.item.dart';

/// an interface of a controller that manages the app intro experience
abstract class IAppIntroController {
  List<IntroItem> get splashItems;

  int get currentItemIndex;

  IntroItem get currentItem;

  bool get skipped;

  IntroItem get homeItem;

  void nextScreen();

  void previousScreen();

  void skipIntro();
}
