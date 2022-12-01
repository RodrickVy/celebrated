import 'package:celebrated/domain/services/content.store/model/content.interaction.type.dart';
import 'package:celebrated/util/enum.dart';
import 'package:flutter/foundation.dart';

class UserContentInteraction {
  final String userId;
  final String contentId;
  final UserContentInteractionType type;
  final DateTime timestamp;
  final Map<String,dynamic> data;

  UserContentInteraction(
      {required this.userId,
      required this.contentId,
      required this.type,
      required this.timestamp,
      required this.data});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'contentId': contentId,
      'type': EnumSerialize.toJson(type),
      'timestamp': timestamp.millisecondsSinceEpoch,
      'points': data,
    };
  }

  factory UserContentInteraction.fromMap(Map<String, dynamic> map) {
    return UserContentInteraction(
      userId: map['userId'] as String,
      contentId: map['contentId'] as String,
      type: EnumSerialize.fromJson(
          UserContentInteractionType.values, map['type']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      data: Map.from(map['points']),
    );
  }

  String get id {
    return (contentId + userId + describeEnum(type) + timestamp.toString())
        .hashCode
        .toString();
  }

  bool isOneTimeReversibleAction() {
    switch (type) {
      case UserContentInteractionType.like:
      case UserContentInteractionType.saveAsFave:
        return true;
      case UserContentInteractionType.report:
      case UserContentInteractionType.translate:
      case UserContentInteractionType.edit:
      case UserContentInteractionType.create:
      case UserContentInteractionType.comment:
      case UserContentInteractionType.reply:
      case UserContentInteractionType.share:
        return false;
    }
  }

  // Define that two persons are equal if their SSNs are equal
  @override
  // ignore: hash_and_equals
  bool operator ==(dynamic other) {
    return other.id == id;
  }



  UserContentInteraction copyWith({
    String? userId,
    String? contentId,
    UserContentInteractionType? type,
    DateTime? timestamp,
    Map<String,dynamic>? data,
  }) {
    return UserContentInteraction(
      userId: userId ?? this.userId,
      contentId: contentId ?? this.contentId,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
    );
  }
}
