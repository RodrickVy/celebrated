import 'package:bremind/account/models/account.dart';
import 'package:bremind/account/models/content_interaction.dart';
import 'package:bremind/authenticate/models/auth.with.dart';
import 'package:bremind/domain/model/imodel.factory.dart';
import 'package:bremind/util/enum.dart';

class AccountUserFactory extends IModelFactory<AccountUser> {
  @override
  Map<String, dynamic> toJson(AccountUser model) {
    return {
      'photoUrl': model.photoUrl,
      'phone': model.phone,
      'email': model.email,
      'authMethod': EnumSerialize.toJson(model.authMethod),
      'providerId': model.providerId,
      'displayName': model.displayName,
      'guid': model.uid,
      'lastLogin': model.lastLogin.millisecondsSinceEpoch,
      'timeCreated': model.timeCreated.millisecondsSinceEpoch,
      'name': model.name,
      'emailVerified': model.emailVerified,
      'claims': model.claims,
      'avatar': model.avatar,
      "bio":model.bio,
      'interactions': model.interactions.map((e) => e.toMap()).toList(),
    };
  }

  @override
  fromJson(Map<String, dynamic> map) {
    return AccountUser(
      photoUrl: map['photoUrl'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      bio:map['bio']??"Tell use a bit about yourself",
      authMethod: EnumSerialize.fromJson(AuthWith.values, map['authMethod']),
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
        bio: "",
        emailVerified: false,
        uid: "",
        lastLogin: DateTime.now(),
        authMethod: AuthWith.EmailLink,
        avatar: "",
        displayName: "",
        providerId: "",
        email: "",
        photoUrl: "",
        phone: "");
  }
}
