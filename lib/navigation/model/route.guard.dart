import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteGuard extends GetMiddleware {
  /// the pages this should run on
  final List<String> runOn;

  /// runs if on the page returns null if all is good to continue and a new route if there is a redirect.
  /// The route and parameters given are not those the ap is about to route to , but the previous ones
  final String? Function() run;

  RouteGuard({required this.runOn, required this.run});

  @override
  RouteSettings? redirect(String? route) {
    String? redirectTo = run();
    if (redirectTo != null) {
      return RouteSettings(name: navService.mergePathWithNext(redirectTo, route));
    }
    return null;
  }
}

extension RouteGuards on List<RouteGuard> {
  guardsInPage(String pageName) {
    return where((element) => element.runOn.contains(pageName)).toList();
  }
}
