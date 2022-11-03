
import 'package:bremind/home/model/feature.progress.dart';
import 'package:flutter/material.dart';
class AppFeature {
  final String name;
  final String description;
  final TaskProgress progress;
  final IconData icon;


  const AppFeature({required this.name, required this.icon, required this.description, required this.progress});

  Map<String, dynamic> toMap() {
    return {
      'name':name,
      'description': description,
      'progress': progress.name,
      'icon':icon.toString()
    };
  }

  factory AppFeature.fromMap(Map<String, dynamic> map) {
    return AppFeature(
      description: map['description'] as String,
      progress: TaskProgress.values.byName(map['progress']),
      name: map['name'],
      icon: Icons.abc ,
    );
  }
}