import 'package:flutter/material.dart';

class ButtonAction {
  final String name;
  final Function action;
  final IconData? icon;

  ButtonAction({required this.name, required this.action, this.icon});

  factory ButtonAction.icon(final String name, final Function action, final IconData icon) {
    return ButtonAction(name: name, action: action, icon: icon);
  }
}

class AppBanner {
  final String title;
  final List<ButtonAction> actions;
  final String? image;
  final String? description;
  final Color? color;

  AppBanner({this.color, required this.title, required this.actions, this.image,  this.description});

  factory AppBanner.image(  final String title,
      final List<ButtonAction> actions,
      final String? image,
      final Color? color,
      final String? description){
    return AppBanner(description: description,image: image, color:color,title:title, actions: actions);
  }
}
