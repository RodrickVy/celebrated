import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/app.page.view.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/list.extension.dart';
import 'package:flutter/material.dart';
class NotFoundView extends AppPageView {
  const NotFoundView({Key? key}) : super(key: key);

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
              ...NavService.instance.items.map2((item, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(

                      isTextButton: true,
                      label: item.name,
                      onPressed: () async {
                       navService.to(item.route);
                      }),
                );
              })
            ],
          )),
    );
  }
}
