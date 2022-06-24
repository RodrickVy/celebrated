import 'package:bremind/app.swatch.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.page.view.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:bremind/util/list.extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class NotFoundView extends AppPageView<AuthController> {
  NotFoundView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      width: adapter.width,
      height: adapter.height,
      color: Colors.white,
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      child: Container(
          width: adapter.adapt(
              phone: adapter.width, tablet: adapter.width, desktop: 800),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(20),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/intro/cake.png",
                width: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Oops, Looks like the page you looking for isn't here, were were you headed?",
                  style: adapter.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              ...NavController.instance.items.map2((item, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(
                      key: UniqueKey(),
                      // isTextButton: true,
                      label: item.name,
                      onPressed: () async {
                        NavController.instance.to(item.route);
                      }),
                );
              })
            ],
          )),
    );
  }
}
