
import 'feature.access.dart';

class Subscription {
  final String name;
  final int price;
  final String description;
  final List<FeatureAccess> featureAccess;

  const Subscription({
    required this.name,
    required this.price,
    required this.description,
    required this.featureAccess
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'featureAccess': featureAccess.map((e) => e.name).toList(),
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      name: map['name'] as String,
      price: map['price'] as int,
      description: map['description'] as String,
      featureAccess: List.from(map['featureAccess']).map((e) =>FeatureAccess.fromMap(e)).toList(),
    );
  }
}
