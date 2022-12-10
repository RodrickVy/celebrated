
import 'dart:html';

import 'package:celebrated/authenticate/view/pages/email.signin.dart';
import 'package:celebrated/domain/services/instances.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';


/// handles dynamic links to the app, on android and IOS
class DynamicLinksHandler {
  static final DynamicLinksHandler instance = DynamicLinksHandler();

  listen() async {
    final String path = window.location.href;
    final Uri url = Uri.parse(path);
    if (auth.isSignInWithEmailLink(path)) {
      CompleteEmailSignIn.emailLink = path;
      CompleteEmailSignIn.email = window.location.href.split('?email=').last.split('&').first;

      final Uri url2 = Uri.parse(url.queryParameters['link']!);
      final Uri url3 = Uri.parse(url2.queryParameters['continueUrl']!);
      CompleteEmailSignIn.email = url3.queryParameters['email'] ?? '';
      navService.to(AppRoutes.authEmailSignInComplete);
    }
    if (isAddBirthdayLink(path)) {
      final String code = url.queryParameters['code']!;
    }
  }

  Future<Uri> createDynamicLink(String route) async {
    return Uri.parse('https://celebratedapp.com/link/bAmq');
  }

  bool isAddBirthdayLink(path) {
    return path.contains('celebratedapp.com/link/bAmq') || path.contains('celebrated-app.web.app/link/bAmq');
  }
}
