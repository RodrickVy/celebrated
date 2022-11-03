import 'package:bremind/domain/model/content.dart';
import 'package:bremind/support/models/dev.progress/dev.progress.category.dart';
// todo write a tests for this class
class DevProgress extends Content {
  final String title;
  final String image;
  final String description;
  final List<DevProgressCategory> categories;

  DevProgress({required this.title,required this.image, required this.description, required this.categories});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image':image,
      'description':description,
      'categories': categories.map((e) => e.toMap()).toList(),
    };
  }

  factory DevProgress.fromMap(Map<String, dynamic> map) {
    return DevProgress(
      title: map['title'] as String,
      image:map['image'],
      description: map['description'] as String,
      categories: List.from(map['categories']).map((e) => DevProgressCategory.fromMap(e)).toList(),
    );
  }
}
