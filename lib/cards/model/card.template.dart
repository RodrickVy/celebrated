import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';
import 'package:flutter/cupertino.dart';

class CardTemplate {
  final String image;
  final String name;
  final List<String> keywords;
  final SubscriptionPlan availableIn;
  final String id;

  CardTemplate(
      {required this.image,
      required this.id,
      required this.name,
      required this.keywords,
      this.availableIn = SubscriptionPlan.pro});

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'keywords': keywords,
      'id': id,
      'availableIn': availableIn,
    };
  }

  bool canUseInUserPlan(SubscriptionPlan userPlan) {
    int indexOfTemplatePlan = SubscriptionPlan.values.indexOf(availableIn);
    int indexOfUserPlan = SubscriptionPlan.values.indexOf(userPlan);

    return indexOfTemplatePlan <= indexOfUserPlan;
  }

  factory CardTemplate.fromMap(Map<String, dynamic> map) {
    return CardTemplate(
      image: map['image'],
      name: map['name'],
      keywords: List.from(map['keywords']),
      availableIn: SubscriptionPlan.values.byName(map['availableIn']),
      id: map['id'],
    );
  }

  Widget build(BirthdayCard card) {
    return Column(
      children: [],
    );
  }
}

class GifCardTemplate extends CardTemplate {
  final String topGift;
  final String bottomGif;
  final String backGift;
  final String id;

  GifCardTemplate({
    required this.topGift,
    required this.bottomGif,
    required this.backGift,
    required this.id,
    required final String image,
    required final String name,
    required final List<String> keywords,
    required final SubscriptionPlan availableIn,
  }) : super(name: name, image: image, keywords: keywords, availableIn: availableIn, id:id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'id': id,
      'keywords': keywords,
      'availableIn': availableIn.name,
      'topGift': topGift,
      'bottomGif': bottomGif,
      'backGift': backGift
    };
  }

  @override
  bool canUseInUserPlan(SubscriptionPlan userPlan) {
    int indexOfTemplatePlan = SubscriptionPlan.values.indexOf(availableIn);
    int indexOfUserPlan = SubscriptionPlan.values.indexOf(userPlan);

    return indexOfTemplatePlan <= indexOfUserPlan;
  }

  factory GifCardTemplate.fromMap(Map<String, dynamic> map) {
    return GifCardTemplate(
      image: map['image'],
      name: map['name'],
      id: map['id'],
      keywords: List.from(map['keywords']),
      availableIn: SubscriptionPlan.values.byName(map['availableIn']),
      topGift: map['topGift'],
      bottomGif: map['bottomGif'],
      backGift: map['backGift'],
    );
  }

  @override
  Widget build(BirthdayCard card) {
    return Column(
      children: [],
    );
  }
}
