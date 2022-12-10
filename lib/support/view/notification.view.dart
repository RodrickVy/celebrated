import 'package:celebrated/app.theme.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// works with notification system and reacts to any incoming notifications in
/// [FeedbackService] that are not appWide,
/// when your notifications are nto appWide this view must be
/// placed in your UI if you want the notifications to sure.
class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// if notification is not an appWide announcement then only then does this show where it was placed.
      if (FeedbackService.appNotification.value != null &&
          FeedbackService.appNotification.value!.appWide == false) {
        return Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child:FeedbackService.appNotification.value!.icon??iconByType,
                ),
                Expanded(
                  flex: 3,
                  child: Container(

                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      FeedbackService.appNotification.value!.title,
                      style: Get.theme.textTheme.bodyText2,
                    ),
                  ),
                ),
                if(FeedbackService.appNotification.value!.canDismiss)
                  IconButton(
                      onPressed: () {
                        FeedbackService.clearErrorNotification();
                      },
                      icon: const Icon(Icons.clear)),
              ],
            ),
            Theme(
              data: AppTheme.themeData,
              child: FeedbackService.appNotification.value!.child ??
                  const Text(""),
            )
          ],
        );
      } else {
        return const SizedBox();
      }
    });
  }


  Widget get iconByType {
    switch (FeedbackService.appNotification.value!.type) {
      case NotificationType.error:
        return const Icon(
          Icons.error,
          color: Colors.red,
        );
      case NotificationType.success:
        return const Icon(
          Icons.check,
          color: Colors.green,
        );
      case NotificationType.warning:
        return const Icon(
          Icons.warning,
          color: Colors.orange,
        );
      case NotificationType.neutral:
        return const SizedBox(width: 0,);
    }
  }
}