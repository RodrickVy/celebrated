import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/authenticate/view/pages/email.signin.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'dart:html';

import 'package:get/get.dart';

/// handles dynamic links to the app, on android and IOS
class DynamicLinksHandler {
  static final DynamicLinksHandler instance = DynamicLinksHandler();

  listen() async {
    final String path = window.location.href;

    if (auth.isSignInWithEmailLink(path)) {
      CompleteEmailSignIn.emailLink = path;
      CompleteEmailSignIn.email = window.location.href.split('?email=').last.split('&').first;
      final Uri url = Uri.parse(path);
      final Uri url2 = Uri.parse(url.queryParameters['link']!);
      final Uri url3 = Uri.parse(url2.queryParameters['continueUrl']!);
      CompleteEmailSignIn.email = url3.queryParameters['email'] ?? '';
      navService.to(AppRoutes.authEmailSignInComplete);
    }
  }
}
