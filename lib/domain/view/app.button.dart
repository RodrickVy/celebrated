import 'package:flutter/material.dart';

/// simple app button with little customization to give consistence look throughout the app.
class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? label;
  final double minWidth;
  final double buttonHeight;
  final double? elevation;
  final bool isTextButton;


  /// overrides the the text widget holding the label
  final Widget? child;

  AppButton(
      {this.child,
      this.minWidth = 190,
      this.buttonHeight = 30,
      this.elevation,
        this.isTextButton = false,
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
            primary:isTextButton?Colors.transparent:null,
            onSurface:  Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide.none,
            ),
            elevation: 0,
            // splashColor: Theme.of(context).highlightColor,
          ),
      child: child ?? Text("$label",),
    );
  }
}
