import 'package:bremind/app.swatch.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final RxBool value = false.obs;

class AppTopBar extends PreferredSize {
  const AppTopBar({Key? key})
      : super(
          key: key,
          preferredSize: const Size.fromHeight(65),
          child: const SizedBox(),
        );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GetPlatform.isMobile ? null : const SizedBox(),
      leadingWidth: !GetPlatform.isMobile ? 0 : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            key: UniqueKey(),
            onPressed: () {
              runOnMVP(context);
            },
            style: ElevatedButton.styleFrom(
              primary: AppSwatch.primaryAccent,
            ),
            child: Text("MVP Alpha v.0.0"),
          ),
        )
      ],
      title: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "Celebrated",
          style: Adaptive(context)
              .textTheme
              .headline5
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  static PreferredSizeWidget buildWithBottom(
      BuildContext context, Widget bottom) {
    return AppBar(
      leading: GetPlatform.isMobile ? null : const SizedBox(),
      leadingWidth: !GetPlatform.isMobile ? 0 : null,
      backgroundColor: Colors.transparent,
      bottom: PreferredSize(child
          : bottom,      preferredSize: Size.fromHeight(50),),

      toolbarHeight: 0,
      elevation: !GetPlatform.isMobile ? 0 : 0.4,

      // title: Row(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: [
      //     const Padding(
      //       padding: EdgeInsets.only(bottom: 12.0),
      //       child: Text("NavController.instance.to"),
      //     ),
      //     const Spacer(),
      //     ElevatedButton(
      //       key: UniqueKey(),
      //       onPressed: () {
      //         runOnMVP(context);
      //       },
      //       child: Text("MVP Alpha v.0.0"),
      //     )
      //   ],
      // ),
    );
  }

  runOnMVP(BuildContext context) {
    NavController.instance.to(AppRoutes.support);
  }
}
