import 'package:celebrated/app.theme.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// works with notification system and reacts to any incoming notifications in
/// [FeedbackService] that are  appWide,
/// This view is inserted as stack at the app level, and only needs you to call
/// [FeedbackService.announce(notification: notification)] to show
/// your error,warning or success message.
///
///
///
/// NOTE : if message and child are provided int he APPNotification child will be shown and message wont be
class NotificationSnackBar extends StatelessWidget {
  const NotificationSnackBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// listening to notifications and only displays those that are app wide
      if (FeedbackService.appNotification.value != null &&
          FeedbackService.appNotification.value!.appWide == true) {
        return Container(
          width: Adaptive(context).width,
          height: Adaptive(context).height,
          color: Colors.black12,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: Adaptive(context).height/5),
          child: Container(
              width: Adaptive(context).adapt(
                  phone: Adaptive(context).width - 20,
                  tablet: Adaptive(context).width - 40,
                  desktop: 400),

              clipBehavior: Clip.hardEdge,
              // height: Get.height / 3,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: AppTheme.shape.borderRadius,
                color: bgColor,
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisSize: MainAxisSize.min,
                children: [
                  if (FeedbackService
                      .appNotification.value!.canDismiss)
                    IconButton(
                        onPressed: () {
                          FeedbackService.clearErrorNotification();
                        },
                        icon: const Icon(Icons.clear)),
                  FeedbackService.appNotification.value!.icon??icon,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  Text(
                      FeedbackService.appNotification.value!.title,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FeedbackService.appNotification.value!.child ??
                        Text(FeedbackService.appNotification.value!.message),
                  )
                ],
              )

              // Material(
              //   color: Colors.transparent,
              //   child: Wrap(
              //     direction: Axis.horizontal,
              //     alignment: WrapAlignment.start,
              //     children: [
              //       Container(
              //         padding: EdgeInsets.all(5),
              //         child:      () {
              //           switch (FeedbackController.appNotification.value!.type) {
              //             case NotificationType.error:
              //               return const Icon(
              //                 Icons.error,
              //                 color: Colors.red,
              //                 size: 38,
              //               );
              //             case NotificationType.success:
              //               return const Icon(
              //                 Icons.check,
              //                 color: Colors.green,
              //                 size: 38,
              //               );
              //             case NotificationType.warning:
              //               return const Icon(
              //                 Icons.warning,
              //                 color: Colors.orange,
              //                 size: 38,
              //               );
              //           }
              //         }(),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(
              //           FeedbackController.appNotification.value!.title,
              //           style: GoogleFonts.poppins(color: Colors.black87,fontSize: 19,fontWeight: FontWeight.w300),
              //         ),
              //       ),
              //       if (FeedbackController.appNotification.value!.type ==
              //           NotificationType.error)
              //         SpinnerView(
              //           spinnerKey: AfroSpinKeys.bugSubmitForm,
              //           child: FormSubmitButton(
              //             key: UniqueKey(),
              //             elevation: 0,
              //             style: ElevatedButton.styleFrom(
              //               side: const BorderSide(color: Colors.transparent, width: 0),
              //               primary: Colors.green,
              //             ),
              //             child: Text(
              //               "Report",
              //               style: GoogleFonts.poppins(fontSize: 16),
              //             ),
              //             onPressed: () async {
              //               FeedbackController.spinnerUpdateState(
              //                   key: AfroSpinKeys.bugSubmitForm, isOn: true);
              //               await FeedbackController.reportBug(
              //                   FeedbackController.appNotification.value!);
              //               FeedbackController.spinnerUpdateState(
              //                   key: AfroSpinKeys.bugSubmitForm, isOn: false);
              //             },
              //           ),
              //         )
              //     ],
              //   ),
              // ),
              ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Color get bgColor {
    switch (FeedbackService.appNotification.value!.type) {
      case NotificationType.error:
        return const Color(0xFFFFA598);
      case NotificationType.success:
        return const Color(0xFFDDFFB4);
      case NotificationType.warning:
        return const Color(0xFFFFE6A5);
      case NotificationType.neutral:
        return Colors.white;
    }
  }

  Widget get icon {
    switch (FeedbackService.appNotification.value!.type) {
      case NotificationType.error:
        return const Icon(
          Icons.error,

        );
      case NotificationType.success:
        return const Icon(
          Icons.check,

        );
      case NotificationType.warning:
        return const Icon(
          Icons.warning,
          color: Colors.black,
        );
      case NotificationType.neutral:
        return const SizedBox(
          width: 0,
        );
    }
  }
}
