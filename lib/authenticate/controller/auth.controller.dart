import 'package:bremind/account/adapter/acount.user.factory.dart';
import 'package:bremind/account/models/account.dart';
import 'package:bremind/account/models/content_interaction.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/authenticate/interface/auth.controller.interface.dart';
import 'package:bremind/authenticate/models/auth.user.dart';
import 'package:bremind/authenticate/models/auth.with.dart';
import 'package:bremind/support/models/app.error.code.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/domain/model/data.validator.dart';
import 'package:bremind/domain/repository/amen.content/repository/repository.dart';
import 'package:bremind/support/models/notification.type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController
    with ContentRepository<AccountUser, AccountUserFactory>
    implements IAuthController {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static AuthController instance = Get.find<AuthController>();

  @override
  final AccountUser empty = AccountUser.empty();

  @override
  final AccountUserFactory docFactory = AccountUserFactory();

  @override
  final CollectionReference<Map<String, dynamic>> collectionReference =
      firestore.collection('users');

  ///Auth User
  @override
  final Rx<AuthUser> user = Rx(AuthUser.empty());

  /// Account User
  @override
  final Rx<AccountUser> accountUser = AccountUser.empty().obs;

  @override
  Future<AccountUser> attemptFetchUserAccount(AuthUser user) async {
    try {
      return await getContent(user.uid).then((AccountUser value) async {
        int loginTimestamp = DateTime.now().millisecondsSinceEpoch;
        // found the user! meaning this is just a login in, and now updating their last login to match now
        await updateContent(user.uid, {'lastLogin': loginTimestamp})
            .then((value) {});
        // after return the AccountUser object
        return value.copyWith(
            lastLogin: DateTime.fromMillisecondsSinceEpoch(loginTimestamp));
      });
    } catch (error) {
      /// if the document doesnt exist create a user object
      if (error.toString().toLowerCase().contains("not found")) {
        return createUserAccount(user);
      } else {
        FeedbackController.announce(
            notification: AppNotification.unknownError()
                .copyWith(message: error.toString(), title: error.toString()));
        return accountUser.value;
      }
    }
  }

  @override
  Future<AccountUser> createUserAccount(AuthUser user) async {
    bool success = await setContent(AccountUser(
        claims: {},
        timeCreated: DateTime.now(),
        interactions: [],
        bio: "",
        name: user.userName,
        emailVerified: user.emailVerified,
        uid: user.uid,
        lastLogin: DateTime.now(),
        authMethod: AuthWith.Password,
        avatar: user.avatar,
        displayName: user.userName,
        providerId: "",
        email: user.email,
        photoUrl: user.avatar,
        phone: user.phoneNumber ?? ""));
    if (success) {
      return await attemptFetchUserAccount(user);
    } else {
      return accountUser.value;
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  final RxBool isAuthenticated = false.obs;

  @override
  signInWithEmail({required String email, required String password}) async {
    if (validateField(emailFormValidator, email) &&
        validateField(passwordValidator, password)) {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (error) {
        FeedbackController.announce(
            notification: _authErrorFromCode(error.code)
                .copyWith(title: error.message, appWide: false));
      } catch (e) {
        FeedbackController.announce(
            notification: AppNotification.unknownError().copyWith(
                stack: e.toString(), title: e.toString(), appWide: false));
        throw e.toString();
      }
    }
  }

  @override
  signInWithPopUpProvider({required provider}) async {
    try {
      await auth.signInWithPopup(provider);
    } on FirebaseAuthException catch (error) {
      FeedbackController.announce(
          notification:
              _authErrorFromCode(error.code).copyWith(title: error.message));
    } catch (e) {
      FeedbackController.announce(
          notification: AppNotification.unknownError()
              .copyWith(title: e.toString(), stack: e.toString()));
    }
  }

  @override
  signUpWithEmail(
      {required String name,
      required String email,
      required String password}) async {
    if (validateField(userNameValidator, name) &&
        validateField(emailFormValidator, email) &&
        validateField(passwordValidator, password)) {
      try {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          value.user?.updateDisplayName(name);
        });
      } on FirebaseAuthException catch (error) {
        FeedbackController.announce(
            notification:
                _authErrorFromCode(error.code).copyWith(title: error.message));
      } catch (e) {
        FeedbackController.announce(
            notification: AppNotification.unknownError()
                .copyWith(title: e.toString(), stack: e.toString()));
      }
    }
  }

  @override
  signUpWithPopUpProvider({required provider}) async {
    try {
      await signInWithPopUpProvider(provider: provider);
    } on FirebaseAuthException catch (error) {
      FeedbackController.announce(
          notification: _authErrorFromCode(error.code)
              .copyWith(appWide: false, title: error.message));
    } catch (e) {
      FeedbackController.announce(
          notification: AppNotification.unknownError().copyWith(
              appWide: false, stack: e.toString(), title: e.toString()));
    }
  }

  @override
  sendPasswordResetEmail({required String email}) async {
    if (validateField(emailFormValidator, email)) {
      try {
        await auth.sendPasswordResetEmail(
          email: email,
        );
      } on FirebaseAuthException catch (error) {
        FeedbackController.announce(
            notification: _authErrorFromCode(error.code).copyWith(
          title: error.message,
          appWide: false,
        ));
      } catch (e) {
        FeedbackController.announce(
            notification: AppNotification.unknownError().copyWith(
          appWide: false,
          stack: e.toString(),
          title: e.toString(),
        ));
      }
    }
  }

  @override
  logout() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (error) {
      FeedbackController.announce(
          notification: _authErrorFromCode(error.code)
              .copyWith(appWide: false, message: error.message));
    } catch (e) {
      FeedbackController.announce(
          notification: AppNotification.unknownError()
              .copyWith(appWide: false, stack: e.toString()));
    }
  }

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((User? fireUser) async {
      if (fireUser != null) {
        user(AuthUser(
            userName: fireUser.displayName ?? "",
            email: fireUser.email ?? "",
            uid: fireUser.uid,
            emailVerified: fireUser.emailVerified,
            isAnonymous: fireUser.isAnonymous,
            phoneNumber: fireUser.phoneNumber,
            authWith: fireUser.providerData.first.providerId,
            password: "",
            avatar: fireUser.photoURL ??
                "assets/defualt_icons/avatar_outline.png"));
        accountUser(await attemptFetchUserAccount(user.value));
        isAuthenticated(true);
        if (Get.parameters["nextTo"] != null) {
          Get.toNamed(NavController.instance.decodeNextToFromRoute());
        } else {
          Get.toNamed(AppRoutes.home);
        }
      } else {
        user(AuthUser.empty());
        isAuthenticated(false);
        NavController.instance.to(AppRoutes.auth);
      }
    });

    FeedbackController.appNotification.listen((AppNotification? error) {
      if (error != null) {
        FeedbackController.spinnerUpdateState(
            key: AfroSpinKeys.signUpForm, isOn: false);
        FeedbackController.spinnerUpdateState(
            key: AfroSpinKeys.signInForm, isOn: false);
        FeedbackController.spinnerUpdateState(
            key: AfroSpinKeys.authProviderButtons, isOn: false);
        FeedbackController.spinnerUpdateState(
            key: AfroSpinKeys.passResetForm, isOn: false);
      }
    });
  }

  AppErrorCodes codeToFirebaseCode<T>(String name, List<T> list) {
    String _validCode =
        name.split("/").last.toLowerCase().split("-").join("").trim();
    try {
      return AppErrorCodes.values.firstWhere((code) =>
          describeEnum(code).toLowerCase().trim() == _validCode.toLowerCase());
    } catch (_) {
      return AppErrorCodes.unknownError;
    }
  }

  AppNotification _authErrorFromCode(String code) {
    AppErrorCodes errorCode =
        codeToFirebaseCode<AppErrorCodes>(code, AppErrorCodes.values);
    switch (errorCode) {
      case AppErrorCodes.unknownError:
        return AppNotification.unknownError();
      case AppErrorCodes.invalidRequest:
        return AppNotification.invalidRequest();

      case AppErrorCodes.invalidResponse:
        return AppNotification.invalidResponse();

      case AppErrorCodes.claimsTooLarge:
        return AppNotification.claimsTooLarge();

      case AppErrorCodes.emailAlreadyExists:
        return AppNotification.emailAlreadyExists();

      case AppErrorCodes.idTokenExpired:
        return AppNotification.idTokenExpired();

      case AppErrorCodes.idTokenRevoked:
        return AppNotification.idTokenRevoked();

      case AppErrorCodes.insufficientPermission:
        return AppNotification.insufficientPermission();

      case AppErrorCodes.internalError:
        return AppNotification.internalError();

      case AppErrorCodes.invalidArgument:
        return AppNotification.invalidArgument();

      case AppErrorCodes.invalidClaims:
        return AppNotification.invalidClaims();

      case AppErrorCodes.invalidContinueUri:
        return AppNotification.invalidContinueUri();

      case AppErrorCodes.invalidCreationTime:
        return AppNotification.invalidCreationTime();

      case AppErrorCodes.invalidCredential:
        return AppNotification.invalidCredential();

      case AppErrorCodes.invalidDisabledField:
        return AppNotification.invalidDisabledField();

      case AppErrorCodes.invalidDisplayName:
        return AppNotification.invalidDisplayName();

      case AppErrorCodes.invalidDynamicLinkDomain:
        return AppNotification.invalidDynamicLinkDomain();

      case AppErrorCodes.invalidEmail:
        return AppNotification.invalidEmail();

      case AppErrorCodes.invalidEmailVerified:
        return AppNotification.invalidEmailVerified();

      case AppErrorCodes.invalidHashAlgorithm:
        return AppNotification.invalidHashAlgorithm();

      case AppErrorCodes.invalidHashBlockSize:
        return AppNotification.invalidHashBlockSize();

      case AppErrorCodes.invalidHashDerivedKeyLength:
        return AppNotification.invalidHashDerivedKeyLength();

      case AppErrorCodes.invalidHashKey:
        return AppNotification.invalidHashKey();

      case AppErrorCodes.invalidHashMemoryCost:
        return AppNotification.invalidHashMemoryCost();

      case AppErrorCodes.invalidHashParallelization:
        return AppNotification.invalidHashParallelization();

      case AppErrorCodes.invalidHashRounds:
        return AppNotification.invalidHashRounds();

      case AppErrorCodes.invalidHashSaltSeparator:
        return AppNotification.invalidHashSaltSeparator();

      case AppErrorCodes.invalidIdToken:
        return AppNotification.invalidIdToken();

      case AppErrorCodes.invalidLastSignInTime:
        return AppNotification.invalidLastSignInTime();

      case AppErrorCodes.invalidPageToken:
        return AppNotification.invalidPageToken();

      case AppErrorCodes.invalidPassword:
        return AppNotification.invalidPassword();

      case AppErrorCodes.invalidPasswordHash:
        return AppNotification.invalidPasswordHash();

      case AppErrorCodes.invalidPasswordSalt:
        return AppNotification.invalidPasswordSalt();

      case AppErrorCodes.invalidPhoneNumber:
        return AppNotification.invalidPhoneNumber();

      case AppErrorCodes.invalidPhotoUrl:
        return AppNotification.invalidPhotoUrl();

      case AppErrorCodes.invalidProviderData:
        return AppNotification.invalidProviderData();

      case AppErrorCodes.invalidProviderId:
        return AppNotification.invalidProviderId();

      case AppErrorCodes.invalidSessionCookieDuration:
        return AppNotification.invalidSessionCookieDuration();

      case AppErrorCodes.invalidUid:
        return AppNotification.invalidUid();

      case AppErrorCodes.invalidUserImport:
        return AppNotification.invalidUserImport();

      case AppErrorCodes.maximumUserCountExceeded:
        return AppNotification.maximumUserCountExceeded();

      case AppErrorCodes.missingAndroidPkgName:
        return AppNotification.missingAndroidPkgName();

      case AppErrorCodes.missingContinueUri:
        return AppNotification.missingContinueUri();

      case AppErrorCodes.missingHashAlgorithm:
        return AppNotification.missingHashAlgorithm();

      case AppErrorCodes.missingIosBundleId:
        return AppNotification.missingIosBundleId();

      case AppErrorCodes.missingUid:
        return AppNotification.missingUid();

      case AppErrorCodes.operationNotAllowed:
        return AppNotification.operationNotAllowed();

      case AppErrorCodes.phoneNumberAlreadyExists:
        return AppNotification.phoneNumberAlreadyExists();

      case AppErrorCodes.projectNotFound:
        return AppNotification.projectNotFound();

      case AppErrorCodes.reservedClaims:
        return AppNotification.reservedClaims();

      case AppErrorCodes.sessionCookieExpired:
        return AppNotification.sessionCookieExpired();

      case AppErrorCodes.sessionCookieRevoked:
        return AppNotification.sessionCookieRevoked();

      case AppErrorCodes.uidAlreadyExists:
        return AppNotification.uidAlreadyExists();

      case AppErrorCodes.unauthorizedContinueUri:
        return AppNotification.unauthorizedContinueUri();
      case AppErrorCodes.userNotFound:
        return AppNotification.userNotFound();
      case AppErrorCodes.userNotAuthenticated:
        return AppNotification.userNotAuthenticated();
      default:
        return AppNotification.unknownError();
    }
  }

  /// validators

  @override
  Validator get userNameValidator => Validator("user-name", [
        Validation((value) => value.isNotEmpty, "User name can't be empty"),
        Validation((value) => value.length >= 3,
            "Your user-name is to short, usernames must have at-list 3 characters"),
        Validation((value) => value.length <= 40,
            "Your user-name is to long, usernames must have no  greater than 40 characters"),
      ]);

  @override
  Validator get emailFormValidator => Validator("user-name", [
        Validation((value) => value.isNotEmpty, "Email can't be empty"),
        Validation((value) => value.length >= 4,
            "Your email is invalid , its too short, emails must have at-list 3 characters"),
        Validation((value) => value.length <= 320,
            "Your email is too long , are you sure its valid? Valid emails cannot be longer than 320 chaarcters."),
      ]);

  @override
  Validator get passwordValidator => Validator("password", [
        Validation((value) => value.isNotEmpty, "Password cannot be empty"),
        Validation((value) => value.length >= 6,
            "Your password is too short and weak, try adding a number, letters and at-list a symbol"),
        Validation((value) => !value.trim().contains(" "),
            "Your password can't have spaces"),
        Validation((value) => value.length <= 100,
            "Your password is too long is to long,passwords can't exceed 100 characters"),
      ]);

  bool validateField(Validator validator, String value) {
    if (validator.validate(value) != null) {
      FeedbackController.announce(
        notification: validator.asError(value).copyWith(appWide: false),
      );
      return false;
    }
    return true;
  }

  @override
  updateUserName({required String name}) async {
    if (isAuthenticated.value &&
        validateField(userNameValidator, name) &&
        name != accountUser.value.name) {
      try {
        return await updateContent(user.value.uid, {'name': name})
            .then((value) {
          accountUser(value);
          accountUser.refresh();
        });
      } catch (error) {
        FeedbackController.announce(
            notification: AppNotification.unknownError()
                .copyWith(message: error.toString(), title: error.toString()));
        return accountUser.value;
      }
    }
    return accountUser.value;
  }

  @override
  updateBio({required String bio}) async {
    if (isAuthenticated.value && bio != accountUser.value.bio) {
      try {
        return await updateContent(user.value.uid, {'bio': bio}).then((value) {
          accountUser(value);
          accountUser.refresh();
        });
      } catch (error) {
        FeedbackController.announce(
            notification: AppNotification.unknownError()
                .copyWith(message: error.toString(), title: error.toString()));
        return accountUser.value;
      }
    }
    return accountUser.value;
  }

  /// method that adds an interaction to the database and returns a boolean wheatehr the interaction was added or removed.
  Future<bool> addInteraction(
      {required UserContentInteraction interaction}) async {
    // if user exists
    if (isAuthenticated.value && !accountUser.value.isEmpty()) {
      try {
        ///
        List<UserContentInteraction> _newts = accountUser.value.interactions;
        if (!accountUser.value.interactions.contains(interaction)) {
          _newts = [...accountUser.value.interactions, interaction];
        } else if (interaction.isOneTimeReversibleAction()) {
          _newts.removeWhere((element) => element.id == interaction.id);
          await updateContent(user.value.uid, {
            'interactions': _newts.map((e) => e.toMap()).toList()
          }).then((value) {
            accountUser(value);
            accountUser.refresh();
          });
          return false;
        } else {
          _newts = [...accountUser.value.interactions, interaction];
        }
        await updateContent(user.value.uid, {
          'interactions': _newts.map((e) => e.toMap()).toList()
        }).then((value) {
          accountUser(value);
          accountUser.refresh();
        });
        return true;
      } catch (error) {
        FeedbackController.announce(
            notification: AppNotification.unknownError()
                .copyWith(message: error.toString(), title: error.toString()));
        return false;
      }
    } else {
      FeedbackController.announce(
          notification: AppNotification(
              message: "",
              title:
                  "You must sign up to be able to like,share,comment join the community!",
              type: NotificationType.warning,
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      Get.log("hey");
                      FeedbackController.clearErrorNotification();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.black,
                      elevation: 0,
                    ),
                    child: const Text(
                      "Later",
                      style: TextStyle(color: Colors.white),
                    ),
                    key: UniqueKey(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      Get.log("hey");
                      try {
                        String _route = NavController.instance
                            .addNextToOnRoute(AppRoutes.auth, Get.currentRoute);
                        await Get.toNamed(_route);
                      } catch (_) {
                        Get.log(_.toString());
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      backgroundColor: Colors.black,
                      elevation: 0,
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                    key: UniqueKey(),
                  ),
                ],
              ),
              code: AppErrorCodes.userNotAuthenticated));
      return false;
    }
  }
}
