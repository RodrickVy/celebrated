import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';

import 'package:celebrated/authenticate/models/auth.with.dart';
import 'package:celebrated/util/list.extension.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

enum AuthProviderAction { signUp, signIn }
/// provider buttons to be used  by auth later , currently not in use
class AuthProviderButtons extends StatelessWidget {
  final bool darkMode = false;
  final AuthButtonStyle? style = AuthButtonStyle(
    padding: const EdgeInsets.all(12),

    borderWidth:  AppTheme.shape.side.width,
    separator: 40,
borderRadius: AppTheme.borderRadius,
    iconType: AuthIconType.secondary,
    textStyle: GoogleFonts.poppins(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
    //buttonStyle?.textStyle,
    iconBackground: Get.theme.colorScheme.onBackground,
    elevation: 0,
    buttonColor: Get.theme.colorScheme.primary.withAlpha(67),
  );

  final double runSpacing = 10;
  final List<AuthWith> methods = [
    AuthWith.Google,
    // AuthWith.Apple,
    // AuthWith.Facebook,
    // AuthWith.Github
  ];
  final AuthProviderAction action = AuthProviderAction.signIn;
  final bool showName = true;

  AuthProviderButtons({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FeedbackSpinner(
      spinnerKey: FeedbackSpinKeys.auth,
      child: SizedBox(
        width: Get.width-30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[...buttonsWithSpacing],
        ),
      ),
    );
  }

  List<Widget> get buttonsWithSpacing {
    List<Widget> widgets = [];

    methods
        .map((method) => _methodButton(method))
        .toList()
        .forEach2((Widget button, int index) {
      if (index == methods.length - 1) {
        widgets.add(button);
      } else {
        if (index == 0 && methods.length == 1) {
          widgets.add(button);
        } else {
          widgets.add(button);
          widgets.add(space);
        }
      }
    });

    return widgets;
  }

  Widget _methodButton(AuthWith method)  {
    switch (method) {
      case AuthWith.EmailLink:
        return EmailAuthButton(
          onPressed: () {
            _action(method);
          },
          text: "$_actionText ${showName ? 'Email' : ''}",
          darkMode: darkMode,
          style: style,
        );
      case AuthWith.Facebook:
        return  FacebookAuthButton(
          onPressed: () {
            _action(method);
          },
          // separator: iconSeparator,
          text: "$_actionText ${showName ? 'Facebook' : ''}",
          darkMode: darkMode,
          style: style,
          
        );
      case AuthWith.Github:
        return GithubAuthButton(
          onPressed: () {
            _action(method);
          },
          //
          text: "$_actionText ${showName ? 'Github' : ''}",
          darkMode: darkMode,
          style: style,
          // width: width,
          // padding: padding,
          
          // textStyle: textStyle,
          // iconStyle: iconStyle,
          // buttonColor: buttonColor,
          // borderRadius: borderRadius,
          // borderColor: borderColor,
          // borderWidth: borderWidth,
          // iconSize: iconSize,
          // iconBackground: iconBackground,
          // shadowColor: shadowColor,
          // splashColor: splashColor,
          // elevation: elevation,
          // height: buttonHeight,
        );
      case AuthWith.Google:
        return GoogleAuthButton(
          onPressed: () {
            _action(method);
          },
          // separator: iconSeparator + (iconSeparator * 1.3),

          text: "$_actionText ${showName ? 'Google' : ''}",
          darkMode: darkMode,
          style: style,
          // width: width,
          // padding: padding,
          // textStyle: textStyle,
          // iconStyle: iconStyle,
          // buttonColor: buttonColor,
          // borderRadius: borderRadius,
          // borderColor: borderColor,
          // borderWidth: borderWidth,
          // iconSize: iconSize,
          // iconBackground: iconBackground,
          // shadowColor: shadowColor,
          // splashColor: splashColor,
          // elevation: elevation,
          // height: buttonHeight,
        );
      case AuthWith.Twitter:
        return TwitterAuthButton(
          onPressed: () {
            _action(method);
          },
          
          // separator: iconSeparator + (iconSeparator / 2),
          text: "$_actionText ${showName ? 'Twitter' : ''}",
          darkMode: darkMode,
          style: style,
          // width: width,
          // padding: padding,
          // textStyle: textStyle,
          // iconStyle: iconStyle,
          // buttonColor: buttonColor,
          // borderRadius: borderRadius,
          // borderColor: borderColor,
          // borderWidth: borderWidth,
          // iconSize: iconSize,
          // iconBackground: iconBackground,
          // shadowColor: shadowColor,
          // splashColor: splashColor,
          // elevation: elevation,
          // height: buttonHeight,
        );
      case AuthWith.Apple:
        return AppleAuthButton(
          onPressed: () {
            _action(method);
          },
          
          text: "$_actionText ${showName ? 'Apple' : ''}",
          darkMode: darkMode,
          style: style,
        );
      case AuthWith.Microsoft:
        return MicrosoftAuthButton(
          onPressed: () {
            _action(method);
          },
          
          text: "$_actionText ${showName ? 'Microsoft' : ''}",
          darkMode: darkMode,
          style: style,
        );
      case AuthWith.Password:
        return EmailAuthButton(
          onPressed: () {
            _action(method);
          },
          
          text: "$_actionText ${showName ? 'Password' : ''}",
          darkMode: darkMode,
          style: style,
        );
      default:
        return const SizedBox(
          height: 0,
          width: 0,
        );
    }

  }

  String get _actionText {
    switch (action) {
      case AuthProviderAction.signUp:
        return "Sign up with";
      case AuthProviderAction.signIn:
        return "Sign in with";
    }
  }

  SizedBox get space {
    return SizedBox(
      height: runSpacing,
    );
  }

  _action(AuthWith action) async {
    FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.auth, isOn: true);
    await () async {
      switch (action) {
        case AuthWith.EmailLink:
        case AuthWith.Facebook:
          return authService.signInWithPopUpProvider(
              provider: FacebookAuthProvider());
        case AuthWith.Github:
          return authService.signInWithPopUpProvider(
              provider: GithubAuthProvider());
        case AuthWith.Google:
          return authService.signInWithGoogle() ;
        case AuthWith.Apple:
        case AuthWith.Microsoft:
        case AuthWith.OAuth:
        case AuthWith.Phone:
        case AuthWith.SAML:
        case AuthWith.GameCenter:
        case AuthWith.Yahoo:
        case AuthWith.Password:
        case AuthWith.Anon:
        case AuthWith.Twitter:
          return authService.signInWithPopUpProvider(
              provider: TwitterAuthProvider());
      }
    }();

    FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.auth, isOn: false);
  }
}
