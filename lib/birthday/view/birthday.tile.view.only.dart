import 'package:celebrated/app.theme.dart';
import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/birthday/data/static.data.dart';
import 'package:celebrated/birthday/model/birthday.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/view/action.drop.down.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'birthday.editor.dart';

class BirthdayCard1ViewOnly extends AppStateView<BirthdaysController> {
  final ABirthday birthday;
  final double? width;
  final double? height;
  final VoidCallback? onSelect;

  BirthdayCard1ViewOnly(
      {Key? key,
      this.width = 160,
      this.onSelect,
      this.height = 260,

      required this.birthday,})
      : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {

      return SizedBox(
        width: adapter.adapt(
            phone: adapter.width, tablet: adapter.width, desktop: 600),
        child: Card(
            elevation: 1,
            shape: AppTheme.shape,
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
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Text(
                       birthday.date.readable,
                      ),
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
