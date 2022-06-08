import 'package:bremind/birthday/adapter/birthdays.factory.dart';
import 'package:bremind/domain/model/imodel.dart';

class ABirthday extends IModel {
  final String name;
  final DateTime date;
  final DateTime remindMeWhen;
  @override
  final String id;

  ABirthday(
      {required this.name,
      required this.id,
      required this.date,
      required this.remindMeWhen})
      : super(id);

  ABirthday copyWith({
    String? name,
    DateTime? date,
    DateTime? remindMeWhen,
    String? id,
  }) {
    return ABirthday(
      name: name ?? this.name,
      date: date ?? this.date,
      remindMeWhen: remindMeWhen ?? this.remindMeWhen,
      id: id ?? this.id,
    );
  }

  static ABirthday empty() {
    return ABirthday(
        name: "", id: "", date: DateTime.now(), remindMeWhen: DateTime.now());
  }

  bool get isPast {
    // print(
    //     "Difference : ${DateTime.now().difference(DateTime(DateTime.now().year, date.month, date.day)).inMinutes}");
    // return DateTime.now()
    //         .difference(DateTime(DateTime.now().year, date.month, date.day))
    //         .inMinutes <
    //     0;

    return DateTime(
            DateTime.now().year, date.month, date.day, date.hour, date.second)
        .isBefore(DateTime.now());
  }

  Duration get durationRemaining {
    if (isPast) {
      return DateTime.now()
          .difference(DateTime(DateTime.now().year + 1, date.month, date.day));
    }
    return DateTime.now()
        .difference(DateTime(DateTime.now().year, date.month, date.day));
  }

  int monthsRemaining() {
    return durationRemaining.inDays.abs() ~/ 30.416666416556531;
  }

  int daysRemaining() {
    return (durationRemaining.inDays.abs() -
            (monthsRemaining() * 30.416666416556531))
        .toInt();
  }

  int hoursRemaining() {
    return (durationRemaining.inHours.abs() - (durationRemaining.inDays * 24))
        .toInt();
  }

  int minutesRemaining() {
    return (durationRemaining.inMinutes.abs() -
            (durationRemaining.inHours * 60))
        .toInt();
  }


  DateTime get dateWithThisYear{
    return DateTime(DateTime.now().year, date.month, date.day, date.hour, date.second);
  }



  int age() {
    return (date.difference(DateTime.now()).inDays~/365).abs();
  }

  factory ABirthday.fromJson(Map<String, dynamic> map) {
    return BirthdayFactory().fromJson(map);
  }

  bool  get shouldNotify{
    return DateTime.now().difference(date).inDays > 0 && date.difference(DateTime.now()).inDays  <= 7;
  }
}
