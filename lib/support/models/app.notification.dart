import 'package:bremind/domain/model/imodel.dart';
import 'package:bremind/support/models/app.error.code.dart';
import 'package:bremind/support/models/notification.type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNotification implements IModel {
  final NotificationType type;
  final bool appWide;
  final AppErrorCodes code;
  final String title;
  final String stack;
  final String message;
  final int timestamp;
  final String route;
  final Widget? child;

  AppNotification({
    required this.message,
    required this.title,
    this.child,
    this.appWide = true,
    required this.code,
    this.type = NotificationType.error,
    this.stack = "",
    this.route = '/',
    this.timestamp = 45
  });


  @override
  String get id => timestamp.toString() + route.hashCode.toString();

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'code': code,
      'title': title,
      'stack': stack,
      'message': message,
      'timestamp': timestamp,
      'route': route,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      type: map['type'] as NotificationType,
      code: map['code'] as AppErrorCodes,
      title: map['title'] as String,
      stack: map['stack'] as String,
      message: map['message'] as String,
      timestamp: map['timestamp'] as int,
      route: map['route'] as String,
    );
  }

  static AppNotification empty() {
    return AppNotification(
        message: "",
        title: "",
        code: AppErrorCodes.unknown,
        route: "",
        stack: "",
        timestamp: 0);
  }

  factory AppNotification.unknownError() {
    return AppNotification(
      code: AppErrorCodes.unknownError,
      title: "Sorry Something went wrong, didn't get the right response",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidRequest() {
    return AppNotification(
      code: AppErrorCodes.invalidRequest,
      title: "Something wrong with you inputted data please check",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
      message: 'check the formatting and verify if its correct.',
    );
  }

  factory AppNotification.invalidResponse() {
    return AppNotification(
      code: AppErrorCodes.invalidResponse,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.claimsTooLarge() {
    return AppNotification(
      code: AppErrorCodes.claimsTooLarge,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.emailAlreadyExists() {
    return AppNotification(
      code: AppErrorCodes.emailAlreadyExists,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.idTokenExpired() {
    return AppNotification(
      code: AppErrorCodes.idTokenExpired,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.idTokenRevoked() {
    return AppNotification(
      code: AppErrorCodes.idTokenRevoked,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.insufficientPermission() {
    return AppNotification(
      code: AppErrorCodes.insufficientPermission,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.internalError() {
    return AppNotification(
      code: AppErrorCodes.internalError,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidArgument() {
    return AppNotification(
      code: AppErrorCodes.invalidArgument,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidClaims() {
    return AppNotification(
      code: AppErrorCodes.invalidClaims,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
      stack: '',
    );
  }

  factory AppNotification.invalidContinueUri() {
    return AppNotification(
      code: AppErrorCodes.invalidContinueUri,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidCreationTime() {
    return AppNotification(
      code: AppErrorCodes.invalidCreationTime,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidCredential() {
    return AppNotification(
      code: AppErrorCodes.invalidCredential,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidDisabledField() {
    return AppNotification(
      code: AppErrorCodes.invalidDisabledField,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidDisplayName() {
    return AppNotification(
      code: AppErrorCodes.invalidDisplayName,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidDynamicLinkDomain() {
    return AppNotification(
      code: AppErrorCodes.invalidDynamicLinkDomain,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidEmail() {
    return AppNotification(
      code: AppErrorCodes.invalidEmail,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidEmailVerified() {
    return AppNotification(
      code: AppErrorCodes.invalidEmailVerified,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashAlgorithm() {
    return AppNotification(
      code: AppErrorCodes.invalidHashAlgorithm,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashBlockSize() {
    return AppNotification(
      code: AppErrorCodes.invalidHashBlockSize,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashDerivedKeyLength() {
    return AppNotification(
      code: AppErrorCodes.invalidHashDerivedKeyLength,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashKey() {
    return AppNotification(
      code: AppErrorCodes.invalidHashKey,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashMemoryCost() {
    return AppNotification(
      code: AppErrorCodes.invalidHashMemoryCost,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashParallelization() {
    return AppNotification(
      code: AppErrorCodes.invalidHashParallelization,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashRounds() {
    return AppNotification(
      code: AppErrorCodes.invalidHashRounds,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashSaltSeparator() {
    return AppNotification(
      code: AppErrorCodes.invalidHashSaltSeparator,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidIdToken() {
    return AppNotification(
      code: AppErrorCodes.invalidIdToken,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidLastSignInTime() {
    return AppNotification(
      code: AppErrorCodes.invalidLastSignInTime,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPageToken() {
    return AppNotification(
      code: AppErrorCodes.invalidPageToken,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPassword() {
    return AppNotification(
      code: AppErrorCodes.invalidPassword,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPasswordHash() {
    return AppNotification(
      code: AppErrorCodes.invalidPasswordHash,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPasswordSalt() {
    return AppNotification(
      code: AppErrorCodes.invalidPasswordSalt,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPhoneNumber() {
    return AppNotification(
      code: AppErrorCodes.invalidPhoneNumber,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPhotoUrl() {
    return AppNotification(
      code: AppErrorCodes.invalidPhotoUrl,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidProviderData() {
    return AppNotification(
      code: AppErrorCodes.invalidProviderData,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidProviderId() {
    return AppNotification(
      code: AppErrorCodes.invalidProviderId,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidSessionCookieDuration() {
    return AppNotification(
      code: AppErrorCodes.invalidSessionCookieDuration,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidUid() {
    return AppNotification(
      code: AppErrorCodes.invalidUid,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidUserImport() {
    return AppNotification(
      code: AppErrorCodes.invalidUserImport,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.maximumUserCountExceeded() {
    return AppNotification(
      code: AppErrorCodes.maximumUserCountExceeded,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.missingAndroidPkgName() {
    return AppNotification(
      code: AppErrorCodes.missingAndroidPkgName,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.missingContinueUri() {
    return AppNotification(
      code: AppErrorCodes.missingContinueUri,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.missingHashAlgorithm() {
    return AppNotification(
      code: AppErrorCodes.missingHashAlgorithm,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.missingIosBundleId() {
    return AppNotification(
      code: AppErrorCodes.missingIosBundleId,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.missingUid() {
    return AppNotification(
      code: AppErrorCodes.missingUid,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.operationNotAllowed() {
    return AppNotification(
      code: AppErrorCodes.operationNotAllowed,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.phoneNumberAlreadyExists() {
    return AppNotification(
      code: AppErrorCodes.phoneNumberAlreadyExists,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.projectNotFound() {
    return AppNotification(
      code: AppErrorCodes.projectNotFound,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.reservedClaims() {
    return AppNotification(
      code: AppErrorCodes.reservedClaims,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.sessionCookieExpired() {
    return AppNotification(
      code: AppErrorCodes.sessionCookieExpired,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.sessionCookieRevoked() {
    return AppNotification(
      code: AppErrorCodes.sessionCookieRevoked,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.uidAlreadyExists() {
    return AppNotification(
      code: AppErrorCodes.uidAlreadyExists,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.unauthorizedContinueUri() {
    return AppNotification(
      code: AppErrorCodes.unauthorizedContinueUri,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.userNotFound() {
    return AppNotification(
      code: AppErrorCodes.userNotFound,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.userNotAuthenticated() {
    return AppNotification(
      code: AppErrorCodes.userNotAuthenticated,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.userUnverifiedEmail() {
    //  this is sent to know that the user's email link has been sent
    return AppNotification(
      code: AppErrorCodes.internalError,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "try again , if it fail , wait for a bit more and try again. If doesn't work be sure to report this and will get on as quickly as possible.",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  AppNotification copyWith({
    NotificationType? type,
    bool? appWide,
    AppErrorCodes? code,
    String? title,
    String? stack,
    String? message,
    int? timestamp,
    String? route,
    Widget? child,
  }) {
    return AppNotification(
      type: type ?? this.type,
      appWide: appWide ?? this.appWide,
      code: code ?? this.code,
      title: title ?? this.title,
      stack: stack ?? this.stack,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      route: route ?? this.route,
      child: child ?? this.child,
    );
  }
}
