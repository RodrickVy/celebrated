import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/lists/model/birthday.list.dart';
import 'package:celebrated/lists/view/pages/lists.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BirthdayPreviewCard extends AdaptiveUI {
  final ABirthday birthday;

  final VoidCallback? onSelect;

  const BirthdayPreviewCard(
      {Key? key,
      this.onSelect,
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

}


class BirthdayCard extends AdaptiveUI{
  final ABirthday birthday;
  final BirthdayBoard list;

  const BirthdayCard({required this.birthday, required this.list, super.key});

  List<OptionAction> get actions => [
    OptionAction("Delete", Icons.delete, () async {
      await birthdaysController.deleteBirthday(list, birthday);
    }),
    OptionAction("Edit", Icons.edit, () async {
      birthdaysController.setBirthdayInEditMode(birthday.id);
    }),
    OptionAction("Countdown", Icons.share, () {
      navService.to(birthdaysController.getBirthdayShareRoute(list.id, birthday.id));
    })
  ];
  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Card(
        elevation: 0,
        shape: AppTheme.shape,
        child: ListTile(
          onTap: () {

            birthdaysController.setBirthdayInEditMode(birthday.id);
          },
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "${birthday.name.capitalizeFirst} ",
                  style: Adaptive(ctx).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.w600, fontFamily: GoogleFonts.playfairDisplay().fontFamily),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    birthday.date.readable,
                    style: Adaptive(ctx).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(birthday.formattedBirthday(ctx)),
              ],
            ),
          ),
          subtitle: Container(
            width: 300,
            height: 60,
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                ...actions.map((e) => IconButton(onPressed: e.action, icon: Icon(e.icon),))
              ],
            ),
          ),
        ));
  }


}
