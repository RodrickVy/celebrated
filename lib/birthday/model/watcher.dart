import 'package:celebrated/birthday/model/birthday.list.dart';

class BirthdaysWatcher {
  final String name;
  final bool isUser;
  final String phoneNumber;
  final String email;
  final BirthdayReminderType notificationType;

  const BirthdaysWatcher(
      {required this.name, required this.isUser,required this.email,  required this.phoneNumber, required this.notificationType});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isUser': isUser,
      'phoneNumber': phoneNumber,
      'notificationType': notificationType,
    };
  }

  factory BirthdaysWatcher.fromMap(Map<String, dynamic> map) {
    return BirthdaysWatcher(
      name: map['name'] as String,
      isUser: map['isUser'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      notificationType: map['notificationType'] as BirthdayReminderType, email: map["email"],
    );
  }
}


