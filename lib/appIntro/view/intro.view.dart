import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/appIntro/controller/intro.controller.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/list.extension.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:video_player/video_player.dart';

/// The app's intro view, with no dependency on the actual controller since this can change anytime.
class AppIntro extends AdaptiveUI {


  @override
  const AppIntro({Key? key}) : super(key: key);

  @override
  Widget view({required ctx, required adapter}) {
    return Obx(
      () {
        if(introScreenController.videoPlaying.isTrue){
          return Container(
            width: adapter.width,
            height: adapter.height,
            color: Colors.white,
            child: ListView(
              children: [

                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: adapter.adapt(phone: adapter.width, tablet: 580, desktop: 500),
                        padding: const EdgeInsets.all(12),
                        margin: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  introScreenController.name,
                                  style: adapter.textTheme.headline4?.copyWith(fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  introScreenController.tagline,
                                  style:  adapter.textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              margin: const EdgeInsets.only(bottom: 40),
                              child: AppButton(
                                onPressed: () {
                                  introScreenController.videoPlaying(false);
                                  introScreenController.videoController.flickControlManager?.autoPause();
                                },
                                minWidth: 190,
                                key: UniqueKey(),
                                buttonHeight: 60,
                                label: "Get Started",
                              ),
                            ),
                            Container(
                             alignment: Alignment.center,
                                child: Container(
                                  width: adapter.adapt(phone:Get.width-60, tablet: 200, desktop: 300),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular( AppTheme.borderRadius2),
                                      border: Border.fromBorderSide(AppTheme.shape.side)
                                  ),

                                  clipBehavior: Clip.hardEdge,
                                  child: FlickVideoPlayer(flickManager: introScreenController.videoController),
                                ),
                              ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          );
        }
        return Container(
        width: adapter.width,
        height: adapter.height,
        color: Colors.white,
        padding: EdgeInsets.zero,
        alignment: Alignment.topCenter,
        child: ListView(
          children: [
            Center(
              child: Container(
                width: adapter.adapt(phone: adapter.width, tablet: 580, desktop: 500),
                padding: const EdgeInsets.all(12),
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (introScreenController.currentItemIndex == introScreenController.splashItems.length - 1)
                      const SizedBox(
                        height: 50,
                      ),
                    if (introScreenController.currentItemIndex != introScreenController.splashItems.length - 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ...introScreenController.splashItems.map2((e, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 2,
                                width: 12,
                                decoration: BoxDecoration(
                                    border: Border.fromBorderSide(AppTheme.shape.side),
                                    color: introScreenController.currentItemIndex == index
                                        ? AppSwatch.primary.shade500
                                        : Colors.black38,
                                    borderRadius: AppTheme.shape.borderRadius),
                              ),
                            );
                          }),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: AppButton(
                              onPressed: () {
                                introScreenController.skipIntro();
                              },
                              buttonHeight: 60,
                              minWidth: 100,
                              isTextButton: true,
                              label: "Skip",
                            ),
                          )
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        introScreenController.currentItem.title,
                        style: adapter.textTheme.headline4?.copyWith(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ImageFade(
                        image: AssetImage(
                          introScreenController.currentItem.image,
                        ),
                        width: Adaptive(ctx).adapt(phone: 230, tablet: 300, desktop: null),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        introScreenController.currentItem.description,
                        style: Adaptive(ctx).adapt(
                            phone: adapter.textTheme.bodyMedium,
                            tablet: adapter.textTheme.headlineSmall,
                            desktop: adapter.textTheme.headlineSmall),
                      ),
                    ),
                    Wrap(
                      children: [
                        if (introScreenController.currentItemIndex == introScreenController.splashItems.length - 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton(
                              onPressed: () {
                                introScreenController.nextScreen();
                              },
                              key: UniqueKey(),
                              buttonHeight: 60,
                              label: "Get Started",
                            ),
                          ),
                        if (introScreenController.currentItemIndex > 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton(
                              onPressed: () {
                                introScreenController.previousScreen();
                              },
                              key: UniqueKey(),
                              isTextButton: true,
                              buttonHeight: 60,
                              label: "Back",
                            ),
                          ),
                        if (introScreenController.currentItemIndex != introScreenController.splashItems.length - 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton(
                              onPressed: () {
                                introScreenController.nextScreen();
                              },
                              key: UniqueKey(),
                              buttonHeight: 60,
                              label: "Next",
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      },
    );
  }
}
