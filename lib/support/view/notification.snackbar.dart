import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/models/notification.type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingNotificatonsView extends StatelessWidget {
  const FloatingNotificatonsView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (FeedbackController.appNotification.value != null && FeedbackController.appNotification.value!.appWide == true ) {

        return Container(
            width: Get.width - 12,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(),
            height: Get.height / 3,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(12),
            child: GetSnackBar(
              titleText: ListTile(
                leading: () {
                  switch (FeedbackController.appNotification.value!.type) {
                    case NotificationType.error:
                      return const Icon(
                        Icons.error,
                        color: Colors.white,
                      );
                    case NotificationType.success:
                      return const Icon(
                        Icons.check,
                        color: Colors.white,
                      );
                    case NotificationType.warning:
                      return const Icon(
                        Icons.warning,
                        color: Colors.black,
                      );
                  }
                }(),
                title: Text(
                  FeedbackController.appNotification.value!.title,
                  style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ),
              messageText:FeedbackController.appNotification.value!.child?? const Text(""),
              message:
                  "report error by clicking icon on left" /*error.value!.solutions*/,
              margin: const EdgeInsets.all(20),
              borderRadius: 20,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: bgColor,
              shouldIconPulse: true,
              isDismissible: true,
              animationDuration: const Duration(seconds: 900),
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
            );
      } else {
        return SizedBox();
      }
    });
  }

  Color get bgColor{
    switch (FeedbackController.appNotification.value!.type) {
      case NotificationType.error:
        return Colors.red.withAlpha(190);
      case NotificationType.success:
        return Colors.green.withAlpha(190);
      case NotificationType.warning:
        return Colors.orange.withAlpha(190);
    }


  }
}


class NotificatonsView extends StatelessWidget {
  const NotificatonsView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (FeedbackController.appNotification.value != null && FeedbackController.appNotification.value!.appWide == false) {
        Get.log("${FeedbackController.appNotification.value!.title} notification!");
        return ListTile(
          isThreeLine: false,
          dense: true,
          leading: () {
            switch (FeedbackController.appNotification.value!.type) {
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
            }
          }(),
          title: Text(
            FeedbackController.appNotification.value!.title,
            style: Get.theme.textTheme.bodyText2,
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Color get bgColor{
    switch (FeedbackController.appNotification.value!.type) {
      case NotificationType.error:
        return Colors.red.withAlpha(190);
      case NotificationType.success:
        return Colors.green.withAlpha(190);
      case NotificationType.warning:
        return Colors.orange.withAlpha(190);
    }
  }
}