import 'package:celebrated/authenticate/adapter/acount.user.factory.dart';
import 'package:celebrated/authenticate/errors/app.errors.dart';
import 'package:celebrated/authenticate/models/account.dart';
import 'package:celebrated/authenticate/models/content_interaction.dart';
import 'package:celebrated/authenticate/requests/sign_up_request.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/navigation/model/route.guard.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/authenticate/models/auth.user.dart';
import 'package:celebrated/support/controller/support.controller.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/domain/model/data.validator.dart';
import 'package:celebrated/domain/repository/amen.content/repository/repository.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// manages authentication state and maintenance of Account and Auth objects of the user
class AuthController extends GetxController with ContentRepository<AccountUser, AccountUserFactory> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// pattern used for google sign in on android/ios/web:  https://petercoding.com/firebase/2021/05/24/using-google-sign-in-with-firebase-in-flutter/
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  static AuthController instance = Get.find<AuthController>();

  /// tracking user
  final Rx<AccountUser> accountUser = AccountUser.empty().obs;

  // final Rx<AuthUser> user = Rx(AuthUser.empty());

  final RxBool isAuthenticated = false.obs;

  @override
  AccountUser get empty => AccountUser.empty();

  @override
  AccountUserFactory get docFactory => AccountUserFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference => firestore.collection('users');

  /// validators
  Validator get userNameValidator => Validator("user-name", [
        Validation((value) => value.isNotEmpty, "User name can't be empty"),
        Validation(
            (value) => value.length >= 3, "Your user-name is to short, usernames must have at-list 3 characters"),
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
        Validation((value) => !value.trim().contains(" "), "Your password can't have spaces"),
        Validation((value) => value.length <= 100,
            "Your password is too long is to long,passwords can't exceed 100 characters"),
      ]);

  Validator get phoneValidator => Validator("phone", [
        Validation((value) => value.isNotEmpty, "Phone number cannot be empty"),
        Validation((value) => value.length >= 5, "Invalid phone number"),
      ]);

  @override
  void onInit() {
    super.onInit();

    NavController.instance.registerRouteObserver(OnRouteObserver(
      when: (route, _) => AppRoutes.authRoutes.contains(route),
      run: (String route, Map<String, String?> parameters, Function cancel) {
        if (isAuthenticated.value != true) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            Get.toNamed(AppRoutes.authSignIn);
          });
        } else {
          if (route != AppRoutes.profile) {
            Get.toNamed(AppRoutes.profile);
          }
        }
      },
    ));
    FirebaseAuth.instance.authStateChanges().listen((User? fireUser) async {
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

          updateAppAuthState(fireUser);
        } else {
          accountUser(AccountUser.empty());
          isAuthenticated(false);
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
        await updateContent(user.uid, {'lastLogin': loginTimestamp}).then((value) {});
        // after return the AccountUser object
        return value.copyWith(
            lastLogin: DateTime.fromMillisecondsSinceEpoch(
                loginTimestamp)); // found the user! meaning this is just a login in, and now updating their last login to match now
      });
    } catch (error) {
      /// if the document doesn't exist create a user object
      if (error.toString().toLowerCase().contains("not found")) {
        return createUserAccount(AccountUser.empty());
      } else {
        FeedbackService.announce(
            notification: AppNotification.unknownError().copyWith(message: error.toString(), title: error.toString()));
        return accountUser.value;
      }
    }
  }

  // Sign Up & SignIn & Password Reset
  Future<AccountUser> createUserAccount(AccountUser user) async {
    await setContent(user);
    // if (success) {
    //   return await _syncWithFirestore(user);
    // } else {
    return user;
    // }
  }

  signInWithEmail({required String email, required String password}) async {
    if (validateField(emailFormValidator, email) && validateField(passwordValidator, password)) {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (error) {
        AnnounceErrors.exception(error);
      } catch (e) {
        AnnounceErrors.unknown(e);
      }
    }
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

  void updateAppAuthState(User user) async {
    try {
      accountUser(await getContent(user.uid));
      isAuthenticated(true);
    } catch (_) {}
    if (Get.parameters["nextTo"] != null) {
      NavController.instance.to(NavController.instance.decodeNextToFromRoute());
    } else {
      if(AppRoutes.authRoutes.contains(Get.currentRoute)){
        NavController.instance.to(AppRoutes.lists);
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

  Future<void> signUpWithEmail(
      {required String name,
      required DateTime birthdate,
      required String email,
      required String password,
      required String phone}) async {
    if (validateField(userNameValidator, name) &&
        validateField(emailFormValidator, email) &&
        validateField(passwordValidator, password) &&
        validateField(phoneValidator, phone)) {
      try {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((UserCredential userCredential) async {
          if (userCredential.user != null) {
            await userCredential.user!.updateDisplayName(name).then((value) async {
              final AuthUser authUser = AuthUser.fromFireAuth(userCredential.user);
              final AccountUser accountData = AccountUser.fromUser(userCredential.user!);
              await createUserAccount(accountData.copyWith(
                phone: phone,
                email: email,
                birthdate: birthdate,
              ));
              // user(authUser);
              accountUser(accountData);
              isAuthenticated(true);
            });
          } else {
            FeedbackService.announce(
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
                key: UniqueKey(),
              ),
              canDismiss: true,
              type: NotificationType.error,
            ));
          }
        });
      } on FirebaseAuthException catch (error) {
        AnnounceErrors.exception(error);
      } catch (e) {
        AnnounceErrors.unknown(e);
      }
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
    if (validateField(emailFormValidator, email)) {
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
    } else {
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
      await auth.signOut();
      NavController.instance.to(AppRoutes.authSignIn);
    } on FirebaseAuthException catch (error) {
      AnnounceErrors.exception(error);
    } catch (e) {
      AnnounceErrors.unknown(e);
    }
  }

  // Editing Profile
  Future<AccountUser> updateUserName({required String name}) async {
    if (isAuthenticated.value && validateField(userNameValidator, name) && name != accountUser.value.name) {
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
                        String route = NavController.instance.addNextToOnRoute(AppRoutes.profile, Get.currentRoute);
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
