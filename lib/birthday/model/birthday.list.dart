import 'package:bremind/birthday/adapter/birthdays.factory.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/domain/model/imodel.dart';

class BirthdayList extends IModel {
  final String name;
  final Map<String, ABirthday> birthdays;
  final int hex;
  final List<String> sharedTo;
  final bool canAccessWithLink;
  @override
  final String id;

  BirthdayList(
      {required this.name,
      required this.birthdays,
      required this.hex,
      required this.id,
      required this.sharedTo,
      required this.canAccessWithLink})
      : super(id);

  BirthdayList withName(String name) {
    return copyWith(name: name);
  }

  BirthdayList withAddedBirthday(ABirthday birthday) {
    birthdays.putIfAbsent(birthday.id, () => birthday);
    return this;
  }

  BirthdayList withRemovedBirthday(String id) {
    birthdays.remove(id);
    return this;
  }

  BirthdayList withChangedColorBirthday(int color) {
    return copyWith(hex: color);
  }

  BirthdayList clearAllBirthdays() {
    return copyWith(birthdays: {});
  }

  BirthdayList copyWith({
    String? name,
    Map<String, ABirthday>? birthdays,
    int? hex,
    List<String>? sharedTo,
    bool? canAccessWithLink,
    String? id,
  }) {
    return BirthdayList(
      name: name ?? this.name,
      birthdays: birthdays ?? this.birthdays,
      hex: hex ?? this.hex,
      sharedTo: sharedTo ?? this.sharedTo,
      canAccessWithLink: canAccessWithLink ?? this.canAccessWithLink,
      id: id ?? this.id,
    );
  }
}
