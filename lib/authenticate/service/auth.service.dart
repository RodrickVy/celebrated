import 'package:celebrated/authenticate/adapter/user.acount.factory.dart';
import 'package:celebrated/authenticate/models/account.dart';
import 'package:celebrated/authenticate/models/verify.email.response.dart';
import 'package:celebrated/authenticate/requests/signin.request.dart';
import 'package:celebrated/domain/services/content.store/model/content.interaction.dart';
import 'package:celebrated/authenticate/requests/signup.request.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/errors/app.errors.dart';
import 'package:celebrated/domain/services/content.store/repository/repository.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/model/route.guard.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/notification.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;

/// manages authentication state and maintenance of Account and Auth objects of the user
class AuthService extends GetxController with ContentStore<UserAccount, AccountUserFactory> {
  /// a live listenable to keep track of the current user
  final Rx<UserAccount> userLive = UserAccount.unAuthenticated().obs;

  /// quick way to get the current user in a given time, wont update
  UserAccount get user => userLive.value;

  @override
  UserAccount get empty => UserAccount.unAuthenticated();

  @override
  AccountUserFactory get docFactory => AccountUserFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference => firestore.collection('users');

  AuthService._() {
    auth.authStateChanges().listen((User? authUser) async {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (authUser != null) {
          await syncOnAuthentication(authUser);
          await saveDeviceTokenToDB();
          await addDeviceToUsersPlatforms();
        } else {
          userLive(UserAccount.unAuthenticated());
        }
      });

      /// setting all the spinners in auth-components off ,when authentication has changed!
      FeedbackService.appNotification.listen((AppNotification? error) {
        if (error != null) {
          FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.auth, isOn: false);
        }
      });
    });
  }

  Future<void> saveDeviceTokenToDB() async {
    if (userLive.value.deviceToken.isEmpty) {
      await authService.updateContent(authService.userLive.value.id, {"deviceToken": notificationService.fcmToken});
    }
  }

  Future<void> addDeviceToUsersPlatforms() async {
    if (!userLive.value.platforms.contains(devicePlatform)) {
      await authService.updateContent(authService.userLive.value.id, {
        "platforms": [...userLive.value.platforms, devicePlatform]
      });
    }
  }

  static String get devicePlatform {
    return GetPlatform.isWeb
        ? 'web'
        : GetPlatform.isAndroid
            ? "android"
            : GetPlatform.isIOS
                ? "ios"
                : 'other';
  }

  static AuthService instance = AuthService._();

  // Sign Up & SignIn & Password Reset
  Future<UserAccount> createUserAccount(UserAccount user) async {
    await setContent(user);
    return user;
  }

  Future<void> signUp(SignUpEmailRequest request) async {
    if (request.validate()) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(email: request.email, password: request.password);
        if (userCredential.user != null) {
          await userCredential.user!.updateDisplayName(request.name);
          final UserAccount accountData = UserAccount.mergeAuthWithRequest(userCredential.user!, request);
          await createUserAccount(accountData);
          syncOnAuthentication(userCredential.user!);
        } else {
          AnnounceErrors.accountCreationFailed();
        }
      } on FirebaseAuthException catch (error) {
        AnnounceErrors.announceErrorFromCode(error.code, error.message ?? '');
      } catch (e) {
        AnnounceErrors.unknown(e);
      }
    }
  }

  Future<UserAccount> signIn(SignInEmailRequest request) async {
    Get.log("User request is valid: ${request.validate()}");
    if (request.validate()) {
      try {
        UserCredential credential =
            await auth.signInWithEmailAndPassword(email: request.email, password: request.password);
        if (credential.user != null) {
          int loginTimestamp = DateTime.now().millisecondsSinceEpoch;
           await updateContent(
              credential.user!.uid, {'lastLogin': loginTimestamp, "emailVerified": credential.user!.emailVerified});
          await syncOnAuthentication(credential.user!);
          return user;
        } else {
          AnnounceErrors.updateLoginTimestampFailed();
        }
      } on FirebaseAuthException catch (error) {
        Get.log("Error user: ${error.message} ${error.code}");
        AnnounceErrors.announceErrorFromCode(error.code, error.message ?? "");
      } catch (e) {
        Get.log("Unknown user: $e");
        AnnounceErrors.unknown(e);
      }
    }
    return UserAccount.unAuthenticated();
  }

  /// updates all local variables when authentication state has changed
  Future<void> syncOnAuthentication(User user) async {
    try {
      userLive(await getContent(user.uid));
      print("${navService.nextRouteExists}");
      if (navService.nextRouteExists) {
        navService.toNextRoute();
      } else {
        navService.to(AppRoutes.lists);
      }
    } catch (_) {
      AnnounceErrors.syncingWithAuthFailed(_);
    }
  }

  bool emailNeedsVerification([String? currentRoute]) =>
      user.isAuthenticated && navService.routeIsNot(AppRoutes.verifyEmail, currentRoute);

  bool userNeedsToBeAuthenticated([String? currentRoute]) =>
      user.isUnauthenticated && !(navService.authRoutes.contains(navService.baseRoute(currentRoute)));

          //&&
    //  !navService.authRoutes.contains(navService.baseRoute(currentRoute)) &&
     // navService.authProtectedRoutes.contains(navService.baseRoute(currentRoute));

  bool userNeedsToSelectPlan([String? currentRoute]) =>
      !emailNeedsVerification(currentRoute) &&
      navService.subscriptionClarityRoutes.contains(navService.baseRoute(currentRoute));

  Future<void> syncAuthUserWithAccount(User authUser) async {
    await updateContent(authUser.uid, {"emailVerified": authUser.emailVerified == true});
  }

  signInWithPopUpProvider({required provider}) async {
    try {
      await auth.signInWithPopup(provider);
    } on FirebaseAuthException catch (error) {
      AnnounceErrors.announceErrorFromCode(error.code, error.message ?? "");
    } catch (e) {
      AnnounceErrors.unknown(e);
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      AnnounceErrors.exception(error);
    } catch (e) {
      AnnounceErrors.unknown(e);
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await auth.signOut();
  }

  Future<bool> sendPasswordResetEmail({required String email}) async {
    if (Validators.validateField(Validators.emailFormValidator, email)) {
      try {
        await auth.sendPasswordResetEmail(
          email: email,
          // actionCodeSettings: ActionCodeSettings(
          //     url: 'https://celebratedapp.com/link/signIn',
          //   androidInstallApp: true,
          //   androidPackageName: "com.rodrickvy.celebrated",
          //   iOSBundleId: "com.rodrickvy.celebrated",
          //   handleCodeInApp: true
          // )
        );
        FeedbackService.successAlertSnack("Reset Email Sent! Check Your Spam Folder If You Can't Find It", 7000);
        return true;
      } on FirebaseAuthException catch (error) {
        AnnounceErrors.announceErrorFromCode(error.code, error.message ?? "");
        return false;
      } catch (e) {
        AnnounceErrors.unknown(e);
        return false;
      }
    }
    return false;
  }

  ActionCodeSettings emailLinkActionSettings(String email) {
    return ActionCodeSettings(
      url: 'https://celebratedapp.com/?email=${email}&nextUrl=${navService.getNextRoute ?? ''}',
      androidInstallApp: true,
      androidMinimumVersion: '2',
      androidPackageName: "com.rodrickvy.celebrated",
      iOSBundleId: "com.rodrickvy.celebrated",
      handleCodeInApp: true,
    );
  }

  /// send verification of email to user and returns weather the users email is verified
  Future<bool> sendSignInLink(String email) async {
    if (Validators.validateField(Validators.emailFormValidator, email)) {
      try {
        await auth.sendSignInLinkToEmail(email: email, actionCodeSettings: emailLinkActionSettings(email));
        return true;
      } on FirebaseAuthException catch (error) {
        AnnounceErrors.announceErrorFromCode(error.code, error.message ?? "");
        return false;
      } catch (e) {
        AnnounceErrors.unknown(e);
        return false;
      }
    }
    return false;
  }

  /// handles the return url of a email verification link
  Future<bool> handleSignInLink(String email, String emailLink) async {
    if (Validators.validateField(Validators.emailFormValidator, email)) {
      try {
        if (auth.isSignInWithEmailLink(emailLink)) {
          Get.log("isValidLink  $emailLink");
          //   FeedbackService.announce(notification: AppNotification(title: "Key: ${emailLink}",appWide: true));
          UserCredential? credential = await auth.signInWithEmailLink(email: email, emailLink: emailLink);
          if (credential.user != null) {
            await updateContent(credential.user!.uid, {"emailVerified": true});
            return true;
          } else {
            return false;
          }
        } else {
          AnnounceErrors.signInLinkExpired();

          return false;
        }
      } on FirebaseAuthException catch (error) {
        AnnounceErrors.announceErrorFromCode(
            error.code,
            (error.message != null && error.message?.trim() != 'Error')
                ? error.message!
                : "Something went wrong, try again.");

        Get.log("code: ${error.code} message:${error.message} ${error.stackTrace} $emailLink");
        return false;
      } catch (e) {
        Get.log("code: ${e} message:${e}  $emailLink");
        AnnounceErrors.unknown(e);
        // return false;
        rethrow;
      }
    }
    return false;
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      navService.to(AppRoutes.authSignIn);
    } on FirebaseAuthException catch (error) {
      AnnounceErrors.exception(error);
    } catch (e) {
      AnnounceErrors.unknown(e);
    }
  }

  // Editing Profile
  Future<UserAccount> updateUserName({required String name}) async {
    if (user.isAuthenticated && Validators.validateField(Validators.userNameValidator, name) && name != user.name) {
      try {
         await updateContent(userLive.value.uid, {'name': name}).then((value) {
          userLive(value);
          userLive.refresh();
        });
      } catch (error) {
        AnnounceErrors.unknown(error);
      }
    }
    return userLive.value;
  }

  Future<UserAccount> updateBirthdate({required DateTime date}) async {
    try {
      return await updateContent(userLive.value.uid, {'birthdate': date.millisecondsSinceEpoch}).then((value) {
        userLive(value);
        userLive.refresh();
        return value;
      });
    } catch (error) {
      FeedbackService.announce(
          notification: AppNotification.unknownError().copyWith(message: error.toString(), title: error.toString()));
      return userLive.value;
    }
  }

  Future<UserAccount> updatePhoneNumber({required String newPhone}) async {
    FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: true);
    return await updateContent(userLive.value.uid, {"phone": newPhone}).then((value) {
      FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: false);
      return value;
    });
  }

  // Field Validators

  // Helper Methods

  /// method that adds an interaction to the database and returns a boolean whereas the interaction was added or removed.
  Future<bool> addInteraction({required UserContentInteraction interaction}) async {
    // if user exists
    if (user.isAuthenticated) {
      try {
        List<UserContentInteraction> newts = user.interactions;
        if (interaction.reversible && interaction.isOneTime) {
          newts.removeWhere((element) => element.id == interaction.id);
          await updateContent(userLive.value.uid, {'interactions': newts.map((e) => e.toMap()).toList()}).then((value) {
            userLive(value);
            userLive.refresh();
          });
          return false;
        } else {
          newts.add(interaction);
        }
        await updateContent(userLive.value.uid, {'interactions': newts.map((e) => e.toMap()).toList()}).then((value) {
          userLive(value);
          userLive.refresh();
        });
        return true;
      } catch (error) {
        FeedbackService.announce(
            notification: AppNotification.unknownError().copyWith(message: error.toString(), title: error.toString()));
        return false;
      }
    } else {
      FeedbackService.announce(
          notification: AppNotification(
              message: "",
              title: "You must sign up to be able to like,share,comment join the community!",
              type: NotificationType.warning,
              appWide: true,
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      FeedbackService.clearErrorNotification();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.black,
                      elevation: 0,
                    ),
                    key: UniqueKey(),
                    child: const Text(
                      "Later",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      try {
                       navService.routeKeepNext(AppRoutes.profile, Get.currentRoute);
                      } catch (_) {
                        Get.log(_.toString());
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.black,
                      elevation: 0,
                    ),
                    key: UniqueKey(),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              code: ResponseCode.userNotAuthenticated));
      return false;
    }
  }

  void pauseBirthdayListNotifications(String id) {
    updateContent(userLive.value.uid, {
      "silencedBirthdayLists": [...userLive.value.silencedBirthdayLists, id]
    });
  }

  void resumeBirthdayListNotifications(String id) {
    updateContent(userLive.value.uid,
        {"silencedBirthdayLists": userLive.value.silencedBirthdayLists.where((element) => element != id)});
  }

  @override
  void onContentUpdated(UserAccount content) {
    if (content != userLive.value) {
      userLive(content);
    }
  }

  Future<void> setSubscriptionPlan(SubscriptionPlan subscriptionPlan, [String promoCode = ""]) async {
    if (subscriptionPlan == SubscriptionPlan.test) {
      await updateContent(userLive.value.uid, {"subscriptionPlan": subscriptionPlan.name});
      navService.to(AppRoutes.profile);
    }
  }

  Future<bool> handlePasswordReset(String code, String continueUrl, String newPassword) async {
    try {
      String email = await auth.verifyPasswordResetCode(code);
      await auth.confirmPasswordReset(code: code, newPassword: newPassword);
      await signIn(SignInEmailRequest(email: email, password: newPassword));
      return true;
    } on FirebaseAuthException catch (error) {
      AnnounceErrors.announceErrorFromCode(error.code, error.message ?? "");
      return false;
    } catch (e) {
      AnnounceErrors.unknown(e);
      return false;
    }
  }

  Future<bool> sendVerificationCode() async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'sendEmailVerificationCode',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );

      dynamic data = (await callable.call()).data;
      VerifyEmailResponse response = VerifyEmailResponse.fromMap(data);
      if (response.succeeded) {
        return true;
      } else {
        response.announceError();
        return false;
      }
    }  on Exception catch (exception) {
      AnnounceErrors.exception(exception);
      return false;
    } catch (e) {
      AnnounceErrors.unknown(e);
      return false;
    }
  }

  Future<bool> verifyEmailCode(String code) async {
    if (Validators.authCodeValidator.announceValidation(code) == null) {
      try {
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'verifyEmailVerificationCode',
          options: HttpsCallableOptions(
            timeout: const Duration(seconds: 5),
          ),
        );
        dynamic data = (await callable.call(<String, dynamic>{
          'code': code,
        }))
            .data;
        VerifyEmailResponse response = VerifyEmailResponse.fromMap(data);

        if (response.succeeded) {
          await auth.currentUser?.reload();
          await syncOnAuthentication(auth.currentUser!);
          return true;
        } else {
          response.announceError();
          return false;
        }
      }  on Exception catch (exception) {
        AnnounceErrors.exception(exception);
        return false;
      } catch (e) {
        AnnounceErrors.unknown(e);
        return false;
      }
    } else {
      return false;
    }
  }
}

final AuthService authService = AuthService.instance;
