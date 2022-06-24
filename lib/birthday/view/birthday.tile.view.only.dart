import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/birthday/data/static.data.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/domain/model/drop.down.action.dart';
import 'package:bremind/domain/view/action.drop.down.dart';
import 'package:bremind/domain/view/app.state.view.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'birthday.editor.dart';

class BirthdayCard1ViewOnly extends AppStateView<BirthdaysController> {
  final ABirthday birthday;
  final double? width;
  final double? height;
  final Function(ABirthday birthday) onEdit;
  final Function(ABirthday birthday) onDelete;
  final bool viewOnly;
  final VoidCallback? onSelect;

  BirthdayCard1ViewOnly(
      {Key? key,
      this.viewOnly = false,
      this.width = 160,
      this.onSelect,
      this.height = 260,
      required this.onDelete,
      required this.birthday,
      required this.onEdit})
      : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {

      return SizedBox(
        width: adapter.adapt(
            phone: adapter.width, tablet: adapter.width, desktop: 600),
        child: Card(
            elevation: 1,
            color: birthday.isPast
                ? Colors.blueGrey.withAlpha(50)
                : Get.theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "${birthday.name.capitalizeFirst}",
                    ),
                  ],
                ),
              ),
              subtitle: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Text(
                      "${StaticData.monthsShortForm[birthday.date.month - 1]} ${birthday.date.day.toString()}  ",
                    ),
                    Text(birthday.formattedBirthday(ctx)),
                  ],
                ),
              ),
            )),
      );

  }

  /// use of routes, we are using routes for two things , one is to store the current list and now its to get the current birthday in edit mode.
}
