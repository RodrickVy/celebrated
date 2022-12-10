import 'package:celebrated/lists/adapter/birthdays.factory.dart';
import 'package:celebrated/domain/model/imodel.dart';
import 'package:celebrated/util/date.dart';

class ABirthday extends IModel {
  final String name;
  final DateTime date;

  ABirthday({
    required this.name,
    required final String id,
    required this.date,
  }) : super(id);

  ABirthday copyWith({
    String? name,
    DateTime? date,
    String? id,
  }) {
    return ABirthday(
      name: name ?? this.name,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }

  String get birthdayId => id;

  static final DateTime uniqueDate = DateTime(
    1776,
    3,
    4,
    2,
    5,
    2,
    4,
    2,
  );

  static ABirthday empty() {
    return ABirthday(
      name: "name",
      id: "",
      date: DateTime(DateTime.now().year, DateTime.now().month, 17),
    );
  }

  bool get isPast {
    return DateTime(DateTime.now().year, date.month, date.day, date.hour, date.second).isBefore(DateTime.now());
  }

  Duration get durationRemaining {
    if (isPast) {
      return DateTime.now().difference(DateTime(DateTime.now().year + 1, date.month, date.day));
    }
    return DateTime.now().difference(DateTime(DateTime.now().year, date.month, date.day));
  }

  int monthsRemaining() {
    return durationRemaining.inDays.abs() ~/ 30.416666416556531;
  }

  int daysRemaining() {
    return (durationRemaining.inDays.abs() - (monthsRemaining() * 30.416666416556531)).toInt();
  }

  int hoursRemaining() {
    return (durationRemaining.inHours.abs() - (durationRemaining.inDays * 24)).toInt();
  }

  int minutesRemaining() {
    return (durationRemaining.inMinutes.abs() - (durationRemaining.inHours * 60)).toInt();
  }

  DateTime get dateWithThisYear {
    return DateTime(DateTime.now().year, date.month, date.day, 0, 0);
  }

  int age() {
    return (date.difference(DateTime.now()).inDays ~/ 365).abs();
  }

  factory ABirthday.fromJson(Map<String, dynamic> map) {
    return BirthdayFactory().fromJson(map);
  }

  bool get shouldNotify {
    return DateTime.now().difference(date).inDays > 0 && date.difference(DateTime.now()).inDays <= 7;
  }

  String formattedBirthday(ctx) => dateWithThisYear.relativeToNowString(ctx);

  @override
  String toString() {
    return '$name:${date.toString()}';
  }
}
