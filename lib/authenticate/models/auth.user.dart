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
      'userName': this.userName,
      'email': this.email,
      'authWith': this.authWith,
      'password': this.password,
      'avatar': this.avatar,
      'emailVerified': this.emailVerified,
      'isAnonymous': this.isAnonymous,
      'phoneNumber': this.phoneNumber,
      'uid': this.uid,
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
}
