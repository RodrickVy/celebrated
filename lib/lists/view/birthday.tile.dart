import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/lists/adapter/birthdays.factory.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/lists/model/birthday.list.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'birthday.editor.dart';

class BirthdayTile extends AdaptiveUI {
  final BirthdayBoard board;
  final ABirthday birthday;

  const BirthdayTile({Key? key, required this.board, required this.birthday}) : super(key: key);

  List<OptionAction> get actions => [
        OptionAction("Delete", Icons.delete, () async {
          await birthdaysController.deleteBirthday(board, birthday);
        }),
        OptionAction("Edit", Icons.edit, () async {
           birthdaysController.setBirthdayInEditMode(birthday.id);
        }),
        OptionAction("Countdown", Icons.share, () {
          navService.to(birthdaysController.getBirthdayShareRoute(board.id, birthday.id));
        })
      ];

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () => SizedBox(
        width: adapter.adapt(phone: adapter.width, tablet: adapter.width, desktop: 600),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: birthdaysController.currentBirthdayInEdit.value == birthday.id
              ? BirthdayEditor(
                  onSave: (ABirthday birthday)async {
             
                    await birthdaysController.saveBirthdayDetails(board, birthday);
                  },
                  onDelete: () async{
                    await birthdaysController.deleteBirthday(board, birthday);
                  },
                  birthdayValue: birthday,
                  onCancel: () {
                    birthdaysController.closeBirthdayEditor();
                  },
                )
              : Card(
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
                  )),
        ),
      ),
    );
  }

  /// use of routes, we are using routes for two things , one is to store the current list and now its to get the current birthday in edit mode.
}
