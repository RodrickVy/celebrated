import 'package:celebrated/authenticate/adapter/user.acount.factory.dart';
import 'package:celebrated/authenticate/models/account.dart';
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
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// manages authentication state and maintenance of Account and Auth objects of the user
class AuthService extends GetxController with ContentStore<UserAccount, AccountUserFactory> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// pattern used for google sign in on android/ios/web:  https://petercoding.com/firebase/2021/05/24/using-google-sign-in-with-firebase-in-flutter/
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final Rx<UserAccount> accountUser = UserAccount.empty().obs;
  final RxBool isAuthenticated = false.obs;

  @override
  UserAccount get empty => UserAccount.empty();

  @override
  AccountUserFactory get docFactory => AccountUserFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference => firestore.collection('users');

  AuthService._() {
    navService.registerRouteObserver(OnRouteObserver(
      when: (route, _) => AppRoutes.profile == route,
      run: (___, __, _, rerouteTo) {
        if (isAuthenticated.value == true && accountUser.value.emailVerified == false) {
          rerouteTo(AppRoutes.verifyEmail);
        } else if (isAuthenticated.value != true) {
          rerouteTo(AppRoutes.authSignIn);
        }
      },
    ));
    auth.authStateChanges().listen((User? fireUser) async {
      // InitStateController.setState(key: authLoadState, loaded: false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        /// Auth-user object is created from firebase authentication
        if (fireUser != null) {
          Get.log("Auth State Changes Triggered");
          await syncOnAuthentication(fireUser);
          if (fireUser.emailVerified != true && !Get.currentRoute.contains(AppRoutes.authActions)) {
            navService.to(AppRoutes.verifyEmail);
          }

          // InitStateController.setState(key: authLoadState, loaded: true);
        } else {
          accountUser(UserAccount.empty());
          isAuthenticated(false);
          // InitStateController.setState(key: authLoadState, loaded: true);
        }
      });
      Get.log("Auth state changes triggered");

      /// setting all the spinners in auth-components off ,when authentication has changed!
      FeedbackService.appNotification.listen((AppNotification? error) {
        if (error != null) {
          FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: false);
          FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signInForm, isOn: false);
          FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.authProviderButtons, isOn: false);
          FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.passResetForm, isOn: false);
        }
      });
    });
  }

  static AuthService instance = AuthService._();

  // syncs auth user to firestore, if user is signing up a firestore object
  // for the user is created if the user is simply logging in their object's lastLogin is updated
  ///Auth User state, all listen to this for changes, empty objects means no one is signed in
  /// an attempt to fetch user data when they sign in, if the data is found
  /// its loaded , if not this is the users first login hence an [UserAccount]
  /// object is created and sent to firestore.

  // Sign Up & SignIn & Password Reset
  Future<UserAccount> createUserAccount(UserAccount user) async {
    await setContent(user);
    // if (success) {
    //   return await _syncWithFirestore(user);
    // } else {
    return user;
    // }
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
          Get.log("Updated user: passed ${credential.user!.uid}");
          return await updateContent(credential.user!.uid, {'lastLogin': loginTimestamp,"emailVerified": credential.user!.emailVerified});
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
    return UserAccount.empty();
  }

  /// updates all local variables when authentication state has changed
  Future<void> syncOnAuthentication(User user) async {
    try {
      if (user.emailVerified == true && accountUser.value.emailVerified == false) {
        await updateContent(user.uid, {"emailVerified": true});
      }
      accountUser(await getContent(user.uid));

      isAuthenticated(true);
      if (user.emailVerified == true && accountUser.value.subscriptionPlan == SubscriptionPlan.none) {
        navService.to(AppRoutes.subscriptions);
      }
      if (Get.parameters["nextTo"] != null) {
        navService.to(NavService.instance.decodeNextToFromRoute());
      } else {
        print("${Get.currentRoute.split("?").first} || ${AppRoutes.authRoutes}");
        if (AppRoutes.authRoutes.contains(Get.currentRoute.split("?").first)) {
          navService.to(AppRoutes.lists);
        }
      }
    } catch (_) {
      // AnnounceErrors.unknown(_);
    }
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
    if (isAuthenticated.value &&
        Validators.validateField(Validators.userNameValidator, name) &&
        name != accountUser.value.name) {
      try {
        return await updateContent(accountUser.value.uid, {'name': name}).then((value) {
          accountUser(value);
          accountUser.refresh();
          return value;
        });
      } catch (error) {
        FeedbackService.announce(
            notification: AppNotification.unknownError().copyWith(message: error.toString(), title: error.toString()));
        return accountUser.value;
      }
    }
    return accountUser.value;
  }

  Future<UserAccount> updateBio({required String bio}) async {
    if (isAuthenticated.value && bio != accountUser.value.bio) {
      try {
        return await updateContent(accountUser.value.uid, {'bio': bio}).then((value) {
          accountUser(value);
          accountUser.refresh();
          return value;
        });
      } catch (error) {
        FeedbackService.announce(
            notification: AppNotification.unknownError().copyWith(message: error.toString(), title: error.toString()));
        return accountUser.value;
      }
    }
    return accountUser.value;
  }

  Future<UserAccount> updateBirthdate({required DateTime date}) async {
    try {
      return await updateContent(accountUser.value.uid, {'birthdate': date.millisecondsSinceEpoch}).then((value) {
        accountUser(value);
        accountUser.refresh();
        return value;
      });
    } catch (error) {
      FeedbackService.announce(
          notification: AppNotification.unknownError().copyWith(message: error.toString(), title: error.toString()));
      return accountUser.value;
    }
  }

  Future<UserAccount> updatePhoneNumber({required String newPhone}) async {
    FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: true);
    return await updateContent(accountUser.value.uid, {"phone": newPhone}).then((value) {
      FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: false);
      return value;
    });
  }

  // Field Validators

  // Helper Methods

  /// method that adds an interaction to the database and returns a boolean whereas the interaction was added or removed.
  Future<bool> addInteraction({required UserContentInteraction interaction}) async {
    // if user exists
    if (isAuthenticated.value && !accountUser.value.isEmpty()) {
      try {
        ///
        List<UserContentInteraction> newts = accountUser.value.interactions;
        if (!accountUser.value.interactions.contains(interaction)) {
          newts = [...accountUser.value.interactions, interaction];
        } else if (interaction.isOneTimeReversibleAction()) {
          newts.removeWhere((element) => element.id == interaction.id);
          await updateContent(accountUser.value.uid, {'interactions': newts.map((e) => e.toMap()).toList()})
              .then((value) {
            accountUser(value);
            accountUser.refresh();
          });
          return false;
        } else {
          newts = [...accountUser.value.interactions, interaction];
        }
        await updateContent(accountUser.value.uid, {'interactions': newts.map((e) => e.toMap()).toList()})
            .then((value) {
          accountUser(value);
          accountUser.refresh();
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
                        String route = navService.addNextToOnRoute(AppRoutes.profile, Get.currentRoute);
                        await navService.to(route);
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
    updateContent(accountUser.value.uid, {
      "silencedBirthdayLists": [...accountUser.value.silencedBirthdayLists, id]
    });
  }

  void resumeBirthdayListNotifications(String id) {
    updateContent(accountUser.value.uid,
        {"silencedBirthdayLists": accountUser.value.silencedBirthdayLists.where((element) => element != id)});
  }

  @override
  void onContentUpdated(UserAccount content) {
    if (content != accountUser.value) {
      accountUser(content);
    }
  }

  setSubscriptionPlan(SubscriptionPlan subscriptionPlan, [String promoCode = ""]) {
    if (subscriptionPlan == SubscriptionPlan.test) {
      updateContent(accountUser.value.uid, {"subscriptionPlan": subscriptionPlan.name});
      navService.to(AppRoutes.profile);
    }
  }

  /// send verification of email to user and returns weather the users email is verified
  Future<bool> verifyUsersEmail() async {
    if (accountUser.value.emailVerified == true) {
      return true;
    }

    // var acs = ActionCodeSettings(
    //     // URL you want to redirect back to. The domain (www.example.com) for this
    //     // URL must be whitelisted in the Firebase Console.
    //     url: 'https://celebrated-app.web.app/actions?email',
    //     // This must be true
    //     handleCodeInApp: true,
    //     iOSBundleId: 'com.rodrickvy.celebrated',
    //     androidPackageName: 'com.rodrickvy.celebrated',
    //     // installIfNotAvailable
    //     androidInstallApp: true,
    //     // minimumVersion
    //     androidMinimumVersion: '12');

    if (Validators.validateField(Validators.emailFormValidator, accountUser.value.email)) {
      try {
        auth.currentUser?.sendEmailVerification();
        // FeedbackService.successAlertSnack("Reset Email Sent! Check Your Spam Folder If You Can't Find It", 7000);
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
  Future<bool> handleEmailVerifiedAction(String actionCode, String continueUrl) async {
    try {
      await auth.applyActionCode(actionCode);
      Get.reload(force: true);
      if (isAuthenticated.isTrue && auth.currentUser != null) {
        syncOnAuthentication(auth.currentUser!);
      }
      return true;
    } on FirebaseAuthException catch (error) {
      AnnounceErrors.announceErrorFromCode(error.code, error.message ?? "");
      return false;
    } catch (e) {
      AnnounceErrors.unknown(e);
      return false;
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
}

final AuthService authService = AuthService.instance;
