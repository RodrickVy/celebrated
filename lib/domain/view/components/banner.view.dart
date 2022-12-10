import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/model/banner.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerView extends AdaptiveUI {
  final AppBanner banner;

  const BannerView(this.banner, {super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        if (FeedbackService.appNotification.value == null) {
          return const SizedBox();
        }

        return Container(
          decoration: AppTheme.boxDecoration.copyWith(
            color: banner.color
          ),
          clipBehavior: Clip.hardEdge,
          child: MaterialBanner(
            padding: const EdgeInsets.all(20),
            elevation: 0,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Heading(
                    banner.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (banner.image != null) Image.asset(banner.image!),
                if (banner.description != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(banner.description!),
                  )
              ],
            ),
            backgroundColor: banner.color,
            actions: <Widget>[
              ...banner.actions.map((e) {
                if (e.icon != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppButtonIcon(
                      icon: Icon(e.icon!),
                        label: e.name,
                        onPressed: () {
                          e.action();
                        }),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(
                      label: e.name,
                      onPressed: () {
                        e.action();
                      }),
                );
              })
            ],
          ),
        );

        // return Container(
        //   margin: const EdgeInsets.all(4),
        //   decoration: AppTheme.boxDecoration.copyWith(
        //     color: AppTheme.themeData.colorScheme.primary.withAlpha(380),
        //   ),
        //   padding: const EdgeInsets.all(8),
        //   child:Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         alignment: Alignment.center,
        //         padding: const EdgeInsets.all(8.0),
        //         child:  Heading(
        //           banner.title,
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //       if(banner.image != null)
        //        Image.asset(banner.image!),
        //
        //       Wrap(children: [
        //         ...banner.actions.map((e) {
        //           return Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: AppButton(
        //                 label: e.name,
        //                 onPressed: () {
        //                   e.action();
        //                 }),
        //           );
        //         })
        //       ],)
        //     ],
        //   )
        // );
      },
    );
  }
}
