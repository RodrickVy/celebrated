import 'package:flutter/material.dart';

class DropDownAction{
  final String name;
  final VoidCallback action;
  final IconData icon;

  const DropDownAction(this.name,  this.icon,this.action,);
}