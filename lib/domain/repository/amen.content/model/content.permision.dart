import 'package:celebrated/domain/model/enum.dart';
import 'package:celebrated/domain/repository/amen.content/model/permission.dart';

class ContentPermissions {
  final PermissionType freeUsers;
  final PermissionType upgraded;
  final bool needsUpgrade;
  final bool toBeBought;
  final bool verified;

  ContentPermissions({
    required this.freeUsers,
    required this.upgraded,
    required this.needsUpgrade,
    required this.toBeBought,
    required this.verified,
  });

  Map<String, dynamic> toMap() {
    return {
      'freeUsers':AnEnum.toJson(freeUsers),
      'upgraded': AnEnum.toJson(upgraded),
      'needsUpgrade': needsUpgrade,
      'toBeBought': toBeBought,
      'verified': verified,
    };
  }

  factory ContentPermissions.fromMap(Map<String, dynamic> map) {
    return ContentPermissions(
      freeUsers: AnEnum.fromJson(PermissionType.values, map['freeUsers']),
      upgraded:AnEnum.fromJson(PermissionType.values,  map['upgraded']),
      needsUpgrade: map['needsUpgrade'] as bool,
      toBeBought: map['toBeBought'] as bool,
      verified: map['verified'] as bool,
    );
  }



  static ContentPermissions public(){
    return ContentPermissions(freeUsers: PermissionType.all, upgraded: PermissionType.all, needsUpgrade: false,verified:true, toBeBought: false,);
  }
}
