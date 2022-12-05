import 'package:celebrated/appIntro/view/intro.view.dart';
import 'package:celebrated/app.bindings.dart';
import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/view/pages/auth.actions.dart';
import 'package:celebrated/authenticate/view/pages/complete.signin.dart';
import 'package:celebrated/authenticate/view/pages/email.verifier.dart';
import 'package:celebrated/authenticate/view/pages/profile.dart';
import 'package:celebrated/authenticate/view/pages/signin.dart';
import 'package:celebrated/authenticate/view/pages/signup.dart';
import 'package:celebrated/authenticate/view/pages/verify.email.dart';
import 'package:celebrated/lists/view/birthday.adds.dart';
import 'package:celebrated/lists/view/birthday.leader.board.dart';
import 'package:celebrated/lists/view/pages/birthday.countdown.dart';
import 'package:celebrated/lists/view/birthdays.list.dart';
import 'package:celebrated/lists/view/board.view.only.dart';
import 'package:celebrated/document/view/document.viewer.dart';
import 'package:celebrated/domain/view/pages/coming.soon.view.dart';
import 'package:celebrated/firebase_options.dart';
import 'package:celebrated/home/view/home.page.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/subscription/view/subscription.view.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/support/view/not.found.dart';
import 'package:celebrated/support/view/notification.snackbar.dart';
import 'package:celebrated/support/view/support.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:url_strategy/url_strategy.dart';

import 'authenticate/view/pages/password.reset.dart';
import 'domain/view/interface/app.page.wrapper.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  List<GetPage> get getPages => [
        GetPage(name: AppRoutes.splash, page: () => const AppIntro()),
        GetPage(
            name: AppRoutes.home,
            page: () => const HomePage(
                  key: Key(AppRoutes.home),
                )),
        // GetPage(
        //     name: AppRoutes.avatarEditor,
        //     page: () =>
        //         AvatarEditorView(key: const Key(AppRoutes.avatarEditor))),
        GetPage(name: AppRoutes.birthday, page: () => BirthdayCountDown(key: const Key(AppRoutes.birthday))),
        GetPage(name: AppRoutes.shareBoard, page: () => const BoardViewOnly(key: Key(AppRoutes.shareBoard))),
        GetPage(name: AppRoutes.bBoard, page: () => const BirthdaysLeaderBoard(key: Key(AppRoutes.shareBoard))),
        GetPage(name: AppRoutes.lists, page: () => const BirthdayListsPage(key: Key(AppRoutes.lists))),
        GetPage(name: AppRoutes.openListEdit, page: () => BirthdaysOpenEditor(key: const Key(AppRoutes.openListEdit))),
        GetPage(name: AppRoutes.about, page: () => BirthdaysOpenEditor(key: const Key(AppRoutes.openListEdit))),
        GetPage(name: AppRoutes.about, page: () => BirthdaysOpenEditor(key: const Key(AppRoutes.openListEdit))),
        GetPage(
            name: AppRoutes.docs,
            page: () => DocumentViewer(
                  key: const Key(AppRoutes.docs),
                )),
        GetPage(name: AppRoutes.profile, page: () => ProfilePage(key: const Key(AppRoutes.profile))),
        GetPage(name: AppRoutes.authSignUp, page: () => const SignUpPage()),
        GetPage(name: AppRoutes.authSignIn, page: () => const SignInPage()),
        GetPage(name: AppRoutes.completeSignIn, page: () => CompleteEmailVerification()),
        GetPage(name: AppRoutes.verifyEmail, page: () => const EmailVerifier()),
        GetPage(name: AppRoutes.subscriptions, page: () => const SubscriptionsPage()),
        GetPage(
            name: AppRoutes.cards,
            page: () => const ComingSoon(
                  image: 'assets/intro/card.png',
                  title: 'Cards',
                  description:
                      'Create unique birthday cards that you can invite others to sign.  Ad image/video etc on card and easily share via link.',
                )),
        GetPage(
            name: AppRoutes.parties,
            page: () => const ComingSoon(
                  image: 'assets/intro/party.png',
                  title: 'Parties',
                  description:
                      'Organize parties, with easy forms for invites, and  lists for planning. Fun birthday games from deep meaningful to funny and trivial.',
                )),
        GetPage(
            name: AppRoutes.gifts,
            page: () => const ComingSoon(
                  image: 'assets/intro/gift_happy.png',
                  title: 'Gifts',
                  description:
                      'Create and share virtual gifts of any online product with personal note and packaging.Share Gift cards,subscriptions or any gift. ',
                )),
        GetPage(name: AppRoutes.authPasswordReset, page: () => PasswordResetPage()),
        GetPage(name: AppRoutes.support, page: () => const SupportView(key: Key(AppRoutes.support))),
        GetPage(name: AppRoutes.actions, page: () => const AuthActionsHandler(key: Key(AppRoutes.support))),
      ];

  @override
  Widget build(BuildContext context) {
    /// setting up system status bar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: AppSwatch.primary.shade700, statusBarColor: AppSwatch.primary.shade700),
    );

    return GetMaterialApp(
      title: 'celebrated',
      theme: AppTheme.themeData,
      unknownRoute: GetPage(name: AppRoutes.notFound, page: () => const NotFoundView(key: Key(AppRoutes.notFound))),
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 800),
      initialRoute: AppRoutes.splash,
      initialBinding: AppBindings(),
      routingCallback: (Routing? routing) {
        if (routing != null) {
          FeedbackService.listenToRoute(routing);
          String route = Get.currentRoute.split("?").first;
          navService.callOnRoute(route, Get.parameters);
        }
      },
      debugShowCheckedModeBanner: false,
      getPages: getPages.map((e) {
        return e.copy(
            page: () => SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: AppPageWrapper(
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
