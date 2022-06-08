import 'dart:async';
import 'package:bremind/account/models/account.dart';
import 'package:bremind/authenticate/models/auth.user.dart';
import 'package:get/get.dart';

abstract class IAccountInterface {
  Rx<AccountUser> get accountUser;


  Future<AccountUser> attemptFetchUserAccount(AuthUser user);

  Future<AccountUser>  createUserAccount(AuthUser user);

}
