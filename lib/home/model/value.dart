

import 'package:flutter/material.dart';

class CoreValue{
  final String name;
  final String image;
  final String description;
  final Color color;

  const CoreValue({required this.color, required this.name,  this.image='', required this.description});
}