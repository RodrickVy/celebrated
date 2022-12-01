
import 'package:celebrated/subscription/models/subscription.plan.dart';

import 'feature.access.dart';

class Subscription {
  final String name;
  final int price;
  final String description;
  final List<FeatureAccess> featureAccess;
  final SubscriptionPlan id;
  final bool mainPricing;

  const Subscription({
    required this.name,
    this.mainPricing = false,
    required this.price,
    required this.description, this.id = SubscriptionPlan.free,
    required this.featureAccess
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'id':id.name,
      'featureAccess': featureAccess.map((e) => e.name).toList(),
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      name: map['name'] as String,
      price: map['price'] as int,
      id: SubscriptionPlan.values.byName(map["id"]),
      description: map['description'] as String,
      featureAccess: List.from(map['featureAccess']).map((e) =>FeatureAccess.fromMap(e)).toList(),
    );
  }
}
