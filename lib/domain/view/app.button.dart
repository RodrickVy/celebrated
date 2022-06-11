import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FormSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? label;
  final double minWidth;
  final double buttonHeight;
  final double? elevation;


  /// overrides the the text widget holding the label
  final Widget? child;

  FormSubmitButton(
      {this.child,
      this.minWidth = 190,
      this.buttonHeight = 30,
      this.elevation,
      required Key key,
      required this.onPressed,
      this.label})
      : super(key: key) {
    assert([child, label].any((element) => element == null), "Both Child and Label property cant be used , they override each other.");
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(14),
            shadowColor: Colors.transparent,
            onSurface:  Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide.none,
            ),
            elevation: 0,
            // splashColor: Theme.of(context).highlightColor,
          ),
      child: child ?? Text("$label",),
    );
  }
}
