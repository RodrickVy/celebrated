import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/model/banner.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/banner.view.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';

class TaskFailed extends AdaptiveUI {
  final String? title;
  final String? buttonLabel;
  final Function()? buttonAction;
  final String? image;

  const TaskFailed( {this.image, this.buttonLabel, this.buttonAction, this.title, super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child:  Heading(
            title ?? "Oops! Something unexpected went wrong. Please try again",
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child:   Image.asset(image??'assets/intro/server_error.png',width: 200,),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppButton(
              label: buttonLabel??"Go Home",
              onPressed: () {
                if(buttonAction!= null){
                  buttonAction!();
                }else{
                  navService.to(AppRoutes.home);
                }

              }),
        ),
        BannerView(AppBanner(
            color: AppSwatch.primary,
            title: "Make Belated Birthdays A Thing Of The Past!",
            actions: [
              ButtonAction(
                  name: "Get Started",
                  action: () {
                    navService.to(AppRoutes.authSignUp);
                  }),
              ButtonAction(
                  name: "More info",
                  action: () {
                    navService.to(AppRoutes.home);
                  })
            ],
          ))
      ],
    );
  }
}


class TaskSucceeded extends AdaptiveUI {
  final String? title;
  final String? buttonLabel;
  final Function()? action;
  final String? image;
  const TaskSucceeded({ this.image, this.buttonLabel, this.action, this.title, super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child:  Heading(
            title ?? "Success!",
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child:          Image.asset(image??'assets/intro/task_done.png',width: 200,),
        ),


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppButton(
              label: buttonLabel??"Continue",
              onPressed: () {
                if(action!= null){
                  action!();
                }else{
                  navService.to(AppRoutes.home);
                }

              }),
        ),
        BannerView(AppBanner(
            color: AppSwatch.primary,
            title: "Make Belated Birthdays A Thing Of The Past!",
            actions: [
              ButtonAction(
                  name: "Get Started",
                  action: () {
                    navService.to(AppRoutes.authSignUp);
                  }),
              ButtonAction(
                  name: "More info",
                  action: () {
                    navService.to(AppRoutes.home);
                  })
            ],
          ))
      ],
    );
  }
}