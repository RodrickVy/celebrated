import 'package:bremind/account/models/content_interaction.dart';
import 'package:bremind/account/models/user.content.interaction.type.dart';
import 'package:bremind/authenticate/models/auth.with.dart';
import 'package:bremind/domain/model/imodel.dart';
import 'package:bremind/util/enum.dart';

class AccountUser implements IModel {
  final String photoUrl;

  final String phone;

  final String email;

  final AuthWith authMethod;

  final String providerId;

  final String displayName;

  final String uid;

  final DateTime lastLogin;
  final DateTime timeCreated;

  final String name;

  final bool emailVerified;
  final Map<String, dynamic> claims;

  final String avatar;

  final List<UserContentInteraction> interactions;

  final String bio;

  AccountUser({
    required this.claims,
    required this.bio,
    required this.timeCreated,
    required this.interactions,
    required this.name,
    required this.emailVerified,
    required this.uid,
    required this.lastLogin,
    required this.authMethod,
    required this.avatar,
    required this.displayName,
    required this.providerId,
    required this.email,
    required this.photoUrl,
    required this.phone,
  });

  // bool hasReadAccess(String dbpath) {
  //   return claims.containsKey("hasReadAccess") &&
  //       List.from(claims["hasReadAccess"]!).contains(dbpath);
  // }
  //
  // bool hasWriteAccess(String dbpath) {
  //   return claims.containsKey("hasWriteAccess") &&
  //       List.from(claims["hasWriteAccess"]!).contains(dbpath);
  // }
  //
  // bool hasUpdateAccess(String dbpath) {
  //   return claims.containsKey("hasUpdateAccess") &&
  //       List.from(claims["hasUpdateAccess"]!).contains(dbpath);
  // }
  //
  // bool hasDeleteAccess(String dbpath) {
  //   return claims.containsKey("hasDeleteAccess") &&
  //       List.from(claims["hasDeleteAccess"]!).contains(dbpath);
  // }

  Map<String, dynamic> toMap() {
    return {
      'photoUrl': photoUrl,
      'phone': phone,
      'email': email,
      'authMethod': EnumSerialize.toJson(authMethod),
      'providerId': providerId,
      'displayName': displayName,
      'guid': uid,
      'lastLogin': lastLogin.millisecondsSinceEpoch,
      'timeCreated': timeCreated.millisecondsSinceEpoch,
      'name': name,
      'emailVerified': emailVerified,
      'claims': claims,
      'avatar': avatar,
      "bio": bio,
      'interactions': interactions.map((e) => e.toMap()).toList(),
    };
  }

  factory AccountUser.fromMap(Map<String, dynamic> map) {
    return AccountUser(
      bio: map['bio'] ?? "Tell use a bit about yourself",
      photoUrl: map['photoUrl'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      authMethod: map['authMethod'] as AuthWith,
      providerId: map['providerId'] as String,
      displayName: map['displayName'] as String,
      uid: map['guid'] as String,
      lastLogin: DateTime.fromMillisecondsSinceEpoch(map['lastLogin']),
      timeCreated: DateTime.fromMillisecondsSinceEpoch(map['lastLogin']),
      name: map['name'] as String,
      emailVerified: map['emailVerified'] as bool,
      claims: map['claims'] as Map<String, dynamic>,
      avatar: map['avatar'] as String,
      interactions: List.from(map['interactions'])
          .map((e) => UserContentInteraction.fromMap(e))
          .toList(),
    );
  }

  static AccountUser empty() {
    return AccountUser(
        claims: {},
        timeCreated: DateTime.now(),
        interactions: [],
        name: "",
        emailVerified: false,
        uid: "",
        bio: "",
        lastLogin: DateTime.now(),
        authMethod: AuthWith.EmailLink,
        avatar: "",
        displayName: "",
        providerId: "",
        email: "",
        photoUrl: "",
        phone: "");
  }

  bool isEmpty() {
    return email.isEmpty && uid.isEmpty;
  }

  @override
  String get id => uid;

  AccountUser copyWith({
    String? photoUrl,
    String? phone,
    String? email,
    AuthWith? authMethod,
    String? providerId,
    String? displayName,
    String? uid,
    DateTime? lastLogin,
    DateTime? timeCreated,
    String? name,
    bool? emailVerified,
    Map<String, dynamic>? claims,
    String? avatar,
    List<UserContentInteraction>? interactions,
    String? bio,
  }) {
    return AccountUser(
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      authMethod: authMethod ?? this.authMethod,
      providerId: providerId ?? this.providerId,
      displayName: displayName ?? this.displayName,
      uid: uid ?? this.uid,
      lastLogin: lastLogin ?? this.lastLogin,
      timeCreated: timeCreated ?? this.timeCreated,
      name: name ?? this.name,
      emailVerified: emailVerified ?? this.emailVerified,
      claims: claims ?? this.claims,
      avatar: avatar ?? this.avatar,
      interactions: interactions ?? this.interactions,
      bio: bio ?? this.bio,
    );
  }

  bool hasInteracted(String contentId, UserContentInteractionType type) {
    try {
      interactions.firstWhere(
          (element) => element.contentId == contentId && element.type == type);
      return true;
    } catch (_) {
      return false;
    }
  }




}
