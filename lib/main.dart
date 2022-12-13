import 'package:celebrated/appIntro/view/intro.view.dart';
import 'package:celebrated/app.bindings.dart';
import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/view/pages/auth.actions.dart';
import 'package:celebrated/authenticate/view/pages/email.signin.dart';
import 'package:celebrated/authenticate/view/pages/email.verifier.dart';
import 'package:celebrated/authenticate/view/pages/profile.dart';
import 'package:celebrated/authenticate/view/pages/signin.dart';
import 'package:celebrated/authenticate/view/pages/signup.dart';
import 'package:celebrated/cards/view/card.editor.dart';
import 'package:celebrated/cards/view/cards.list.dart';
import 'package:celebrated/lists/view/pages/birthday.collector.dart';
import 'package:celebrated/lists/view/pages/birthday.countdown.dart';
import 'package:celebrated/lists/view/pages/lists.dart';
import 'package:celebrated/lists/view/pages/list.shared.dart';
import 'package:celebrated/document/view/document.viewer.dart';
import 'package:celebrated/domain/view/pages/coming.soon.view.dart';
import 'package:celebrated/firebase_options.dart';
import 'package:celebrated/home/view/home.page.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/model/route.guard.dart';
import 'package:celebrated/subscription/view/subscription.view.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/notification.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/support/view/not.found.dart';
import 'package:celebrated/support/view/notification.snackbar.dart';
import 'package:celebrated/support/view/support.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:url_strategy/url_strategy.dart';

import 'authenticate/view/pages/password.reset.dart';
import 'domain/view/interface/app.page.wrapper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    await notificationService.sendNotification(message.data['message'] ?? '', '');
  }
}

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await notificationService.init();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Got message ::: ----------------  ${message.data}");
    if (message.notification != null) {
      FeedbackService.announce(
          notification: AppNotification(
        appWide: true,
        title: "${message.data['message']}",
      ));
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
        GetPage(name: AppRoutes.birthday, page: () => BirthdayCountDown(key: const Key(AppRoutes.birthday))),
        GetPage(name: AppRoutes.shareList, page: () => SharedList(key: const Key(AppRoutes.shareList))),
        GetPage(name: AppRoutes.lists, page: () => const ListsPage(key: Key(AppRoutes.lists))),
        GetPage(name: AppRoutes.list, page: () => const BirthdayListPage()),
        GetPage(
            name: AppRoutes.addBirthdayInvite,
            page: () => const BirthdayCollectionForm(key: Key(AppRoutes.addBirthdayInvite))),
        // GetPage(name: AppRoutes.about, page: () => BirthdaysOpenEditor(key: const Key(AppRoutes.addBirthdayInvite))),
        // GetPage(name: AppRoutes.about, page: () => BirthdaysOpenEditor(key: const Key(AppRoutes.addBirthdayInvite))),
        GetPage(
            name: AppRoutes.docs,
            page: () => DocumentViewer(
                  key: const Key(AppRoutes.docs),
                )),
        GetPage(name: AppRoutes.profile, page: () => const ProfilePage(key: Key(AppRoutes.profile))),
        GetPage(name: AppRoutes.authSignUp, page: () => const SignUpPage()),
        GetPage(name: AppRoutes.authSignIn, page: () => const SignInPage()),
        GetPage(name: AppRoutes.verifyEmail, page: () => const EmailVerifier()),
        GetPage(name: AppRoutes.subscriptions, page: () => const SubscriptionsPage()),
        GetPage(name: AppRoutes.cards, page: () => const CardsListPage()),
    GetPage(name: AppRoutes.cardEditor, page: () => const CardEditor()),
        // GetPage(
        // name: AppRoutes.cards,
        // page: () => const ComingSoon(
        //   image: 'assets/intro/card.png',
        //   title: 'Cards',
        //   description:
        //   'Choose from templates, to create a unique birthday cards that others can sign with notes,images,video etc.',
        // )),
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
        GetPage(name: AppRoutes.authPasswordReset, page: () => const PasswordResetPage()),
        GetPage(name: AppRoutes.authEmailSignInComplete, page: () => CompleteEmailSignIn()),
        GetPage(name: AppRoutes.authEmailSignInForm, page: () => const InitiateEmailSignIn()),
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
          navService.routeObservers.run(Get.currentRoute.split("?").first, Get.parameters);
        }
      },
      debugShowCheckedModeBanner: false,
      getPages: getPages.map((e) {
        return e.copy(
            middlewares: navService.guards.guardsInPage(e.name),
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
