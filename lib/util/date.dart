import 'package:flutter/material.dart';
import 'package:lit_relative_date_time/controllers.dart';
import 'package:lit_relative_date_time/models.dart';

extension DateRelative on DateTime {
  String relativeToNowString( BuildContext ctx) {
    return RelativeDateFormat(
      Localizations.localeOf(ctx),
    ).format(RelativeDateTime(dateTime: DateTime.now(), other: this));
  }
}
