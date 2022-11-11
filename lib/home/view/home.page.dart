import 'package:celebrated/domain/view/app.page.view.dart';
import 'package:celebrated/home/controller/home.controller.dart';
import 'package:celebrated/home/model/target.group.dart';
import 'package:celebrated/home/model/value.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// the homepage for birthdays, has tips, current birthdays etc.
class HomePage extends AppPageView{
  const HomePage({Key? key}) : super(key: key);

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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Image.asset(
              HomeController.homeBanner,
              width: Get.width,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    text: "For  ",
                    style: adapter.textTheme.headlineSmall,
                    children: [
                      ...HomeController.targets
                          .map(
                            (TargetGroup group) => TextSpan(
                              text: '${group.name} , ',
                              style: adapter.textTheme.headlineSmall
                                  ?.copyWith( color: group.color),
                            ),
                          )
                          .toList(),
                       TextSpan(
                        text: " or any ", style: adapter.textTheme.headlineSmall
                      ),
                      TextSpan(
                        text: 'organizations',
                        style: adapter.textTheme.headlineSmall?.copyWith( color: Colors.blue),
                      ),
                      TextSpan(
                        text: " that want to express appreciation when it matters.",
                        style: adapter.textTheme.headlineSmall?.copyWith( color: Colors.black),
                      ),
                    ]),
              ),
            ),
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                HomeController.googlePlayStoreCTA,
                style: adapter.textTheme.headline6,
                textAlign: TextAlign.left,
              ),
            ),
            GestureDetector(
              onTap: () async {
                await launchUrl(Uri.parse(HomeController.playStoreUrl));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  HomeController.playStoreBtnImage,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Here is what you get for free",
                      style: adapter.textTheme.headlineSmall,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ...HomeController.mainFeatures.map((e) {
                    return ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      title: Text(
                        e.name,
                        style: adapter.textTheme.bodyLarge,
                      ),
                      leading:  Icon(
                      e.icon,
                        size: 25,
                      ),
                      subtitle: Text(e.description,  style: adapter.textTheme.bodyMedium,),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 50,),
            Text(
              "Transforming Organizations!",
              style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25,),
            Wrap(
              alignment: WrapAlignment.center,
              children: [

                ...HomeController.values.map((CoreValue value){
                  return SizedBox(
                    width: 200,
                    child: Card(
                      elevation: 1,

                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(   color: value.color)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 25,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value.name,
                              style: adapter.textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(value.description,textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    ),
                  );
                }),
                // ListTile(
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                //   leading: const Icon(
                //     Icons.check_box_outline_blank_outlined,
                //     size: 25,
                //   ),
                //   tileColor: Colors.green,
                //   title: Text(
                //     "Breaking Barriers",
                //     style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: const Text(
                //       "Celebrated is a great way for schools, churches and any organizations to break barriers"),
                // ),
                // ListTile(
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                //   leading: const Icon(
                //     Icons.check_box_outline_blank_outlined,
                //     size: 25,
                //   ),
                //   tileColor: Colors.red,
                //   title: Text(
                //     "Expression",
                //     style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: const Text(
                //       "We believe love, care and appreciation that find no authentic expression is useless, we help you express it when it matters."),
                // ),
                // ListTile(
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                //   tileColor: Colors.blue,
                //   title: Text(
                //     "Growing connection",
                //     style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: const Text(
                //       "We help organizations connect more, not as employees,students or members but humans celebrating each other."),
                //   leading: const Icon(
                //     Icons.check_box_outline_blank_outlined,
                //     size: 25,
                //   ),
                // ),
              ],
            )

/*
*
*
*  - the value of time is measured by the memories around it, we make them count.
 - .
  -
Novelty - we are all about new and different.
Authentic - we do it, say it and sell it like it is
Fun -  we find fun and joy in what we do.
* */
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     controller.homeItem.title,
            //     style: adapter.textTheme.headline3,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     controller.homeItem.description,
            //     style: adapter.textTheme.bodyLarge,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Get started, create your first Account!",
            //     style: adapter.textTheme.bodyLarge,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}


