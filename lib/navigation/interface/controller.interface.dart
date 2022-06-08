import 'package:bremind/navigation/model/route.dart';

abstract class INavController {
  String get currentItem;

  List<AppPage> get items;

  int get currentItemIndex;
  
  to(String route);

  toAppPageIndex(int index);
  String decodeNextToFromRoute();

  String addNextToOnRoute(String route, String nextRoute);
}
