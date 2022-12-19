// import 'package:celebrated/authenticate/view/pages/email.signin.dart';
// import 'package:celebrated/domain/errors/app.errors.dart';
// import 'package:celebrated/domain/services/instances.dart';
// import 'package:celebrated/navigation/controller/nav.controller.dart';
// import 'package:celebrated/navigation/controller/route.names.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:get/get.dart';
//
// /// handles dynamic links to the app, on android and IOS
// class DynamicLinksHandler {
//   static final DynamicLinksHandler instance = DynamicLinksHandler();
//
//   listen() async {
//     final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
//     if (initialLink != null) {
//       final Uri deepLink = initialLink.link;
//       if (auth.isSignInWithEmailLink(deepLink.path)) {
//         CompleteEmailSignIn.emailLink = deepLink.path;
//         navService.to(AppRoutes.authEmailSignInComplete);
//       } else {
//         navService.to(deepLink.path);
//       }
//       Get.log("Terminated State>> Dynamic link path:: ${deepLink.path}");
//     }
//
//     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//       if (auth.isSignInWithEmailLink(dynamicLinkData.link.path)) {
//         CompleteEmailSignIn.emailLink = dynamicLinkData.link.path;
//         navService.to(AppRoutes.authEmailSignInComplete);
//       } else {
//         navService.to(dynamicLinkData.link.path);
//       }
//
//       Get.log("Background / Foreground State>> Dynamic link path:: ${dynamicLinkData.link.path}");
//     }).onError((error) {
//       navService.to(AppRoutes.notFound);
//       AnnounceErrors.dynamicLinkFailed(error);
//     });
//   }
//
//
//   Future<Uri> createDynamicLink(String route)async{
//     final dynamicLinkParams = DynamicLinkParameters(
//       link: Uri.parse("https://celebratedapp.com/${route}"),
//       uriPrefix: "https://celebratedapp.com/link",
//       androidParameters: const AndroidParameters(packageName: "com.rodrickvy.celebrated"),
//       iosParameters: const IOSParameters(bundleId: "com.rodrickvy.celebrated"),
//     );
//
//       return  await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
//   }
//
// }
