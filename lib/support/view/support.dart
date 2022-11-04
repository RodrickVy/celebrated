
import 'package:celebrated/appIntro/controller/intro.controller.dart';
import 'package:celebrated/document/controller/document.view.controller.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/domain/view/app.page.view.dart';
import 'package:celebrated/support/controller/support.controller.dart';
import 'package:celebrated/home/model/feature.dart';
import 'package:celebrated/home/model/feature.progress.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
class SupportView extends AppPageView {
  SupportView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Container(
      width: adapter.width,
      height: adapter.height,
      color: Colors.white,
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      child: Container(
          width: adapter.adapt(phone: adapter.width, tablet: adapter.width, desktop: 800),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  SupportController.devProgress.image,
                  width: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  SupportController.devProgress.title,
                  style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  SupportController.devProgress.description,
                  style: adapter.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),
                  textAlign: TextAlign.left,
                ),
              ),



              ...SupportController.devProgress.categories.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ExpansionTile(
                    title: Text(
                      e.name,
                      style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.w300),
                    ),
                    initiallyExpanded: false,
                    subtitle: Text(
                      e.description,
                      style: adapter.textTheme.bodyMedium,
                    ),
                    children: [
                      ...e.features.map((AppFeature task) {
                        return ListTile(

                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          title: Text(
                            task.description,
                            style: adapter.textTheme.bodyMedium,
                          ),
                          trailing:  Icon(
                            taskProgressIcon(task.progress),
                            size: 25,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButton(
                    key: UniqueKey(),
                    isTextButton: true,
                    label: "Privacy Policy",
                    onPressed: ()  {

                      DocumentsController.goToDocument('privacy');
                    }),
              )

            ],
          )),
    );
  }



  IconData taskProgressIcon(TaskProgress progress) {
    switch (progress) {
      case TaskProgress.backlogged:
        return Icons.timelapse_sharp;
      case TaskProgress.doing:
        return Icons.timelapse_sharp;
      case TaskProgress.reviewing:
        return Icons.reviews;
      case TaskProgress.done:
        return Icons.check;
      case TaskProgress.frozen:
        return Icons.check;
    }
  }
}
