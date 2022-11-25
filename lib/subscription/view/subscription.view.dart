import 'package:celebrated/subscription/controller/subscription.service.dart';
import 'package:celebrated/subscription/models/subscription.dart';
import 'package:flutter/cupertino.dart';
import 'package:pricing_cards/pricing_cards.dart';

class SubscriptionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PricingCards(
      pricingCards: [
        ...SubscriptionService.subscriptions.map((Subscription subscription) {
          return PricingCard(
            title: 'Monthly',
            price: "\$${subscription.price}",
            subPriceText: '/mo',
            billedText: subscription.name,
            onPress: () {
              // make your business
            },
          );
        })
      ],
    );
  }
}
