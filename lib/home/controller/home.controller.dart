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
        name: "Group related birthdays into lists",
        icon: Icons.list_alt_outlined,
        description: "group birthdays into your wanted lists eg. department,teams or custom",
        progress: TaskProgress.done),
    AppFeature(
        name: "Send out birthday collection link",
        icon: Icons.add_link,
        description: "Easily collect birthdays of from everyone with a link",
        progress: TaskProgress.done),
    AppFeature(
        name: "Members can subscribe to lists to get notified",
        icon: Icons.notifications,
        description:
            "any member of organization can subscribe to a birthday list notification, to get a phone text notification when its someones birthday.",
        progress: TaskProgress.done),
    AppFeature(
        name: "Birthday note card that all can sign",
        icon: Icons.edit,
        description: "Birthday note card that all members can sign",
        progress: TaskProgress.done),
    AppFeature(
        name: "all managed from one account",
        icon: Icons.account_circle,
        description: "no need for any confusing accounts for member, all is managed by one account",
        progress: TaskProgress.done),
  ];
  static const String homeBanner = "assets/logos/banner.png";
  static const List<TargetGroup> targets = [
    TargetGroup(name: 'individuals', color: Colors.lightGreen, description: '', painPoints: [], icon: Icons.checklist_rtl),
    TargetGroup(name: 'families', color: Colors.green, description: '', painPoints: [], icon: Icons.checklist_rtl),
    TargetGroup(name: 'schools', color: Colors.orange, description: '', painPoints: [], icon: Icons.checklist_rtl),
    TargetGroup(
        name: 'businesses', color: Colors.redAccent, description: '', painPoints: [], icon: Icons.checklist_rtl),
    TargetGroup(name: 'churches', color: Colors.blue, description: '', painPoints: [], icon: Icons.checklist_rtl),
    // TargetGroup(name: 'organizations', color: Colors.purple, description: '', painPoints: [], icon:Icons.checklist_rtl)
  ];

  static const String googlePlayStoreCTA = 'Keep track & remember birthdays of those that matter';
  static const String playStoreUrl = "https://play.google.com/apps/test/com.rudo.bereminder/1";
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
