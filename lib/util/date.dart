import 'package:celebrated/lists/data/static.data.dart';
import 'package:flutter/material.dart';
import 'package:lit_relative_date_time/controllers.dart';
import 'package:lit_relative_date_time/models.dart';

extension DateRelative on DateTime {
  String relativeToNowString( BuildContext ctx) {
    return RelativeDateFormat(
      Localizations.localeOf(ctx),
    ).format(RelativeDateTime(dateTime: DateTime.now(), other: this));
  }

  String get monthInShortForm =>StaticData.monthsShortForm[month - 1];
  String get readable => "$monthInShortForm ${day.toString()} $year";
}
