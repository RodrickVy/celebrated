import 'package:celebrated/app.theme.dart';
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
      this.minWidth = 50,
      this.buttonHeight =60,
      this.elevation,
      this.isTextButton = false,
       Key? key ,
      required this.onPressed,
      this.label})
      : super(key: key) {
    assert([child, label].any((element) => element == null),
        "Both Child and Label property cant be used , they override each other.");
  }

  @override
  Widget build(BuildContext context) {
    if (isTextButton == true) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          shape: AppTheme.shape.copyWith(side: BorderSide.none),
          minimumSize: Size(minWidth, buttonHeight),
        ),
        child: child ??
            Text(
              "$label",
            ),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(14),
        shadowColor: Colors.transparent,
        minimumSize: Size(minWidth,buttonHeight),
        shape: AppTheme.shape,
        elevation: 0,
        // splashColor: Theme.of(context).highlightColor,
      ),
      child: child ??
          Text(
            "$label",
          ),
    );
  }
}
