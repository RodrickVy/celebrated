import 'package:celebrated/lists/model/birthday.list.dart';

class BirthdaysListWatcher {
  final String name;
  final String phoneNumber;
  final String email;
  final BirthdayReminderType notificationType;

  const BirthdaysListWatcher( 
      {required this.name, required this.email,  required this.phoneNumber, required this.notificationType});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'notificationType': notificationType,
    };
  }

  factory BirthdaysListWatcher.fromMap(Map<String, dynamic> map) {
    return BirthdaysListWatcher(
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as String,
      notificationType: map['notificationType'] as BirthdayReminderType, email: map["email"],
    );
  }
}


