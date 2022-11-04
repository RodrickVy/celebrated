import 'package:celebrated/home/model/feature.dart';

class FeatureCategory {
  final String name;
  final String description;
  final List<AppFeature> features;

  const FeatureCategory({required this.name, required this.description, required this.features});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'features': features,
    };
  }

  factory FeatureCategory.fromMap(Map<String, dynamic> map) {
    return FeatureCategory(
      name: map['name'] as String,
      description: map['description'] as String,
      features: List.from(map['features']).map((e) => AppFeature.fromMap(e)).toList(),
    );
  }
}
