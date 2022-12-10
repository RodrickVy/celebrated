import 'package:celebrated/app.theme.dart';
import 'package:celebrated/appIntro/controller/intro.controller.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/app.page.view.dart';
import 'package:celebrated/home/controller/home.controller.dart';
import 'package:celebrated/home/model/target.group.dart';
import 'package:celebrated/home/model/value.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
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
        width: adapter.adaptScreens(small: adapter.width-10, big: 800),
        margin: EdgeInsets.zero,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                  
                  isTextButton: true,
                  label: "Give Us Feedback",
                  onPressed: () async {
                    if (await launchUrl(Uri.parse('https://523ay2iqdlf.typeform.com/to/LELPUugH'))) {}
                  }),
            ),
            Container(
              decoration: BoxDecoration(
                 border: Border.fromBorderSide( AppTheme.shape.side),
                borderRadius: AppTheme.shape.borderRadius
              ),
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.zero,
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                margin: EdgeInsets.zero,
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment:MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                            elevation: 0,
                            label: const Text("intro video"),
                            onSelected: (bool value) {
                              navService.to(AppRoutes.splash);
                              introScreenController.videoPlaying(true);
                            },
                            shape: AppTheme.shape,
                            backgroundColor: Colors.white,
                            selected: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                            elevation: 0,
                            label: const Text("progress"),
                            onSelected: (bool value) {
                             navService.to(AppRoutes.support);
                            },
                            shape: AppTheme.shape,
                            backgroundColor: Colors.white,
                            selected: false,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            text: "For  ",
                            style: adapter.textTheme.headlineSmall,
                            children: [
                              ...HomeController.targets
                                  .map(
                                    (TargetGroup group) => TextSpan(
                                    children: [
                                      const TextSpan(text: ""),
                                      TextSpan(   text: ' ${group.name} ',

                                        style: adapter.textTheme.headlineSmall
                                            ?.copyWith( color: group.color), ),
                                      const TextSpan(text: "•",style: TextStyle(color: Colors.black12)),
                                    ]
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
                    // Image.asset(
                    //   HomeController.homeBanner,
                    //   width: Get.width,
                    //   fit: BoxFit.cover,
                    // ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Container(
                    width:adapter.width,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Here is what you get",
                      style: adapter.textTheme.headlineSmall,
                      textAlign: TextAlign.left,
                    ),
                  ),

                  ...HomeController.mainFeatures.map((e) {
                    return Container(
                      width: adapter.width,
                      child: Card(
                        shape: AppTheme.shape,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  e.icon,
                                  size: 25,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  e.name,
                                  style: adapter.textTheme.bodyLarge,textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(e.description,  style: adapter.textTheme.bodyMedium,textAlign: TextAlign.center,),
                              ),


                              // ListTile(
                              //   shape: AppTheme.shape,
                              //
                              //   title: Text(
                              //     e.name,
                              //     style: adapter.textTheme.bodyLarge,
                              //   ),
                              //   leading:  Icon(
                              //     e.icon,
                              //     size: 25,
                              //   ),
                              //   subtitle: Text(e.description,  style: adapter.textTheme.bodyMedium,),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
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
            Text(
              "Transforming Organizations!",
              style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25,),
            Wrap(
              alignment: WrapAlignment.center,
              children: [

                ...HomeController.values.map((CoreValue value){
                  return SizedBox(
                    width: Adaptive(ctx).adapt(phone: Get.width-50, tablet: 250, desktop: 300),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide( AppTheme.shape.side),
                          borderRadius: AppTheme.shape.borderRadius,
                        gradient: AppTheme.lightGradient,

                      ),
                      margin: const EdgeInsets.all(10),
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.zero,
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: AppTheme.shape,
                        margin: const EdgeInsets.all(1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 25,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:FadeInImage( placeholder: AssetImage(value.image), width:200,image: AssetImage(value.image),),
                            ),
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
          ],
        ),
      ),
    );
  }
}


