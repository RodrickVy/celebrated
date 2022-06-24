import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String userName;
  final String email;
  final String authWith;
  final String password;
  final String avatar;

  final bool emailVerified;

  final bool isAnonymous;

  final String? phoneNumber;

  final String uid;

  AuthUser(
      {required this.userName,
      required this.email,
      this.emailVerified = false,
      this.isAnonymous = false,
      this.phoneNumber,
      required this.uid,
      required this.authWith,
      required this.password,
      required this.avatar});

  static empty() {
    return AuthUser(
        userName: "",
        email: "",
        authWith: "",
        password: "",
        avatar: "",
        uid: '');
  }

  bool isEmpty(){
    return email.isEmpty && uid.isEmpty;
  }


  bool hasAvatar(){
    return  !isEmpty() && avatar.length > 4;
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'authWith': authWith,
      'password': password,
      'avatar': avatar,
      'emailVerified': emailVerified,
      'isAnonymous': isAnonymous,
      'phoneNumber': phoneNumber,
      'uid': uid,
    };
  }

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      userName: map['userName'] as String,
      email: map['email'] as String,
      authWith: map['authWith'] as String,
      password: map['password'] as String,
      avatar: map['avatar'] as String,
      emailVerified: map['emailVerified'] as bool,
      isAnonymous: map['isAnonymous'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      uid: map['uid'] as String,
    );
  }

  static AuthUser fromFireAuth(User? fireUser){
    if(fireUser != null){
      return AuthUser(
          userName: fireUser.displayName ?? "",
          email: fireUser.email ?? "",
          uid: fireUser.uid,
          emailVerified: fireUser.emailVerified,
          isAnonymous: fireUser.isAnonymous,
          phoneNumber: fireUser.phoneNumber,
          authWith: fireUser.providerData.first.providerId,
          password: "",
          avatar: fireUser.photoURL ??
              "assets/defualt_icons/avatar_outline.png");
    }
    return empty();
  }
}
