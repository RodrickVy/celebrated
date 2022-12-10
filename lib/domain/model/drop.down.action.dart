import 'package:flutter/material.dart';

class OptionAction{
  final String name;
  final VoidCallback action;
  final IconData icon;

  const OptionAction(this.name,  this.icon,this.action,);
}