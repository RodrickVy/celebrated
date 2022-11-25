import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/appIntro/interface/intro.controller.interface.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/list.extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';

/// The app's intro view, with no dependency on the actual controller since this can change anytime.
class AppIntro<C extends IAppIntroController> extends AppStateView<C> {
  @override
  AppIntro({Key? key}) : super(key: key);

  @override
  Widget view({required ctx, required adapter}) {
    return Obx(
      () => Container(
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
                padding:  const EdgeInsets.all(12),
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(controller.currentItemIndex == controller.splashItems.length-1)
                      SizedBox(height: 50,),
                    if(controller.currentItemIndex != controller.splashItems.length-1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          ...controller.splashItems.map2((e, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 2,
                                width: 12,
                                decoration: BoxDecoration(
                                    border: Border.fromBorderSide(AppTheme.shape.side),
                                    color: controller.currentItemIndex == index ? AppSwatch.primary.shade500 : Colors.black38,
                                    borderRadius: AppTheme.shape.borderRadius),

                              ),
                            );
                          }),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: AppButton(
                              onPressed: () {
                                controller.skipIntro();
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
                        controller.currentItem.title,
                        style: adapter.textTheme.headline4?.copyWith(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ImageFade(
                        image: AssetImage(
                          controller.currentItem.image,
                        ),
                        width: Adaptive(ctx).adapt(phone: 230, tablet: 300, desktop: null),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        controller.currentItem.description,
                        style:Adaptive(ctx).adapt(phone: adapter.textTheme.bodyMedium, tablet: adapter.textTheme.headlineSmall, desktop: adapter.textTheme.headlineSmall) ,
                      ),
                    ),
                    Wrap(
                      children: [
                        if(controller.currentItemIndex == controller.splashItems.length-1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton(
                              onPressed: () {
                                controller.nextScreen();
                              },
                              key: UniqueKey(),
                              buttonHeight: 60,
                              label: "Get Started",
                            ),
                          ),
                        if (controller.currentItemIndex > 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton(
                              onPressed: () {
                                controller.previousScreen();
                              },
                              key: UniqueKey(),
                              isTextButton: true,
                              buttonHeight: 60,
                              label: "Back",
                            ),
                          ),
                        if(controller.currentItemIndex != controller.splashItems.length-1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton(
                              onPressed: () {
                                controller.nextScreen();
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
      ),
    );
  }
}
