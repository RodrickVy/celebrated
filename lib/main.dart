import 'package:celebrated/appIntro/controller/intro.controller.dart';
import 'package:celebrated/appIntro/view/intro.view.dart';
import 'package:celebrated/authenticate/view/avatar.selector.dart';
import 'package:celebrated/app.bindings.dart';
import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/view/authentication.view.dart';
import 'package:celebrated/birthday/view/birthday.adds.dart';
import 'package:celebrated/birthday/view/birthday.leader.board.dart';
import 'package:celebrated/birthday/view/birthday.page.dart';
import 'package:celebrated/birthday/view/birthdays.list.dart';
import 'package:celebrated/birthday/view/board.view.only.dart';
import 'package:celebrated/document/view/document.viewer.dart';
import 'package:celebrated/domain/view/app.page.view.dart';
import 'package:celebrated/firebase_options.dart';
import 'package:celebrated/home/view/home.page.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/support/view/not.found.dart';
import 'package:celebrated/support/view/notification.snackbar.dart';
import 'package:celebrated/support/view/support.dart';
import 'package:celebrated/util/list.extention.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/route_manager.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  List<GetPage> get getPages => [
        GetPage(name: AppRoutes.splash, page: () => AppIntro<IntroScreenController>()),
        GetPage(
            name: AppRoutes.home,
            page: () => HomePage(
                  key: const Key(AppRoutes.home),
                )),
        // GetPage(
        //     name: AppRoutes.avatarEditor,
        //     page: () =>
        //         AvatarEditorView(key: const Key(AppRoutes.avatarEditor))),
        GetPage(
            name: AppRoutes.birthday,
            page: () => BirthdayPageView(key: const Key(AppRoutes.birthday))),
        GetPage(
            name: AppRoutes.shareBoard,
            page: () => BoardViewOnly(key: const Key(AppRoutes.shareBoard))),
        GetPage(
            name: AppRoutes.bBoard,
            page: () =>
                BirthdaysLeaderBoard(key: const Key(AppRoutes.shareBoard))),
        GetPage(
            name: AppRoutes.lists,
            page: () => BirthdayBoardsView(key: const Key(AppRoutes.lists))),
        GetPage(
            name: AppRoutes.openListEdit,
            page: () =>
                BirthdaysOpenEditor(key: const Key(AppRoutes.openListEdit))),
        GetPage(
            name: AppRoutes.about,
            page: () =>
                BirthdaysOpenEditor(key: const Key(AppRoutes.openListEdit))),
        GetPage(
            name: AppRoutes.docs,
            page: () => DocumentViewer(
                  key: const Key(AppRoutes.docs),
                )),
        GetPage(
            name: AppRoutes.auth,
            page: () => AuthView(key: const Key(AppRoutes.auth))),
        GetPage(
            name: "${AppRoutes.auth}/:page",
            page: () => AuthView(key: const Key(AppRoutes.auth))),
        GetPage(
            name: AppRoutes.support,
            page: () => SupportView(key: const Key(AppRoutes.support))),

      ];

  @override
  Widget build(BuildContext context) {
    /// setting up system status bar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: AppSwatch.primary.shade700,
          statusBarColor: AppSwatch.primary.shade700),
    );

    return GetMaterialApp(
      title: 'celebrated',
      theme: AppTheme.themeData,
      unknownRoute:   GetPage(
          name: AppRoutes.notFound,
          page: () => NotFoundView(key: const Key(AppRoutes.notFound))) ,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 800),
      initialRoute: AppRoutes.home,
      initialBinding: AppBindings(),
      // todo asses if this is necessary
      routingCallback: (Routing? routing) {
        if (routing != null) {
          FeedbackService.listenToRoute(routing);
          String itemName =
              "/${Get.currentRoute.split("?").first.split("/").sublist(1).first}";
          NavController.instance.items.forEach2((item, index) {
            if (item.route == itemName) {
              NavController.instance.currentBottomBarIndex(index);
            }
          });
          switch (itemName) {
            case AppRoutes.openListEdit:
            case AppRoutes.birthday:
            case AppRoutes.shareBoard:
              NavController.instance.currentBottomBarIndex(1);
              break;
            case AppRoutes.support:
              NavController.instance.currentBottomBarIndex(0);
          }
          Get.log(itemName);
        }
      },

      debugShowCheckedModeBanner: false,
      getPages: getPages.map((e) {
        return e.copy(
            page: () => SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: AppPageViewWrapper(
                    body: Stack(
                      children: [
                        SizedBox(
                          width: Get.width,
                          height: Get.height,
                          child: e.page(),
                        ),
                        const NotificationSnackBar(
                          key: Key(""),
                        ),
                        Positioned.fill(
                            child: FeedbackSpinner(
                          spinnerKey: FeedbackSpinKeys.appWide,
                          child: SizedBox(
                            width: Get.width,
                            height: Get.height,
                          ),
                        )),
                      ],
                    ),
                  ),
                ));
      }).toList(),
    );
  }
}
