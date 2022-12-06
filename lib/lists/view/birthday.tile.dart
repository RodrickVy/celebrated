import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/view/components/drop.context.menu.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'birthday.editor.dart';

class BirthdayTile extends AdaptiveUI {
  final ABirthday birthday;
  final double? width;
  final double? height;
  final Function(ABirthday birthday) onEdit;
  final Function(ABirthday birthday) onDelete;
  final VoidCallback? onSelect;

  const BirthdayTile(
      {Key? key,
      this.width = 160,
      this.onSelect,
      this.height = 260,
      required this.onDelete,
      required this.birthday,
      required this.onEdit})
      : super(key: key);

  List<DropDownAction> get actions => [
        DropDownAction("Delete", Icons.delete, () {
          onDelete(birthday);
        }),
        DropDownAction("Edit", Icons.edit, () {
          onEdit(birthday);
          birthdaysController.editBirthday(birthday.id);
        }),
        DropDownAction("Countdown", Icons.share, () {
          onSelect != null ? onSelect!() : () {};
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
                  onSave: (ABirthday birthday) {
                    birthdaysController.closeBirthdayEditor();
                    onEdit(birthday);
                  },
                  onDelete: () {
                    onDelete(birthday);
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
                      onEdit(birthday);
                      birthdaysController.editBirthday(birthday.id);
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all( 10.0),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                             color: AppSwatch.primary.withAlpha(20),
                           ),
                            child: Text(
                              "${birthday.name.capitalizeFirst} ",
                              style: Adaptive(ctx).textTheme.headline6?.copyWith(
                                  fontWeight: FontWeight.w400, fontFamily: GoogleFonts.playfairDisplay().fontFamily),
                            ),
                          ),
                          const SizedBox(width: 10,),
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
                          ...actions.map((e) => AppButton(
                                onPressed: e.action,
                                label: e.name,
                            isTextButton:true
                              ))
                        ],
                      ),
                    ),
                    // trailing: Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(0),
                    //   ),
                    //   padding: const EdgeInsets.all(6),
                    //   child: Row(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(right: 8.0),
                    //         child: Text(
                    //           birthday.date.readable,
                    //           style: Adaptive(ctx).textTheme.bodyMedium?.copyWith(
                    //                 fontWeight: FontWeight.w400,
                    //               ),
                    //         ),
                    //       ),
                    //       Text(birthday.formattedBirthday(ctx)),
                    //     ],
                    //   ),
                    // ),
                  )),
        ),
      ),
    );
  }

  /// use of routes, we are using routes for two things , one is to store the current list and now its to get the current birthday in edit mode.
}
