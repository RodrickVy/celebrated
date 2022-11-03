import 'package:bremind/support/models/dev.progress/dev.task.dart';

class DevProgressCategory {
  final String name;
  final String description;
  final List<DevTask> devTasks;

  DevProgressCategory({required this.name, required this.description, required this.devTasks});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'devTasks': devTasks,
    };
  }

  factory DevProgressCategory.fromMap(Map<String, dynamic> map) {
    return DevProgressCategory(
      name: map['name'] as String,
      description: map['description'] as String,
      devTasks: List.from(map['devTasks']).map((e) => DevTask.fromMap(e)).toList(),
    );
  }
}
