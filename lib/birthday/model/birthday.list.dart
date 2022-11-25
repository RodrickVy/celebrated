import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/birthday/model/birthday.dart';
import 'package:celebrated/birthday/model/watcher.dart';
import 'package:celebrated/domain/model/imodel.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BirthdayBoard extends IModel {
  final String name;
  final Map<String, ABirthday> birthdays;
  final int hex;
  final List<String> sharedTo;
  final String viewingId;
  final String addingId;
  final String authorId;
  final String authorName;
  final List<BirthdaysWatcher> watchers;

  BirthdayBoard(
      {required this.name,
      required this.birthdays,
      required this.addingId,
      required this.hex,
      required this.authorName,
      required this.authorId,
      required final String id,
      required this.sharedTo,
        this.watchers = const [],
      required this.viewingId})
      : super(id);

  BirthdayBoard withName(String name) {
    return copyWith(name: name);
  }

  BirthdayBoard withAddedBirthday(ABirthday birthday) {
    birthdays[birthday.id] = birthday;
    return this;
  }

  BirthdayBoard withRemovedBirthday(String id) {
    birthdays.remove(id);
    return this;
  }

  BirthdayBoard withChangedColor(int color) {
    return copyWith(hex: color);
  }

  BirthdayBoard clearAllBirthdays() {
    return copyWith(birthdays: {});
  }

  List<ABirthday> get bds {
    List<ABirthday> _birthdays = birthdaysList;
    _birthdays.sort((a, b) {

      print("${a.dateWithThisYear.toIso8601String()} : ${b.dateWithThisYear.toIso8601String()}");
     return (DateTime.now().millisecondsSinceEpoch - a.dateWithThisYear.millisecondsSinceEpoch).compareTo(DateTime.now().millisecondsSinceEpoch - b.dateWithThisYear.millisecondsSinceEpoch);

      // int aDifferenceToCurrentDate = DateTime.now()
      //     .difference(DateTime(DateTime.now().year, a.date.month, a.date.day))
      //     .inMicroseconds
      //     .abs();
      // int bDifferenceToCurrentDate = DateTime.now()
      //     .difference(DateTime(DateTime.now().year, b.date.month, b.date.day))
      //     .inMicroseconds
      //     .abs();
      // if (b.isPast) {
      //   return -1;
      // }
      // if (a.isPast) {
      //   return 1;
      // }
      // if (aDifferenceToCurrentDate < bDifferenceToCurrentDate) {
      //   return -1;
      // } else {
      //   return 1;
      // }
    });
    return _birthdays;
  }

  static BirthdayBoard empty() {
    return BirthdayBoard(
        name: "",
        birthdays: {},
        authorId: "",
        authorName: '',
        hex: 0xFFFF6633,
        id: "",
        sharedTo: [],
        viewingId: "",
        addingId: "");
  }

  bool isEmpty() {
    return authorId.isEmpty && id.isEmpty && birthdays.isEmpty;
  }

  Color get color => Color(hex).withAlpha(80);

  List<ABirthday> get birthdaysList => birthdays.values.toList();

  BirthdayBoard copyWith(
      {String? name,
      Map<String, ABirthday>? birthdays,
      int? hex,
      List<String>? sharedTo,
      String? viewingId,
      String? addingId,
      String? authorId,
      String? authorName,
      String? id}) {
    return BirthdayBoard(
        name: name ?? this.name,
        birthdays: birthdays ?? this.birthdays,
        hex: hex ?? this.hex,
        sharedTo: sharedTo ?? this.sharedTo,
        viewingId: viewingId ?? this.viewingId,
        addingId: addingId ?? this.addingId,
        authorId: authorId ?? this.authorId,
        id: id ?? this.id,
        authorName: authorName ?? this.authorName);
  }

  String generateViewId() =>
      "${AuthController.instance.accountUser.value.uid.substring(0, 3)}${const Uuid().v4()}${DateTime.now().millisecondsSinceEpoch}";

  String generateInviteId() =>
      "${DateTime.now().millisecondsSinceEpoch}${const Uuid().v4()}";

  String  viewUrl ([String? viewingId])=>
      "${AppRoutes.domainUrlBase}/shared?link=${viewingId??this.viewingId}";

  String  addInviteUrl ([String? addingId]) =>
      "${AppRoutes.domainUrlBase}/open_edit?link=${addingId??this.addingId}";

  bool birthdayAlreadyExists(ABirthday birthday) {
    return birthdays.values
        .where((element) =>
            element.name.trim() == birthday.name.trim() &&
            element.date.month == birthday.date.month &&
            element.date.day == birthday.date.day)
        .isNotEmpty;
  }
  
  
  
}
