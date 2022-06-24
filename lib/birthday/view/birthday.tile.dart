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

class BirthdayTile extends AppStateView<BirthdaysController> {
  final ABirthday birthday;
  final double? width;
  final double? height;
  final Function(ABirthday birthday) onEdit;
  final Function(ABirthday birthday) onDelete;
  final VoidCallback? onSelect;

  BirthdayTile(
      {Key? key,
      this.width = 160,
      this.onSelect,
      this.height = 260,
      required this.onDelete,
      required this.birthday,
      required this.onEdit})
      : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () => SizedBox(
        width: adapter.adapt(
            phone: adapter.width, tablet: adapter.width, desktop: 600),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: controller.currentBirthdayInEdit.value == birthday.id
              ? BirthdayEditor(
                  onSave: (ABirthday birthday) {
                    controller.closeBirthdayEditor();
                    onEdit(birthday);
                  },
                  onDelete: () {
                    onDelete(birthday);
                  },
                  birthdayValue: birthday,
                  onCancel: () {
                    controller.closeBirthdayEditor();
                  },
                )
              : Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    onTap: () {
                      onEdit(birthday);
                      controller.editBirthday(birthday.id);
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "${birthday.name.capitalizeFirst} ",
                            style: Adaptive(ctx)
                                .textTheme
                                .headline6
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    trailing: ActionDropDown(actions: [
                      DropDownAction("Delete", () {
                        onDelete(birthday);
                      }),
                      DropDownAction("Edit", () {
                        onEdit(birthday);
                        controller.editBirthday(birthday.id);
                      }),
                      DropDownAction("View", () {
                        onSelect != null ? onSelect!() : () {};
                      })
                    ]),
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
        ),
      ),
    );
  }

  /// use of routes, we are using routes for two things , one is to store the current list and now its to get the current birthday in edit mode.
}
