
import 'package:bremind/support/models/dev.progress/task.progress.dart';

class DevTask {
  final String description;
  final TaskProgress progress;

  DevTask({required this.description, required this.progress});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'progress': progress.name,
    };
  }

  factory DevTask.fromMap(Map<String, dynamic> map) {
    return DevTask(
      description: map['description'] as String,
      progress: TaskProgress.values.byName(map['progress']) ,
    );
  }
}