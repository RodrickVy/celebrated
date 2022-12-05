import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/authenticate/view/pages/complete.signin.dart';
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
      CompleteEmailVerification.emailLink = path;
      CompleteEmailVerification.email = window.location.href.split('?email=').last.split('&').first;
      final Uri url = Uri.parse(path);
      final Uri url2 = Uri.parse(url.queryParameters['link']!);
      final Uri url3 = Uri.parse(url2.queryParameters['continueUrl']!);
      CompleteEmailVerification.email = url3.queryParameters['email'] ?? '';
      navService.to(AppRoutes.completeSignIn);
    }
  }
}
