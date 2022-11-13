import 'package:celebrated/authenticate/models/account.dart';
import 'package:celebrated/authenticate/models/content_interaction.dart';
import 'package:celebrated/authenticate/models/auth.with.dart';
import 'package:celebrated/domain/model/imodel.factory.dart';
import 'package:celebrated/util/enum.dart';

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
      "bio": model.bio,
      'interactions': model.interactions.map((e) => e.toMap()).toList(),
      "birthdate": model.birthdate.millisecondsSinceEpoch,
      "settings": model.settings
    };
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return AccountUser(
      photoUrl: json['photoUrl'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      bio: json['bio'] ?? "Tell use a bit about yourself",
      authMethod: EnumSerialize.fromJson(AuthWith.values, json['authMethod']),
      providerId: json['providerId'] as String,
      displayName: json['displayName'] as String,
      uid: json['guid'] as String,
      lastLogin: DateTime.fromMillisecondsSinceEpoch(json['lastLogin']),
      timeCreated: DateTime.fromMillisecondsSinceEpoch(json['timeCreated']),
      name: json['name'] as String,
      emailVerified: json['emailVerified'] as bool,
      claims: json['claims'] as Map<String, dynamic>,
      avatar: json['avatar'] as String,
      interactions: List.from(json['interactions'])
          .map((e) => UserContentInteraction.fromMap(e))
          .toList(),
      settings: Map.from(json["settings"])??{},
      birthdate: DateTime.fromMillisecondsSinceEpoch(json['birthdate'] ??json['timeCreated']),
    );
  }
}
