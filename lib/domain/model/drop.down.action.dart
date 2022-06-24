import 'package:flutter/material.dart';

class DropDownAction{
  final String name;
  final VoidCallback action;

  const DropDownAction(this.name, this.action);
}