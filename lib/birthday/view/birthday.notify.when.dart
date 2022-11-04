import 'package:celebrated/app.theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// used in birthday editor to select the time to be notified.
class NotifyWhen extends StatelessWidget {
  final List<String> values;
  final Rx<String?> _value = Rx<String?>(null);
  final Function(String value) onSelect;
  final String defaultValue;

  NotifyWhen(
      {Key? key,
      required this.values,
      required this.defaultValue,
      required this.onSelect})
      : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _value(defaultValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color:Colors.transparent,
          borderRadius: BorderRadius.circular(0),
          // border: const Border.fromBorderSide(
          //     BorderSide(color: Colors.black45, width: 0.8))
        ),
        child: DropdownButton<String>(
          value: _value.value ?? defaultValue,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          borderRadius: BorderRadius.circular(0),
          style: GoogleFonts.poppins(),
          underline: Container(
            height: 2,
          ),
          onChanged: (String? newValue) {},
          items: values.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              onTap: () {
                _value(value);
                onSelect(value);
              },
              child: Text(
                "$value days",
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
