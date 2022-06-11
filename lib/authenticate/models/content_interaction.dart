import 'package:bremind/authenticate/models/user.content.interaction.type.dart';
import 'package:bremind/util/enum.dart';
import 'package:flutter/foundation.dart';

class UserContentInteraction {
  final String userId;
  final String contentId;
  final UserContentInteractionType type;
  final DateTime timestamp;
  final int points;

  UserContentInteraction(
      {required this.userId,
      required this.contentId,
      required this.type,
      required this.timestamp,
      required this.points});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'contentId': contentId,
      'type': EnumSerialize.toJson(type),
      'timestamp': timestamp.millisecondsSinceEpoch,
      'points': points,
    };
  }

  factory UserContentInteraction.fromMap(Map<String, dynamic> map) {
    return UserContentInteraction(
      userId: map['userId'] as String,
      contentId: map['contentId'] as String,
      type: EnumSerialize.fromJson(
          UserContentInteractionType.values, map['type']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      points: map['points'] as int,
    );
  }

  String get id {
    return (contentId + userId + describeEnum(type) + points.toString())
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
  bool operator ==(dynamic other) {
    return other.id == id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  UserContentInteraction copyWith({
    String? userId,
    String? contentId,
    UserContentInteractionType? type,
    DateTime? timestamp,
    int? points,
  }) {
    return UserContentInteraction(
      userId: userId ?? this.userId,
      contentId: contentId ?? this.contentId,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      points: points ?? this.points,
    );
  }
}
