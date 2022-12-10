import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/support.controller.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:flutter/material.dart';

class AnnounceErrors {
  static accountCreationFailed() => FeedbackService.announce(
          notification: AppNotification(
        title: "Something went wrong",
        message: "Please try to login in again, or report bug if it happens again",
        appWide: true,
        child: AppButton(
          isTextButton: true,
          onPressed: () {
            SupportController.suggestFeature();
          },
          label: "Report Bug",
          
        ),
        canDismiss: true,
        type: NotificationType.error,
      ));

  static updateLoginTimestampFailed() => FeedbackService.announce(
          notification: AppNotification(
        title: "Something went wrong",
        message: "Please try to login in again, or report bug if it happens again",
        appWide: true,
        child: AppButton(
          isTextButton: true,
          onPressed: () {
            SupportController.suggestFeature();
          },
          label: "Report Bug",
          
        ),
        canDismiss: true,
        type: NotificationType.error,
      ));

  static exception(error) => FeedbackService.announce(
      notification: appNotificationFromCode(error.code??ResponseCode.unknown).copyWith(appWide: false, message: error.message));

  static dynamicLinkFailed(error) {
    return FeedbackService.announce(
        notification:
            appNotificationFromCode(error.code).copyWith(appWide: true, canDismiss: true, message: error.message));
  }

  static unknown(error) => FeedbackService.announce(
          notification: AppNotification.unknownError(error).copyWith(
        appWide: false,
        stack: error.toString(),
      ));

  static ResponseCode errorToResponseCode<T>(String name, List<T> list) {
    String validCode = name.split("/").last.toLowerCase().split("-").join("").trim();
    try {
      return ResponseCode.values.firstWhere((code) => code.name.toLowerCase().trim() == validCode.toLowerCase());
    } catch (_) {
      return ResponseCode.unknownError;
    }
  }

  static AppNotification appNotificationFromCode(String code) {
    ResponseCode errorCode = errorToResponseCode<ResponseCode>(code, ResponseCode.values);
    switch (errorCode) {
      case ResponseCode.unknownError:
        return AppNotification.unknownError();
      case ResponseCode.invalidRequest:
        return AppNotification.invalidRequest();

      case ResponseCode.invalidResponse:
        return AppNotification.invalidResponse();

      case ResponseCode.claimsTooLarge:
        return AppNotification.claimsTooLarge();

      case ResponseCode.emailAlreadyExists:
        return AppNotification.emailAlreadyExists();

      case ResponseCode.idTokenExpired:
        return AppNotification.idTokenExpired();

      case ResponseCode.idTokenRevoked:
        return AppNotification.idTokenRevoked();

      case ResponseCode.insufficientPermission:
        return AppNotification.insufficientPermission();

      case ResponseCode.internalError:
        return AppNotification.internalError();

      case ResponseCode.invalidArgument:
        return AppNotification.invalidArgument();

      case ResponseCode.invalidClaims:
        return AppNotification.invalidClaims();

      case ResponseCode.invalidContinueUri:
        return AppNotification.invalidContinueUri();

      case ResponseCode.invalidCreationTime:
        return AppNotification.invalidCreationTime();

      case ResponseCode.invalidCredential:
        return AppNotification.invalidCredential();

      case ResponseCode.invalidDisabledField:
        return AppNotification.invalidDisabledField();

      case ResponseCode.invalidDisplayName:
        return AppNotification.invalidDisplayName();

      case ResponseCode.invalidDynamicLinkDomain:
        return AppNotification.invalidDynamicLinkDomain();

      case ResponseCode.invalidEmail:
        return AppNotification.invalidEmail();

      case ResponseCode.invalidEmailVerified:
        return AppNotification.invalidEmailVerified();

      case ResponseCode.invalidHashAlgorithm:
        return AppNotification.invalidHashAlgorithm();

      case ResponseCode.invalidHashBlockSize:
        return AppNotification.invalidHashBlockSize();

      case ResponseCode.invalidHashDerivedKeyLength:
        return AppNotification.invalidHashDerivedKeyLength();

      case ResponseCode.invalidHashKey:
        return AppNotification.invalidHashKey();

      case ResponseCode.invalidHashMemoryCost:
        return AppNotification.invalidHashMemoryCost();

      case ResponseCode.invalidHashParallelization:
        return AppNotification.invalidHashParallelization();

      case ResponseCode.invalidHashRounds:
        return AppNotification.invalidHashRounds();

      case ResponseCode.invalidHashSaltSeparator:
        return AppNotification.invalidHashSaltSeparator();

      case ResponseCode.invalidIdToken:
        return AppNotification.invalidIdToken();

      case ResponseCode.invalidLastSignInTime:
        return AppNotification.invalidLastSignInTime();

      case ResponseCode.invalidPageToken:
        return AppNotification.invalidPageToken();

      case ResponseCode.invalidPassword:
        return AppNotification.invalidPassword();

      case ResponseCode.invalidPasswordHash:
        return AppNotification.invalidPasswordHash();

      case ResponseCode.invalidPasswordSalt:
        return AppNotification.invalidPasswordSalt();

      case ResponseCode.invalidPhoneNumber:
        return AppNotification.invalidPhoneNumber();

      case ResponseCode.invalidPhotoUrl:
        return AppNotification.invalidPhotoUrl();

      case ResponseCode.invalidProviderData:
        return AppNotification.invalidProviderData();

      case ResponseCode.invalidProviderId:
        return AppNotification.invalidProviderId();

      case ResponseCode.invalidSessionCookieDuration:
        return AppNotification.invalidSessionCookieDuration();

      case ResponseCode.invalidUid:
        return AppNotification.invalidUid();

      case ResponseCode.invalidUserImport:
        return AppNotification.invalidUserImport();

      case ResponseCode.maximumUserCountExceeded:
        return AppNotification.maximumUserCountExceeded();

      case ResponseCode.missingAndroidPkgName:
        return AppNotification.missingAndroidPkgName();

      case ResponseCode.missingContinueUri:
        return AppNotification.missingContinueUri();

      case ResponseCode.missingHashAlgorithm:
        return AppNotification.missingHashAlgorithm();

      case ResponseCode.missingIosBundleId:
        return AppNotification.missingIosBundleId();

      case ResponseCode.missingUid:
        return AppNotification.missingUid();

      case ResponseCode.operationNotAllowed:
        return AppNotification.operationNotAllowed();

      case ResponseCode.phoneNumberAlreadyExists:
        return AppNotification.phoneNumberAlreadyExists();

      case ResponseCode.projectNotFound:
        return AppNotification.projectNotFound();

      case ResponseCode.reservedClaims:
        return AppNotification.reservedClaims();

      case ResponseCode.sessionCookieExpired:
        return AppNotification.sessionCookieExpired();

      case ResponseCode.sessionCookieRevoked:
        return AppNotification.sessionCookieRevoked();

      case ResponseCode.uidAlreadyExists:
        return AppNotification.uidAlreadyExists();

      case ResponseCode.unauthorizedContinueUri:
        return AppNotification.unauthorizedContinueUri();
      case ResponseCode.userNotFound:
        return AppNotification.userNotFound();
      case ResponseCode.userNotAuthenticated:
        return AppNotification.userNotAuthenticated();
      default:
        return AppNotification.unknownError();
    }
  }

  static void announceErrorFromCode(String code, String message) {
    FeedbackService.announce(
        notification: appNotificationFromCode(
      code,
    ).copyWith(title: message));
  }

  static void signInLinkExpired() {
    FeedbackService.announce(
        notification: AppNotification.invalidRequest().copyWith(
            title: "Invalid or expired link, request another",
            message: "The sign in link  has probably expired, or is invalid, please try requesting another link"));
  }

  static void syncingWithAuthFailed(error) {
    FeedbackService.announce(
        notification: AppNotification(
            title: "Connecting to the cloud failed",
            stack: error.toString(),
            appWide: true,
            message: "please reload and try again",
            type: NotificationType.error));
  }
}
