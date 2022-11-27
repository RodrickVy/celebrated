
import 'package:celebrated/domain/view/components/app.state.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final Rx<int?> _value = Rx<int?>(null);

/// used to select color of category in birthday lists
class ColorDropDown extends AdaptiveUI {
  final List<int> values;

  final Function(int value) onSelect;
  final int defaultValue;

  const ColorDropDown({Key? key, required this.values, required this.defaultValue, required this.onSelect})
      : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    Get.log("build happened!");
    return Obx(
      () => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: const Border.fromBorderSide(BorderSide(color: Colors.transparent, width: 0))),
        child: DropdownButton<int>(
          value: _value.value ?? defaultValue,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          borderRadius: BorderRadius.circular(0),
          underline: Container(
            height: 2,
          ),
          onChanged: (int? newValue) {
            Get.log("Selection happened!");
            if (newValue != null) {
              Get.log("Selection happened!");
              _value(newValue);
              onSelect(newValue);
            }
          },
          items: values.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              onTap: () {
                Get.log("tapped");
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Color(value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
