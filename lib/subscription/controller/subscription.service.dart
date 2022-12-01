import 'package:celebrated/subscription/models/feature.access.dart';
import 'package:celebrated/subscription/models/subscription.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';

class SubscriptionService {

     List<Subscription> subscriptions = const [
    Subscription(
      name: 'Test',
      price: 0,
      id: SubscriptionPlan.test,
      description: 'Early access tester',
      featureAccess: [
        FeatureAccess(name: "win 6 months of free access after launch"),
        FeatureAccess(name: "access to  & current current features"),
      ],
    ),
    Subscription(
      name: 'Free',
      price: 0,
      id: SubscriptionPlan.free,
      description: 'Free forever/with ads',
      featureAccess: [
        FeatureAccess(name: "Create and share birthday wishlist"),
        FeatureAccess(name: "Organize birthdays in lists"),
        FeatureAccess(name: "Phone notification birthday reminders"),
        FeatureAccess(name: "Email  birthday reminders"),
        FeatureAccess(name: "Share birthday countdowns"),
        FeatureAccess(name: "Limited party invite forms"),
        FeatureAccess(name: "1 birthday card template"),
        FeatureAccess(name: "1 birthday gift wrap"),
        FeatureAccess(name: "Limited birthday game access"),
      ],
    ),
    Subscription(
      name: 'Basic',
      price: 6,
      id: SubscriptionPlan.basic,
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
      name: 'Pro',
      price: 12,
      id: SubscriptionPlan.pro,
      description: "All that's in basic plan + more",
      featureAccess: [
        FeatureAccess(name: "Custom organization branding on birthday cards,invite pages, party forms,gifts etc."),
        FeatureAccess(name: "Add videos,images,files on birthday cards"),
        FeatureAccess(name: "Integration with spreadsheet"),
        FeatureAccess(name: "Integration with teams"),
      ],
    )
  ];
}

SubscriptionService subscriptionService = SubscriptionService();