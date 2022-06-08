import 'package:bremind/account/models/account.dart';
import 'package:bremind/authenticate/models/auth.user.dart';
import 'package:bremind/domain/model/data.validator.dart';
import 'package:get/get.dart';

enum AuthUI { signInAndSignUp, passwordReset }

abstract class IAuthController {
  Rx<AuthUser> get user;
  Rx<AccountUser> get accountUser;


  RxBool get isAuthenticated;



  Future<AccountUser> attemptFetchUserAccount(AuthUser user);

  Future<AccountUser>  createUserAccount(AuthUser user);


  signInWithEmail({required String email, required String password});

  signInWithPopUpProvider({required dynamic provider});

  signUpWithEmail(
      {required String name, required String email, required String password});

  signUpWithPopUpProvider({required dynamic provider});

  sendPasswordResetEmail({required String email});

  logout();

  updateUserName({required String name});


  updateBio({required String bio});

  Validator get userNameValidator;

  Validator get emailFormValidator;

  Validator get passwordValidator;
}
