import 'package:celebrated/authenticate/adapter/acount.user.factory.dart';
import 'package:celebrated/authenticate/errors/app.errors.dart';
import 'package:celebrated/authenticate/models/account.dart';
import 'package:celebrated/authenticate/models/content_interaction.dart';
import 'package:celebrated/authenticate/requests/sign_up_request.dart';
import 'package:celebrated/domain/controller/validators.dart';
import 'package:celebrated/domain/service/app.initializing.state.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/model/route.guard.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/domain/model/data.validator.dart';
import 'package:celebrated/domain/repository/amen.content/repository/repository.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// manages authentication state and maintenance of Account and Auth objects of the user
class AuthService extends GetxController with ContentRepository<AccountUser, AccountUserFactory> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// pattern used for google sign in on android/ios/web:  https://petercoding.com/firebase/2021/05/24/using-google-sign-in-with-firebase-in-flutter/
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final Rx<AccountUser> accountUser = AccountUser.empty().obs;
  final RxBool isAuthenticated = false.obs;

  @override
  AccountUser get empty => AccountUser.empty();

  @override
  AccountUserFactory get docFactory => AccountUserFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference => firestore.collection('users');

  AuthService._() {
    navService.registerRouteObserver(OnRouteObserver(
      when: (route, _) => AppRoutes.profile == route && isAuthenticated.value != true,
      run: (___, __, _, rerouteTo) {
        rerouteTo(AppRoutes.authSignIn);
      },
    ));
    onInit();
  }

  static AuthService instance = AuthService._();

  @override
  void onInit() {
    super.onInit();

    auth.authStateChanges().listen((User? fireUser) async {
      InitStateController.setState(key: authLoadState, loaded: false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        /// Auth-user object is created from firebase authentication
        if (fireUser != null) {
          Get.log("Auth State Changes Triggered");
          // if (fireUser.emailVerified != true) {
          //   var actionCodeSettings = ActionCodeSettings(
          //     url: 'http://localhost:45681/emailVerified/?email=${fireUser.email}',
          //     dynamicLinkDomain: 'com.rodrickvy.celebrated',
          //     androidPackageName: 'com.rodrickvy.celebrated',
          //     androidInstallApp: true,
          //     androidMinimumVersion: '12',
          //     iOSBundleId: 'com.rodrickvy.celebrated',
          //     handleCodeInApp: true,
          //   );
          //
          //   await auth.sendSignInLinkToEmail(email: fireUser.email!, actionCodeSettings: actionCodeSettings);
          //
          //   NavController.instance.to(AppRoutes.verifyEmail);
          // }
          //
          // /// takes user to the nextTo page if one was configured when initially routing to auth
          syncOnAuthentication(fireUser);
          InitStateController.setState(key: authLoadState, loaded: true);
        } else {
          accountUser(AccountUser.empty());
          isAuthenticated(false);
          InitStateController.setState(key: authLoadState, loaded: true);
        }
      });

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
    InitStateController.setState(key: authLoadState, loaded: true);
  }

  // syncs auth user to firestore, if user is signing up a firestore object
  // for the user is created if the user is simply logging in their object's lastLogin is updated
  ///Auth User state, all listen to this for changes, empty objects means no one is signed in
  /// an attempt to fetch user data when they sign in, if the data is found
  /// its loaded , if not this is the users first login hence an [AccountUser]
  /// object is created and sent to firestore.

  // Sign Up & SignIn & Password Reset
  Future<AccountUser> createUserAccount(AccountUser user) async {
    await setContent(user);
    // if (success) {
    //   return await _syncWithFirestore(user);
    // } else {
    return user;
    // }
  }

  Future<AccountUser> signInWithEmail({required String email, required String password}) async {
    if (validateField(Validators.emailFormValidator, email) && validateField(Validators.passwordValidator, password)) {
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
        if (credential.user != null) {
          int loginTimestamp = DateTime.now().millisecondsSinceEpoch;
          return await updateContent(credential.user!.uid, {'lastLogin': loginTimestamp});
        } else {
          AnnounceErrors.updateLoginTimestampFailed();
        }
      } on FirebaseAuthException catch (error) {
        AnnounceErrors.exception(error);
      } catch (e) {
        AnnounceErrors.unknown(e);
      }
    }
    return AccountUser.empty();
  }

  Future<void> signUp(SignUpEmailRequest request) async {
    if (request.validate()) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(email: request.email, password: request.password);
        Get.log("Created user in auth");
        if (userCredential.user != null) {
          await userCredential.user!.updateDisplayName(request.name);
          Get.log("Updated user name in auth");
          final AccountUser accountData = AccountUser.mergeAuthWithRequest(userCredential.user!, request);
          await createUserAccount(accountData);
          Get.log("Created account in firestore");
        } else {
          AnnounceErrors.accountCreationFailed();
        }
      } on FirebaseAuthException catch (error) {
        AnnounceErrors.exception(error);
      } catch (e) {
        AnnounceErrors.unknown(e);
      }
    }
  }

  /// updates all local variables when authentication state has changed
  void syncOnAuthentication(User user) async {
    try {
      accountUser(await getContent(user.uid));
      isAuthenticated(true);
    } catch (_) {}
    if (Get.parameters["nextTo"] != null) {
      navService.to(NavService.instance.decodeNextToFromRoute());
    } else {
      if (AppRoutes.authRoutes.contains(Get.currentRoute)) {
        navService.to(AppRoutes.lists);
      }
    }
  }

  signInWithPopUpProvider({required provider}) async {
    try {
      await auth.signInWithPopup(provider);
    } on FirebaseAuthException catch (error) {
      AnnounceErrors.exception(error);
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
    if (validateField(Validators.emailFormValidator, email)) {
      try {
        await auth.sendPasswordResetEmail(
          email: email,
        );
        FeedbackService.successAlertSnack("Reset Email Sent! Check Your Spam Folder If You Can't Find It", 7000);
        return true;
      } on FirebaseAuthException catch (error) {
        AnnounceErrors.exception(error);
        return true;
      } catch (e) {
        AnnounceErrors.unknown(e);
        return true;
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
  Future<AccountUser> updateUserName({required String name}) async {
    if (isAuthenticated.value && validateField(Validators.userNameValidator, name) && name != accountUser.value.name) {
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

  Future<AccountUser> updateBio({required String bio}) async {
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

  Future<AccountUser> updateBirthdate({required DateTime date}) async {
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

  Future<AccountUser> updatePhoneNumber({required String newPhone}) async {
    FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: true);
    return await updateContent(accountUser.value.uid, {"phone": newPhone}).then((value) {
      FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: false);
      return value;
    });
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
  void onContentUpdated(AccountUser content) {
    if(content != accountUser.value){
      accountUser(content);
    }

  }
}

final AuthService authService = AuthService.instance;
