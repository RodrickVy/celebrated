import 'package:bremind/birthday/adapter/birthdays.factory.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/birthday/model/birthday.list.dart';
import 'package:bremind/birthday/view/birthday.card.dart';
import 'package:bremind/birthday/view/colordrop.down.dart';
import 'package:bremind/domain/view/app.state.view.dart';
import 'package:bremind/domain/view/editable.text.field.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

/// page showing the users brithdays , and enables the user to update the lists.
class BListView extends AppStateView<BirthdaysController> {
  final Rx<BirthdayList> _list = BirthdayList.empty().obs;

  BListView(final BirthdayList aList, {Key? key}) : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _list.value = aList;
      _list.refresh();
    });
  }

  @override
  Widget view({required BuildContext ctx, required Adaptives adapter}) {
    Key spinnerKey = Key(_list.value.id);
    return Obx(
      () {
        _list.value;
        return Container(
          height: adapter.height,
          decoration: BoxDecoration(
            color: Color(_list.value.hex).withAlpha(60),
          ),
          alignment: Alignment.topLeft,
          padding:  EdgeInsets.zero,
          width: adapter.width,
          child: SizedBox(
            width: adapter.adapt(
                phone: adapter.width,
                tablet: adapter.width ,
                desktop: 600),
            child: ListView(padding:  EdgeInsets.zero, children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: EditableTextView(
                  icon: Icons.list_alt_outlined,
                  textValue: _list.value.name,
                  label: 'list name',
                  background: Colors.transparent,
                  onSave: (String value) async {
                    FeedbackService.spinnerUpdateState(
                        key: spinnerKey, isOn: true);
                    _list.value = await controller
                        .updateContent(_list.value.id, {"name": value});
                    FeedbackService.spinnerUpdateState(
                        key: spinnerKey, isOn: false);
                  },
                  spinnerKey: spinnerKey,
                ),
                // backgroundColor: Color(_list.value.hex),
                trailing: ColorDropDown(
                  values: controller.colorsList,
                  defaultValue: _list.value.hex,
                  onSelect: (int value) async {
                    _list.value = await controller
                        .updateContent(_list.value.id, {"hex": value});
                  },
                ),
              ),
              ..._list.value.bds.map((ABirthday birthday) {
                return BirthdayCard(
                  birthday: birthday,
                  onEdit: (ABirthday birthday) async {
                    _list.value =
                        await controller.updateContent(_list.value.id, {
                      "birthdays": _list.value
                          .withAddedBirthday(birthday)
                          .birthdays
                          .values
                          .map((value) => BirthdayFactory().toJson(value))
                          .toList()
                    });
                  },
                  onDelete: (ABirthday birthday) async {
                    _list(_list.value.withRemovedBirthday(birthday.id));
                    await controller.updateContent(_list.value.id, {
                      "birthdays": _list.value.birthdays.values
                          .map((value) => BirthdayFactory().toJson(value))
                          .toList()
                    });
                  },
                );
              }),
              IconButton(
                icon: const Icon(Icons.add),
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  final String id = const Uuid().v4();
                  _list.value = await controller.updateContent(_list.value.id, {
                    "birthdays": _list.value
                        .withAddedBirthday(ABirthday.empty().copyWith(id: id))
                        .birthdays
                        .values
                        .map((value) => BirthdayFactory().toJson(value))
                        .toList()
                  });
                },
              )
            ]),
          ),
        );
      },
    );
  }
}
