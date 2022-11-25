import 'package:flutter/cupertino.dart';

class AppPage {
  final String name;
  final String route;
  final IconData icon;

  AppPage({required this.name, required this.route, required this.icon});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPage &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          route == other.route &&
          icon == other.icon;

  @override
  int get hashCode => name.hashCode ^ route.hashCode ^ icon.hashCode;
}
