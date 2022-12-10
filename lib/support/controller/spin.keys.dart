import 'package:flutter/material.dart';


/// used as keys to store state for feedback spinner system, only a
/// convention to avoid hardcoding the values.
class FeedbackSpinKeys {
  static Key passResetForm = const Key("passResetForm");
  
  /// all the loading indication related to authentication
  static Key auth = const Key("authSpinner");
  static Key loadState = const Key('loadState');

  static Key updateNameForm = const Key("updateNameForm");
  static Key updateBioForm = const Key("updateBioForm");
  static Key bugSubmitForm = const Key("bugSubmitForm");
  static Key appWide = const Key("appWide");
  static Key viewLoad = const Key("searchLoad");
  static Key listName = const Key("listName");


}
