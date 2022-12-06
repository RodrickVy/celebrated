import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnRouteObserver {
  final bool Function(String route, Map<String, String?> parameters) when;

  final void Function(String route, Map<String, String?> parameters,void Function(String route) rerouteTo) run;

  const OnRouteObserver({required this.when, required this.run});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnRouteObserver && runtimeType == other.runtimeType && when == other.when && run == other.run;

  @override
  int get hashCode => when.hashCode ^ run.hashCode;
}

class AppRouteObservers {
  final List<OnRouteObserver> _observers;

  static AppRouteObservers? __instance;

  const AppRouteObservers._(List<OnRouteObserver> observers) : _observers = observers;

  factory AppRouteObservers.configure(List<OnRouteObserver> observers) {
    __instance ??= AppRouteObservers._(observers);
    return __instance!;
  }



  run(String route, Map<String, String?> parameters) {
    for (var observer in _observers) {
      if (observer.when(route, parameters)) {
        void rerouteTo(String newRoute){
          if(newRoute != route){
            navService.routeKeepNext(newRoute,route);
          }

        }
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          observer.run(route, parameters,rerouteTo);
        });
      }
    }
  }
}

final RUN_AlWAYS = (String route, Map<String, String?> parameters) => true;
