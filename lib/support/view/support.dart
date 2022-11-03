import 'package:bremind/app.swatch.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.page.view.dart';
import 'package:bremind/support/controller/dev.progress.controller.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/support/models/dev.progress/dev.task.dart';
import 'package:bremind/support/models/dev.progress/task.progress.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportView extends AppPageView<DevProgressController> {
  SupportView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      width: adapter.width,
      height: adapter.height,
      color: Colors.white,
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      child: Container(
          width: adapter.adapt(phone: adapter.width, tablet: adapter.width, desktop: 800),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(20),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  controller.devProgress.title,
                  style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
              Card(
                elevation: 0,
                // color: AppSwatch.primary.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                margin: EdgeInsets.all(12),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Image.asset(
                        controller.devProgress.image,
                        width: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          controller.devProgress.description,
                          style: adapter.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //    ,
              //     style: adapter.textTheme.headline6
              //         ?.copyWith(fontWeight: FontWeight.bold),
              //     textAlign: TextAlign.center,
              //   ),
              // ),


              ...controller.devProgress.categories.map((e) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(
                      e.name,
                      style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.w300),
                    ),
                    initiallyExpanded: false,
                    subtitle: Text(
                      e.description,
                      style: adapter.textTheme.bodySmall,
                    ),
                    children: [
                      ...e.devTasks.map((DevTask task) {
                        return ListTile(

                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          title: Text(
                            task.description,
                            style: adapter.textTheme.bodySmall,
                          ),
                          trailing:  Icon(
                            taskProgressIcon(task.progress),
                            size: 25,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }).toList(),
              // ExpansionTile(
              //   title: Text(
              //     "App Features",
              //     style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.w500),
              //   ),
              //   initiallyExpanded: true,
              //   // subtitle: Text(
              //   //   "",
              //   //   style: adapter.textTheme.bodyText1,
              //   // ),
              //   children: [
              //     ListTile(
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              //       title: Text(
              //         "Group related birthdays into lists",
              //         style: adapter.textTheme.subtitle1,
              //       ),
              //       trailing: const Icon(
              //         Icons.check,
              //         size: 25,
              //       ),
              //     ),
              //     ListTile(
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              //       title: Text(
              //         "Send out birthday collection link",
              //         style: adapter.textTheme.subtitle1,
              //       ),
              //       trailing: const Icon(
              //         Icons.check,
              //         size: 25,
              //       ),
              //     ),
              //     ListTile(
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              //       title: Text(
              //         "Easy link members subscription to lists to get notified",
              //         style: adapter.textTheme.subtitle1,
              //       ),
              //       trailing: const Icon(
              //         Icons.timelapse_sharp,
              //         size: 25,
              //       ),
              //     ),
              //     ListTile(
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              //       title: Text(
              //         "Birthday card that all can sign",
              //         style: adapter.textTheme.subtitle1,
              //       ),
              //       trailing: const Icon(
              //         Icons.timelapse_sharp,
              //         size: 25,
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: AppButton(
              //           key: UniqueKey(),
              //           label: "Suggest A Feature",
              //           onPressed: () async {
              //             await suggestFeature();
              //           }),
              //     )
              //   ],
              // ),
              // ExpansionTile(
              //   title: Text(
              //     "Planning Features",
              //     style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
              //
              //   ),
              //   subtitle: Text(
              //     "Features that help you celebrate birthdays",
              //     style: adapter.textTheme.bodyText1,
              //   ),
              //   children: [
              //     ListTile(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(0)),
              //       title: Text(
              //         "create a guest list, that you can auto-send messages , update etc to.",
              //         style: adapter.textTheme.subtitle1,
              //       ),
              //       trailing: const Icon(
              //         Icons.timelapse_sharp,
              //         size: 25,
              //       ),
              //     ),
              //     ListTile(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(0)),
              //       title: Text(
              //         "create a birthday a personal card",
              //         style: adapter.textTheme.subtitle1,
              //       ),
              //       trailing: const Icon(
              //         Icons.timelapse_sharp,
              //         size: 25,
              //       ),
              //     ),
              //     ListTile(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(0)),
              //       title: Text(
              //         "create virtual gifts from  online products and wrap them virtually",
              //         style: adapter.textTheme.subtitle1,
              //       ),
              //       trailing: const Icon(
              //         Icons.timelapse_sharp,
              //         size: 25,
              //       ),
              //     ),
              //     ListTile(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(0)),
              //       title: Text(
              //         "more coming....",
              //         style: adapter.textTheme.subtitle1,
              //       ),
              //       leading: const Icon(
              //         Icons.add,
              //         size: 25,
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: AppButton(
              //           key: UniqueKey(),
              //           label: "Suggest A Feature",
              //           onPressed: () async {
              //             await suggestFeature();
              //           }),
              //     )
              //   ],
              // ),
              // ExpansionTile(
              //   title: Text(
              //     "Celebrating Features",
              //     style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
              //   ),
              //   subtitle: Text(
              //     "Features that help you plan birthday events",
              //     style: adapter.textTheme.bodyText1,
              //   ),
              //   children: [
              //     ListTile(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(0)),
              //       title: Text(
              //         "more coming soon....",
              //         style: adapter.textTheme.subtitle1,
              //       ),
              //       leading: const Icon(
              //         Icons.add,
              //         size: 25,
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: AppButton(
              //           key: UniqueKey(),
              //           label: "Suggest A Feature",
              //           onPressed: () async {
              //             await suggestFeature();
              //           }),
              //     )
              //   ],
              // ),

              Padding(
                padding: const EdgeInsets.all(30.0),
                child: AppButton(
                    key: UniqueKey(),
                    isTextButton: true,
                    label: "Privacy Policy",
                    onPressed: () async {
                      if (!await launchUrl(Uri.parse("https://termify.io/privacy-policy/1656030243"))) {
                        FeedbackService.announce(
                            notification: AppNotification(
                                title: "Oops! Looks like we can't open this url, copy  this link instead",
                                appWide: true,
                                child: AppButton(
                                    key: UniqueKey(),
                                    child: Text("https://termify.io/privacy-policy/1656030243"),
                                    onPressed: () {
                                      Clipboard.setData(
                                              const ClipboardData(text: "https://termify.io/privacy-policy/1656030243"))
                                          .then((value) {
                                        FeedbackService.successAlertSnack("Link Copied!");
                                      });
                                    })));
                      }
                    }),
              )
            ],
          )),
    );
  }

  suggestFeature() async {
    if (!await launchUrl(Uri.parse("https://forms.gle/tsgYojBPk85PZrY58"))) {
      FeedbackService.announce(
          notification: AppNotification(
              title: "Oops! Looks like we can't open this url, copy  this link instead",
              appWide: true,
              child: AppButton(
                  key: UniqueKey(),
                  child: Text("https://termify.io/privacy-policy/1656030243"),
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: "https://termify.io/privacy-policy/1656030243"))
                        .then((value) {
                      FeedbackService.successAlertSnack("Link Copied!");
                    });
                  })));
    }
  }

  IconData taskProgressIcon(TaskProgress progress) {
    switch (progress) {
      case TaskProgress.backlogged:
        return Icons.timelapse_sharp;
      case TaskProgress.doing:
        return Icons.timelapse_sharp;
      case TaskProgress.reviewing:
        return Icons.reviews;
      case TaskProgress.done:
        return Icons.check;
      case TaskProgress.frozen:
        return Icons.check;
    }
  }
}
