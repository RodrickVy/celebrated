import 'package:bremind/authenticate/adapter/acount.user.factory.dart';
import 'package:bremind/authenticate/models/account.dart';
import 'package:bremind/authenticate/models/content_interaction.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/authenticate/models/auth.user.dart';
import 'package:bremind/support/models/app.error.code.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/domain/model/data.validator.dart';
import 'package:bremind/domain/repository/amen.content/repository/repository.dart';
import 'package:bremind/support/models/notification.type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// manages authentication state and maintenance of Account and Auth objects of the user
class AuthController extends GetxController
    with ContentRepository<AccountUser, AccountUserFactory> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;


  /// pattern used for google sign in on android/ios/web:  https://petercoding.com/firebase/2021/05/24/using-google-sign-in-with-firebase-in-flutter/
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  static AuthController instance = Get.find<AuthController>();

  /// tracking user
  final Rx<AccountUser> accountUser = AccountUser.empty().obs;
  final Rx<AuthUser> user = Rx(AuthUser.empty());

  final RxBool isAuthenticated = false.obs;

  @override
  AccountUser get empty => AccountUser.empty();

  @override
  AccountUserFactory get docFactory => AccountUserFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference =>
      firestore.collection('users');

  /// validators
  Validator get userNameValidator => Validator("user-name", [
        Validation((value) => value.isNotEmpty, "User name can't be empty"),
        Validation((value) => value.length >= 3,
            "Your user-name is to short, usernames must have at-list 3 characters"),
        Validation((value) => value.length <= 40,
            "Your user-name is to long, usernames must have no  greater than 40 characters"),
      ]);

  Validator get emailFormValidator => Validator("user-name", [
        Validation((value) => value.isNotEmpty, "Email can't be empty"),
        Validation((value) => value.length >= 4,
            "Your email is invalid , its too short, emails must have at-list 3 characters"),
        Validation((value) => value.length <= 320,
            "Your email is too long , are you sure its valid? Valid emails cannot be longer than 320 chaarcters."),
      ]);

  Validator get passwordValidator => Validator("password", [
        Validation((value) => value.isNotEmpty, "Password cannot be empty"),
        Validation((value) => value.length >= 6,
            "Your password is too short and weak, try adding a number, letters and at-list a symbol"),
        Validation((value) => !value.trim().contains(" "),
            "Your password can't have spaces"),
        Validation((value) => value.length <= 100,
            "Your password is too long is to long,passwords can't exceed 100 characters"),
      ]);

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((User? fireUser) async {
      /// Auth-user object is created from firebase authentication
      if (fireUser != null) {
        user(AuthUser.fromFireAuth(fireUser));
        accountUser(await _syncWithFirestore(user.value));
        isAuthenticated(true);

        /// takes user to the nextTo page if one was configured when initially routing to auth
        if (Get.parameters["nextTo"] != null) {
          NavController.instance
              .to(NavController.instance.decodeNextToFromRoute());
        }
      } else {
        user(AuthUser.empty());
        isAuthenticated(false);
      }
    });

    /// setting all the spinners in auth-components off ,when authentication has changed!
    FeedbackService.appNotification.listen((AppNotification? error) {
      if (error != null) {
        FeedbackService.spinnerUpdateState(
            key: FeedbackSpinKeys.signUpForm, isOn: false);
        FeedbackService.spinnerUpdateState(
            key: FeedbackSpinKeys.signInForm, isOn: false);
        FeedbackService.spinnerUpdateState(
            key: FeedbackSpinKeys.authProviderButtons, isOn: false);
        FeedbackService.spinnerUpdateState(
            key: FeedbackSpinKeys.passResetForm, isOn: false);
      }
    });
  }

  // syncs auth user to firestore, if user is signing up a firestore object
  // for the user is created if the user is simply logging in their object's lastLogin is updated


  ///Auth User state, all listen to this for changes, empty objects means no one is signed in
  /// an attempt to fetch user data when they sign in, if the data is found
  /// its loaded , if not this is the users first login hence an [AccountUser]
  /// object is created and sent to firestore.
  Future<AccountUser> _syncWithFirestore(AuthUser user) async {
    try {
      return await getContent(user.uid).then((AccountUser value) async {
        int loginTimestamp = DateTime.now().millisecondsSinceEpoch;
        await updateContent(user.uid, {'lastLogin': loginTimestamp})
            .then((value) {});
        // after return the AccountUser object
        return value.copyWith(
            lastLogin: DateTime.fromMillisecondsSinceEpoch(loginTimestamp));      // found the user! meaning this is just a login in, and now updating their last login to match now

      });
    } catch (error) {
      /// if the document doesn't exist create a user object
      if (error.toString().toLowerCase().contains("not found")) {
        return createUserAccount(user);
      } else {
        FeedbackService.announce(
            notification: AppNotification.unknownError()
                .copyWith(message: error.toString(), title: error.toString()));
        return accountUser.value;
      }
    }
  }

  // Sign Up & SignIn & Password Reset
  Future<AccountUser> createUserAccount(AuthUser user) async {
    bool success = await setContent(AccountUser.fromAuthUser(user));
    if (success) {
      return await _syncWithFirestore(user);
    } else {
      return accountUser.value;
    }
  }

  signInWithEmail({required String email, required String password}) async {
    if (validateField(emailFormValidator, email) &&
        validateField(passwordValidator, password)) {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (error) {
        FeedbackService.announce(
            notification: _appNotificationFromCode(error.code)
                .copyWith(title: error.message, appWide: false));
      } catch (e) {
        FeedbackService.announce(
            notification: AppNotification.unknownError().copyWith(
                stack: e.toString(), title: e.toString(), appWide: false));
        throw e.toString();
      }
    }

  }

  signInWithPopUpProvider({required provider}) async {
    try {
      await auth.signInWithPopup(provider);
    } on FirebaseAuthException catch (error) {
      FeedbackService.announce(
          notification:
              _appNotificationFromCode(error.code).copyWith(title: error.message,appWide: false));
    } catch (e) {
      FeedbackService.announce(
          notification: AppNotification.unknownError()
              .copyWith(title: e.toString().contains("The popup has been closed")?"The google sign-in popup has been closed you didnt close it, make sure there are no add blockers blocking the popup.":e.toString(),appWide: false, stack: e.toString()));
    }
  }

  Future<void> signUpWithEmail(
      {required String name,
        required DateTime birthdate,
      required String email,
      required String password}) async {
    if (validateField(userNameValidator, name) &&
        validateField(emailFormValidator, email) &&
        validateField(passwordValidator, password)) {
      try {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          await value.user?.updateDisplayName(name);

          await updateContent(user.value.uid, {"name": name});
        });
      } on FirebaseAuthException catch (error) {

        FeedbackService.announce(
            notification:
                _appNotificationFromCode(error.code).copyWith(title: error.message));

      } catch (e) {
        Get.log(e.toString());
        FeedbackService.announce(
            notification: AppNotification.unknownError()
                .copyWith(title: e.toString(), stack: e.toString()));
      }
    }


  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      FeedbackService.announce(
          notification: _appNotificationFromCode(error.code).copyWith(
        title: error.message,
        appWide: false,
      ));
    } catch (e) {
      FeedbackService.announce(
          notification: AppNotification.unknownError().copyWith(
        appWide: false,
        stack: e.toString(),
        title: e.toString(),
      ));
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await auth.signOut();
  }

  Future<bool> sendPasswordResetEmail({required String email}) async {
    if (validateField(emailFormValidator, email)) {
      try {
        await auth.sendPasswordResetEmail(
          email: email,
        );
        FeedbackService.successAlertSnack("Reset Email Sent! Check Your Spam Folder If You Can't Find It",7000);
        return true;
      } on FirebaseAuthException catch (error) {
        FeedbackService.announce(
            notification: _appNotificationFromCode(error.code).copyWith(
          title: error.message,
          appWide: false,
        ));
        return true;
      } catch (e) {
        FeedbackService.announce(
            notification: AppNotification.unknownError().copyWith(
          appWide: false,
          stack: e.toString(),
          title: e.toString(),
        ));
        return true;
      }
    }else{
      FeedbackService.announce(
          notification: AppNotification.unknownError().copyWith(
            appWide: false,
            title: emailFormValidator.validate(email),
          ));
      return true;
    }
  }

  Future<void> logout() async {
    try {
      ///to do enable this for google auth
      // await _googleSignIn.signOut();
      await auth.signOut();
      NavController.instance.to(AppRoutes.authSignIn);
    } on FirebaseAuthException catch (error) {
      FeedbackService.announce(
          notification: _appNotificationFromCode(error.code)
              .copyWith(appWide: false, message: error.message));
    } catch (e) {
      FeedbackService.announce(
          notification: AppNotification.unknownError()
              .copyWith(appWide: false, stack: e.toString()));
    }
  }

  // Editing Profile
  Future<AccountUser> updateUserName({required String name}) async {
    if (isAuthenticated.value &&
        validateField(userNameValidator, name) &&
        name != accountUser.value.name) {
      try {
        return await updateContent(user.value.uid, {'name': name})
            .then((value) {
          accountUser(value);
          accountUser.refresh();
          return value;
        });
      } catch (error) {
        FeedbackService.announce(
            notification: AppNotification.unknownError()
                .copyWith(message: error.toString(), title: error.toString()));
        return accountUser.value;
      }
    }
    return accountUser.value;
  }

  Future<AccountUser> updateBio({required String bio}) async {
    if (isAuthenticated.value && bio != accountUser.value.bio) {
      try {
        return await updateContent(user.value.uid, {'bio': bio}).then((value) {
          accountUser(value);
          accountUser.refresh();
          return value;
        });
      } catch (error) {
        FeedbackService.announce(
            notification: AppNotification.unknownError()
                .copyWith(message: error.toString(), title: error.toString()));
        return accountUser.value;
      }
    }
    return accountUser.value;
  }


  Future<AccountUser> updateBirthdate({required DateTime date}) async {
      try {
        return await updateContent(user.value.uid, {'birthdate': date.millisecondsSinceEpoch})
            .then((value) {
          accountUser(value);
          accountUser.refresh();
          return value;
        });
      } catch (error) {
        FeedbackService.announce(
            notification: AppNotification.unknownError()
                .copyWith(message: error.toString(), title: error.toString()));
        return accountUser.value;
      }
  }
  // Field Validators

  bool validateField(Validator validator, String value) {
    if (validator.validate(value) != null) {
      FeedbackService.announce(
        notification: validator.asError(value).copyWith(appWide: false),
      );
      return false;
    }
    return true;
  }

  // Helper Methods

  ResponseCode ___errorToResponseCode<T>(String name, List<T> list) {
    String validCode =
        name.split("/").last.toLowerCase().split("-").join("").trim();
    try {
      return ResponseCode.values.firstWhere((code) =>
          describeEnum(code).toLowerCase().trim() == validCode.toLowerCase());
    } catch (_) {
      return ResponseCode.unknownError;
    }
  }

  AppNotification _appNotificationFromCode(String code) {
    ResponseCode errorCode =
        ___errorToResponseCode<ResponseCode>(code, ResponseCode.values);
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

  /// method that adds an interaction to the database and returns a boolean wheatehr the interaction was added or removed.
  Future<bool> addInteraction(
      {required UserContentInteraction interaction}) async {
    // if user exists
    if (isAuthenticated.value && !accountUser.value.isEmpty()) {
      try {
        ///
        List<UserContentInteraction> newts = accountUser.value.interactions;
        if (!accountUser.value.interactions.contains(interaction)) {
          newts = [...accountUser.value.interactions, interaction];
        } else if (interaction.isOneTimeReversibleAction()) {
          newts.removeWhere((element) => element.id == interaction.id);
          await updateContent(user.value.uid, {
            'interactions': newts.map((e) => e.toMap()).toList()
          }).then((value) {
            accountUser(value);
            accountUser.refresh();
          });
          return false;
        } else {
          newts = [...accountUser.value.interactions, interaction];
        }
        await updateContent(user.value.uid, {
          'interactions': newts.map((e) => e.toMap()).toList()
        }).then((value) {
          accountUser(value);
          accountUser.refresh();
        });
        return true;
      } catch (error) {
        FeedbackService.announce(
            notification: AppNotification.unknownError()
                .copyWith(message: error.toString(), title: error.toString()));
        return false;
      }
    } else {
      FeedbackService.announce(
          notification: AppNotification(
              message: "",
              title:
              "You must sign up to be able to like,share,comment join the community!",
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
                        String route = NavController.instance
                            .addNextToOnRoute(AppRoutes.auth, Get.currentRoute);
                        await NavController.instance.to(route);
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
}

///
///
