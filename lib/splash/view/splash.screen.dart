import 'package:bremind/app.swatch.dart';
import 'package:bremind/domain/page.view.dart';
import 'package:bremind/splash/interface/splash.controller.interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';

class AppIntro<C extends ISplashController> extends AppView<C> {
  @override
  AppIntro({Key? key}) : super(key: key);

  @override
  Widget view({required ctx, required adapter}) {
    return Obx(
      () => Container(
        width:  adapter.width,
        height: adapter.height,
        color: AppSwatch.primary.shade500,
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: adapter.adapt(phone: 300, tablet: 500, desktop: 500),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(20),
          decoration:  BoxDecoration(
              color: AppSwatch.primary.shade500,
              image: const DecorationImage(
            image: AssetImage("assets/intro/bg.png"),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          )),

          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: OutlinedButton(
                          onPressed: () {
                            controller.skipSplash();
                          },
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.transparent)),
                          child: const Text(
                            "Skip",
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  controller.currentItem.image,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.currentItem.title,
                  style: adapter.textTheme.headline5,
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.currentItem.description,
                  style: adapter.textTheme.bodyText2,
                ),
              ),
              const Spacer(),
              Expanded(
                child: Row(
                  children: [
                    if (controller.currentItemIndex > 0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              controller.previousScreen();
                            },
                            style: OutlinedButton.styleFrom(
                                primary: Colors.black,
                                side:
                                    const BorderSide(color: Colors.transparent)),
                            child: const Text(
                              "back",
                            )),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            controller.nextScreen();
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5E9C6),
                              primary: Colors.black,
                              side: const BorderSide(color: Colors.transparent)),
                          child: const Text(
                            "Next",
                          )),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
