import 'package:celebrated/home/model/feature.category.dart';
import 'package:celebrated/home/model/feature.dart';
import 'package:celebrated/home/model/feature.progress.dart';
import 'package:celebrated/home/model/target.group.dart';
import 'package:celebrated/home/model/value.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static const List<FeatureCategory> features = [
    FeatureCategory(
      name: "Platforms",
      description: "Planning to launch on web,IOS, Android and Linux",
      features: [
        AppFeature(
          name: '',
          icon: Icons.checklist_rtl,
          description: "App available on web",
          progress: TaskProgress.done,
        ),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Launch on google play-store",
            progress: TaskProgress.doing),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Launch on IOS app store",
            progress: TaskProgress.backlogged),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Launch on Linux as a snapcraft and flatpack",
            progress: TaskProgress.backlogged),
      ],
    ),
    FeatureCategory(
      name: "Reminder Features",
      description: "features that make remembering and tracking your loved one's birthdays easier.",
      features: [
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Group related birthdays into lists",
            progress: TaskProgress.done),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Invite others to add their birthday to your list",
            progress: TaskProgress.done),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Share a reminder link to others, to subscribe to the list of birthdays notifications",
            progress: TaskProgress.doing),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Create a birthday from contacts lists",
            progress: TaskProgress.backlogged),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Can import birthdays from Google calendar ",
            progress: TaskProgress.backlogged),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "List notifications settings",
            progress: TaskProgress.backlogged),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Sync list to google calendar ",
            progress: TaskProgress.backlogged),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Notifications Settings  ",
            progress: TaskProgress.backlogged),
      ],
    ),
    FeatureCategory(
      name: "Plan",
      description: "Plan birthdays stress-free to focus on what really matters!",
      features: [
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Birthday guests invite links  ",
            progress: TaskProgress.backlogged),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Create a birthday group cards ",
            progress: TaskProgress.backlogged),
        AppFeature(
            name: '',
            icon: Icons.checklist_rtl,
            description: "Create and share virtual gifts ",
            progress: TaskProgress.backlogged),
      ],
    ),
    FeatureCategory(
      name: "Celebrate",
      description: "Plan birthdays stress-free to focus on what really matters!",
      features: [
        AppFeature(
            name: '', icon: Icons.checklist_rtl, description: "Virtual Candles", progress: TaskProgress.backlogged),
      ],
    )
  ];

  static const List<AppFeature> mainFeatures = [

    AppFeature(
        name: "Never forget birthdays",
        icon: Icons.notifications,
        description: "Categorize birthdays in lists. Get SMS, Email and Whatsapp birthday reminders, and let others subscribe to birthday lists, to also get  reminders.",
        progress: TaskProgress.done),
    AppFeature(
        name: "Collect birthday information with ease",
        icon: Icons.add_link,
        description: "Collect birthday info via a sharable form, import from ccv file or contacts.",
        progress: TaskProgress.done),
    AppFeature(
        name: "Gift with confidence",
        icon: Icons.card_giftcard,
        description: "Know everyone's birthdays wishlists & create and share interactive virtual gifts of online products from amazon, ebay + more coming. ",
        progress: TaskProgress.done),
    AppFeature(
        name: "Unlimited birthday cards",
        icon: Icons.email_sharp,
        description: "Choose from templates, to create a unique birthday cards that others can sign with notes,images,video etc.",
        progress: TaskProgress.done),
    AppFeature(
        name: "Connect more with games",
        icon: Icons.gamepad,
        description: "Group games designed for birthday parties ranging from fun to deep and meaningful.",
        progress: TaskProgress.done),
    AppFeature(
        name: "Stress-free birthday planning ",
        icon: Icons.next_plan,
        description: "Forms/invite links to reach to party invites , allowing you to pull off big birthday parties with no stress,",
        progress: TaskProgress.done),


    AppFeature(
        name: "Custom branding",
        icon: Icons.branding_watermark,
        description: "Custom organization branding on birthday cards,invite pages, party forms,gifts etc.",
        progress: TaskProgress.done),
    AppFeature(
        name: "all managed from one account",
        icon: Icons.account_circle,
        description: "no need for any confusing accounts for member, all is managed by one account",
        progress: TaskProgress.done),
  ];
  static const String homeBanner = "assets/logos/banner.png";
  static const List<TargetGroup> targets = [
    // TargetGroup(name: 'individuals', color: Colors.lightGreen, description: '', painPoints: [], icon: Icons.checklist_rtl),
    TargetGroup(name: 'families', color: Colors.green, description: '', painPoints: [], icon: Icons.checklist_rtl),
    TargetGroup(name: 'schools', color: Colors.orange, description: '', painPoints: [], icon: Icons.checklist_rtl),
    TargetGroup(
        name: 'businesses', color: Colors.redAccent, description: '', painPoints: [], icon: Icons.checklist_rtl),
    TargetGroup(name: 'churches', color: Colors.blue, description: '', painPoints: [], icon: Icons.checklist_rtl),
    // TargetGroup(name: 'organizations', color: Colors.purple, description: '', painPoints: [], icon:Icons.checklist_rtl)
  ];

  static const String googlePlayStoreCTA = 'Take birthday celebration to the next level, with more meaning connection fun.';
  static const String playStoreUrl = "https://play.google.com/store/apps/details?id=com.rodrickvy.celebrated";
  static const String playStoreBtnImage = "assets/logos/play_button.png";

  static const List<CoreValue> values = [
    CoreValue(
        name: "Breaking Barriers",
        color: Colors.pinkAccent,
        image: "assets/intro/broken_barriers.png",
        description: "Celebrated is a great way for schools, churches and any organizations to break barriers."),
    CoreValue(
          name: "Expression",
        color: Colors.yellowAccent,
        image: "assets/intro/thank_you.png",
        description:
            "We believe love, care and appreciation that find no authentic expression is useless, we help you express it when it matters."),
    CoreValue(
        name: "Growing connection",
        color: Colors.redAccent,
        image: "assets/intro/party_many.png",
        description:
            "We help organizations connect more, not as employees,students or members but humans celebrating each other."),
  ];
}
