import 'package:celebrated/domain/model/imodel.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNotification implements IModel {
  final NotificationType type;
  final bool appWide;
  final ResponseCode code;
  final String title;
  final String stack;
  final String message;
  final Icon? icon;
  final Duration? aliveFor;
  final int timestamp;
  final String route;
  final Widget? child;
  final bool canDismiss;

  AppNotification({
     this.message = '',
    required this.title,
    this.child,
    this.aliveFor,
    this.icon,
    this.appWide = false,
    this.canDismiss = true,
     this.code = ResponseCode.unknown,
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
      code: map['code'] as ResponseCode,
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
        code: ResponseCode.unknown,
        route: "",
        stack: "",
        timestamp: 0);
  }

  factory AppNotification.unknownError() {
    return AppNotification(
      code: ResponseCode.unknownError,
      title: "Sorry Something went wrong, didn't get the right response",
      message: "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,

    );
  }

  factory AppNotification.invalidRequest() {
    return AppNotification(
      code: ResponseCode.invalidRequest,
      title: "Something wrong with you inputted data please check",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
      message: 'check the formatting and verify if its correct.',
    );
  }

  factory AppNotification.invalidResponse() {
    return AppNotification(
      code: ResponseCode.invalidResponse,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.claimsTooLarge() {
    return AppNotification(
      code: ResponseCode.claimsTooLarge,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.emailAlreadyExists() {
    return AppNotification(
      code: ResponseCode.emailAlreadyExists,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.idTokenExpired() {
    return AppNotification(
      code: ResponseCode.idTokenExpired,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.idTokenRevoked() {
    return AppNotification(
      code: ResponseCode.idTokenRevoked,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.insufficientPermission() {
    return AppNotification(
      code: ResponseCode.insufficientPermission,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.internalError() {
    return AppNotification(
      code: ResponseCode.internalError,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",

      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidArgument() {
    return AppNotification(
      code: ResponseCode.invalidArgument,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidClaims() {
    return AppNotification(
      code: ResponseCode.invalidClaims,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
      stack: '',
    );
  }

  factory AppNotification.invalidContinueUri() {
    return AppNotification(
      code: ResponseCode.invalidContinueUri,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidCreationTime() {
    return AppNotification(
      code: ResponseCode.invalidCreationTime,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidCredential() {
    return AppNotification(
      code: ResponseCode.invalidCredential,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidDisabledField() {
    return AppNotification(
      code: ResponseCode.invalidDisabledField,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidDisplayName() {
    return AppNotification(
      code: ResponseCode.invalidDisplayName,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidDynamicLinkDomain() {
    return AppNotification(
      code: ResponseCode.invalidDynamicLinkDomain,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidEmail() {
    return AppNotification(
      code: ResponseCode.invalidEmail,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidEmailVerified() {
    return AppNotification(
      code: ResponseCode.invalidEmailVerified,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashAlgorithm() {
    return AppNotification(
      code: ResponseCode.invalidHashAlgorithm,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashBlockSize() {
    return AppNotification(
      code: ResponseCode.invalidHashBlockSize,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashDerivedKeyLength() {
    return AppNotification(
      code: ResponseCode.invalidHashDerivedKeyLength,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashKey() {
    return AppNotification(
      code: ResponseCode.invalidHashKey,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashMemoryCost() {
    return AppNotification(
      code: ResponseCode.invalidHashMemoryCost,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashParallelization() {
    return AppNotification(
      code: ResponseCode.invalidHashParallelization,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashRounds() {
    return AppNotification(
      code: ResponseCode.invalidHashRounds,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidHashSaltSeparator() {
    return AppNotification(
      code: ResponseCode.invalidHashSaltSeparator,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidIdToken() {
    return AppNotification(
      code: ResponseCode.invalidIdToken,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidLastSignInTime() {
    return AppNotification(
      code: ResponseCode.invalidLastSignInTime,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPageToken() {
    return AppNotification(
      code: ResponseCode.invalidPageToken,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPassword() {
    return AppNotification(
      code: ResponseCode.invalidPassword,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPasswordHash() {
    return AppNotification(
      code: ResponseCode.invalidPasswordHash,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPasswordSalt() {
    return AppNotification(
      code: ResponseCode.invalidPasswordSalt,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPhoneNumber() {
    return AppNotification(
      code: ResponseCode.invalidPhoneNumber,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidPhotoUrl() {
    return AppNotification(
      code: ResponseCode.invalidPhotoUrl,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidProviderData() {
    return AppNotification(
      code: ResponseCode.invalidProviderData,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidProviderId() {
    return AppNotification(
      code: ResponseCode.invalidProviderId,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidSessionCookieDuration() {
    return AppNotification(
      code: ResponseCode.invalidSessionCookieDuration,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidUid() {
    return AppNotification(
      code: ResponseCode.invalidUid,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.invalidUserImport() {
    return AppNotification(
      code: ResponseCode.invalidUserImport,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.maximumUserCountExceeded() {
    return AppNotification(
      code: ResponseCode.maximumUserCountExceeded,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.missingAndroidPkgName() {
    return AppNotification(
      code: ResponseCode.missingAndroidPkgName,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.missingContinueUri() {
    return AppNotification(
      code: ResponseCode.missingContinueUri,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.missingHashAlgorithm() {
    return AppNotification(
      code: ResponseCode.missingHashAlgorithm,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.missingIosBundleId() {
    return AppNotification(
      code: ResponseCode.missingIosBundleId,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.missingUid() {
    return AppNotification(
      code: ResponseCode.missingUid,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.operationNotAllowed() {
    return AppNotification(
      code: ResponseCode.operationNotAllowed,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.phoneNumberAlreadyExists() {
    return AppNotification(
      code: ResponseCode.phoneNumberAlreadyExists,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.projectNotFound() {
    return AppNotification(
      code: ResponseCode.projectNotFound,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.reservedClaims() {
    return AppNotification(
      code: ResponseCode.reservedClaims,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.sessionCookieExpired() {
    return AppNotification(
      code: ResponseCode.sessionCookieExpired,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.sessionCookieRevoked() {
    return AppNotification(
      code: ResponseCode.sessionCookieRevoked,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.uidAlreadyExists() {
    return AppNotification(
      code: ResponseCode.uidAlreadyExists,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.unauthorizedContinueUri() {
    return AppNotification(
      code: ResponseCode.unauthorizedContinueUri,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.userNotFound() {
    return AppNotification(
      code: ResponseCode.userNotFound,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.userNotAuthenticated() {
    return AppNotification(
      code: ResponseCode.userNotAuthenticated,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  factory AppNotification.userUnverifiedEmail() {
    //  this is sent to know that the user's email link has been sent
    return AppNotification(
      code: ResponseCode.internalError,
      title: "So Sorry!, Something went wrong, please try again",
      message:
          "",
      route: Get.currentRoute,
      timestamp: DateTime.now().microsecondsSinceEpoch,
    );
  }

  AppNotification copyWith({
    NotificationType? type,
    bool? appWide,
    ResponseCode? code,
    String? title,
    String? stack,
    String? message,
    Icon? icon,
    Duration? aliveFor,
    int? timestamp,
    String? route,
    Widget? child,
    bool? canDismiss,
  }) {
    return AppNotification(
      type: type ?? this.type,
      appWide: appWide ?? this.appWide,
      code: code ?? this.code,
      title: title ?? this.title,
      stack: stack ?? this.stack,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      aliveFor: aliveFor ?? this.aliveFor,
      timestamp: timestamp ?? this.timestamp,
      route: route ?? this.route,
      child: child ?? this.child,
      canDismiss: canDismiss ?? this.canDismiss,
    );
  }
}
