import 'package:celebrated/subscription/models/feature.access.dart';
import 'package:celebrated/subscription/models/subscription.dart';

class SubscriptionService {

  static const List<Subscription> subscriptions = [
    Subscription(
      name: 'Free',
      price: 0,
      description: 'Free forever/with ads',
      featureAccess: [
        FeatureAccess(name: "Create and share birthday wishlist"),
        FeatureAccess(name: "Categorize birthdays in lists"),
        FeatureAccess(name: "Phone notification birthday reminders"),
        FeatureAccess(name: "Email notification birthday reminders"),
        FeatureAccess(name: "Share birthday countdowns"),
        FeatureAccess(name: "Limited party invite forms"),
        FeatureAccess(name: "1 birthday card template"),
        FeatureAccess(name: "1 birthday gift wrap"),
        FeatureAccess(name: "Limited birthday game access"),
      ],
    ),
    Subscription(
      name: 'Basic',
      price: 4,
      description: 'All celebrated basic features',
      featureAccess: [
        FeatureAccess(name: "All that's in free plan with no ads"),
        FeatureAccess(name: "Auto remind upto 50 others of birthdays on a list"),
        FeatureAccess(name: "Email birthday reminders"),
        FeatureAccess(name: "Auto collect birthday details via link"),
        FeatureAccess(name: "SMS birthday reminders"),
        FeatureAccess(name: "Whatsapp  birthday reminders"),

      ],
    ),
    Subscription(
      name: 'Standard',
      price: 12,
      description: "All that's in basic plan + more",
      featureAccess: [

        FeatureAccess(name: "Whatsapp group birthday reminders"),
        FeatureAccess(name: "Auto remind upto 150 others of birthdays on a list"),
      ],
    )
  ];
}
