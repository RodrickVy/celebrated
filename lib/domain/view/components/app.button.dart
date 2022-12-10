import 'dart:async';

import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:flutter/material.dart';

/// simple app button with little customization to give consistence look throughout the app.
class AppButton extends StatelessWidget {
  final FutureOr<dynamic> Function() onPressed;
  final String? label;
  final double minWidth;
  final double buttonHeight;
  final double? elevation;
  final bool isTextButton;

  /// a key to the loading state, for showing spinner as the action runs.
  final  Key? loadStateKey;
  /// overrides the the text widget holding the label
  final Widget? child;
  final Color? color;

  AppButton(
      {this.child,
      this.minWidth = 50,
      this.buttonHeight =60,
        this.color,
      this.elevation,
      this.isTextButton = false,
       this.loadStateKey ,
      required this.onPressed,
      this.label})
      : super(key: null) {
    assert([child, label].any((element) => element == null),
        "Both Child and Label property cant be used , they override each other.");
  }

  @override
  Widget build(BuildContext context) {
    return button;
  }

  void whenPressed()async{
    if(loadStateKey != null){
      FeedbackService.spinnerUpdateState(key: loadStateKey!, isOn: true);
    }
    await onPressed();
    if(loadStateKey != null){
      FeedbackService.spinnerUpdateState(key: loadStateKey!, isOn: false);
    }
  }


  Widget get button{
    if (isTextButton == true) {
      return TextButton(
        onPressed: (){
          whenPressed();
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: color,
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
      onPressed: (){
        whenPressed();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(14),
        shadowColor: Colors.transparent,
        backgroundColor: color,
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

  AppButton copyWith({
    Future<dynamic> Function()? onPressed,
    String? label,
    double? minWidth,
    double? buttonHeight,
    double? elevation,
    bool? isTextButton,
    Key? spinnerKey,
    Widget? child,
  }) {
    return AppButton(
      onPressed: onPressed ?? this.onPressed,
      label: label ?? this.label,
      minWidth: minWidth ?? this.minWidth,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      elevation: elevation ?? this.elevation,
      isTextButton: isTextButton ?? this.isTextButton,
      loadStateKey: spinnerKey ?? this.loadStateKey,
      child: child ?? this.child,
    );
  }
}



class AppButtonIcon extends StatelessWidget {
  final FutureOr<dynamic> Function() onPressed;
  final String? label;
  final double minWidth;
  final double buttonHeight;
  final double? elevation;
  final bool isTextButton;
 final Icon icon;
  final Color? color;
  final Widget? child;
final  Key? loadStateKey;
  AppButtonIcon(
      {this.child,
        this.minWidth = 50,
        this.buttonHeight =60,
        this.elevation,
        required this.icon,
        this.isTextButton = false,
        this.loadStateKey ,
        required this.onPressed,
        this.label, this.color})
      : super(key:null) {
    assert([child, label].any((element) => element == null),
    "Both Child and Label property cant be used , they override each other.");
  }

  @override
  Widget build(BuildContext context) {
    return button;
  }

  Widget get button{
    if (isTextButton == true) {
      return TextButton.icon(
        onPressed: (){
          whenPressed();
        },
        style: TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: AppTheme.shape.copyWith(side: BorderSide.none),
          minimumSize: Size(minWidth, buttonHeight),
        ),
        label: child ??
            Text(
              "$label",
            ),
        icon: icon,
      );
    }
    return ElevatedButton.icon(
      onPressed: (){
        whenPressed();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(14),
        shadowColor: Colors.transparent,
        backgroundColor: color,
        minimumSize: Size(minWidth,buttonHeight),
        shape: AppTheme.shape,
        elevation: 0,
        // splashColor: Theme.of(context).highlightColor,
      ),
      label: child ??
          Text(
            "$label",
          ),
      icon: icon,
    );
  }

  void whenPressed()async{
    if(loadStateKey != null){
      FeedbackService.spinnerUpdateState(key: loadStateKey!, isOn: true);
    }
     await onPressed();
    if(loadStateKey != null){
      FeedbackService.spinnerUpdateState(key: loadStateKey!, isOn: false);
    }
  }

  AppButtonIcon copyWith({
    Future<dynamic> Function()? onPressed,
    String? label,
    double? minWidth,
    double? buttonHeight,
    double? elevation,
    bool? isTextButton,
    Icon? icon,
    Widget? child,
    Key? spinnerKey,
  }) {
    return AppButtonIcon(
      onPressed: onPressed ?? this.onPressed,
      label: label ?? this.label,
      minWidth: minWidth ?? this.minWidth,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      elevation: elevation ?? this.elevation,
      isTextButton: isTextButton ?? this.isTextButton,
      icon: icon ?? this.icon,
      loadStateKey: spinnerKey ?? loadStateKey,
      child: child ?? this.child,
    );
  }
}
class AppIconButton extends StatelessWidget {
  final FutureOr<dynamic> Function() onPressed;
  /// nobackground
  final bool noBg;
  final Icon icon;
  final  Key? loadStateKey;
  const AppIconButton(
      {
        required this.icon,
        this.noBg = false,
        this.loadStateKey ,
        required this.onPressed,})
      : super(key:null);

  @override
  Widget build(BuildContext context) {
    return button;
  }

  Widget get button{
    if (noBg == true) {
      return IconButton(
        onPressed: (){
          whenPressed();
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          shape: AppTheme.shape.copyWith(side: BorderSide.none),
        ),
        icon: icon,
      );
    }
    return IconButton(
      onPressed: (){
        whenPressed();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(14),
        shadowColor: Colors.transparent,
        backgroundColor: AppSwatch.primary,
        shape: AppTheme.shape,
        elevation: 0,
        // splashColor: Theme.of(context).highlightColor,
      ),
      icon: icon,
    );
  }

  void whenPressed()async{
    if(loadStateKey != null){
      FeedbackService.spinnerUpdateState(key: loadStateKey!, isOn: true);
    }
    await onPressed();
    if(loadStateKey != null){
      FeedbackService.spinnerUpdateState(key: loadStateKey!, isOn: false);
    }
  }



}
