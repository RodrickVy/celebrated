import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/home/controller/home.controller.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/dev.progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportController extends GetxController {
  static const DevProgress devProgress = DevProgress(
      title: "Celebrated 0.0.1",
      image: "assets/intro/plan.png",
      description:
          "This is the first early version of the app, with the least features, and is currently under testing & development.",
      categories: HomeController.features);

  static const String suggestFeatureFormUrl = "https://forms.gle/tsgYojBPk85PZrY58";
  static const String privacyPolicySiteUrl = "https://termify.io/privacy-policy/1656030243";

  static void suggestFeature() async {
    if (!await launchUrl(Uri.parse(suggestFeatureFormUrl))) {
      FeedbackService.announce(
          notification: AppNotification(
              title: "Oops! Looks like we can't open this url, copy  this link instead",
              appWide: true,
              child: AppButton(
                  key: UniqueKey(),
                  child: const Text(suggestFeatureFormUrl),
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: suggestFeatureFormUrl)).then((value) {
                      FeedbackService.successAlertSnack("Link Copied!");
                    });
                  })));
    }
  }

  static goPrivacyPolicySite() async {
    if (!await launchUrl(Uri.parse(privacyPolicySiteUrl))) {
      FeedbackService.announce(
          notification: AppNotification(
              title: "Oops! Looks like we can't open this url, copy  this link instead",
              appWide: true,
              child: AppButton(
                  key: UniqueKey(),
                  child: const Text(privacyPolicySiteUrl),
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: privacyPolicySiteUrl)).then((value) {
                      FeedbackService.successAlertSnack("Link Copied!");
                    });
                  })));
    }
  }
}
