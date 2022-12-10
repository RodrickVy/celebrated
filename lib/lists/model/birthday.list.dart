import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/lists/model/watcher.dart';
import 'package:celebrated/domain/model/imodel.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// , whatsapp, whatsappGroup
enum BirthdayReminderType { email, phoneNotification, sms }

class BirthdayBoard extends IModel {
  final String name;
  final Map<String, ABirthday> birthdays;
  final int hex;
  final List<String> sharedTo;
  final int startReminding;
  final String viewingId;
  final String addingId;
  final String authorId;
  final String authorName;
  final BirthdayReminderType notificationType;
  final List<String> watchers;

  const BirthdayBoard(
      {required this.name,
      required this.birthdays,
      required this.addingId,
      this.notificationType = BirthdayReminderType.phoneNotification,
      required this.hex,
      required this.authorName,
      required this.authorId,
      this.startReminding = 2,
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
      // print("${a.dateWithThisYear.toIso8601String()} : ${b.dateWithThisYear.toIso8601String()}");
      return (DateTime.now().millisecondsSinceEpoch - a.dateWithThisYear.millisecondsSinceEpoch)
          .compareTo(DateTime.now().millisecondsSinceEpoch - b.dateWithThisYear.millisecondsSinceEpoch);

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



  String generateViewId() => IDGenerator.generateId(10, name);

  String generateInviteId() => IDGenerator.generateId(10, name);

  String viewUrl([String? viewingId]) =>
      "${AppRoutes.domainUrlBase}${AppRoutes.shareList}?code=${viewingId ?? this.viewingId}";

  String addInviteUrl([String? addingId]) =>
      "${AppRoutes.domainUrlBase}${AppRoutes.addBirthdayInvite}?code=${addingId ?? this.addingId}";

  bool birthdayAlreadyExists(ABirthday birthday) {
    return birthdays.values
        .where((element) =>
            element.name.trim() == birthday.name.trim() &&
            element.date.month == birthday.date.month &&
            element.date.day == birthday.date.day)
        .isNotEmpty;
  }

  bool isWatcher(String id) {
    return watchers.contains(id) || id == authorId;
  }

  BirthdayBoard copyWith({
    String? name,
    Map<String, ABirthday>? birthdays,
    int? hex,
    List<String>? sharedTo,
    int? startReminding,
    String? viewingId,
    String? addingId,
    String? authorId,
    String? id,
    String? authorName,
    BirthdayReminderType? notificationType,
    List<String>? watchers,
  }) {
    return BirthdayBoard(
      name: name ?? this.name,
      birthdays: birthdays ?? this.birthdays,
      hex: hex ?? this.hex,
      sharedTo: sharedTo ?? this.sharedTo,
      startReminding: startReminding ?? this.startReminding,
      viewingId: viewingId ?? this.viewingId,
      addingId: addingId ?? this.addingId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      notificationType: notificationType ?? this.notificationType,
      watchers: watchers ?? this.watchers, id: id?? this.id,
    );
  }
}
