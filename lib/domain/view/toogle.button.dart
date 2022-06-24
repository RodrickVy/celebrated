import 'package:bremind/domain/model/toggle.option.dart';
import 'package:bremind/util/list.extention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppToggleButton extends StatelessWidget {
  final bool multiselect;
  final RxList<ToggleOption> toggleOptions = <ToggleOption> [].obs;
  final VoidCallback? onInteraction;

  AppToggleButton(
      {super.key,
      this.multiselect = false,
        this.onInteraction,
      required final List<ToggleOption> options}) {
    toggleOptions.addAll(options);
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (int selectedIndex) {
        onInteraction!=null?onInteraction!():(){};
       toggleOptions.value = toggleOptions.map2((element, int optionIndex) {
          if (selectedIndex == optionIndex) {
            element.onSelected();
            return element.copyWith(state: true);

          } else if (!multiselect) {
            return element.copyWith(state: false);
          } else {
            return element;
          }
        }).toList();

      },
      selectedColor: Colors.black38,
      isSelected: toggleOptions.map((element) => element.state).toList(),
      children: toggleOptions.map((element) => element.view).toList(),
    );
  }
}