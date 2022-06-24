// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
//
// /// a simple interface for storing bool states, allows you to keep widget
// /// specific state that survives rebuilds with an associated key
// /// anyone can update this state and the widget reacts accordingly.
// /// Eg. this is used by birthdayCard widget to store whether the widget is in display or edit mode.
// class BoolStatesController {
//   static final RxMap<String, RxBool> __listeners = <String, RxBool>{}.obs;
//
//   static RxBool listenToState({required String key}) {
//     __listeners.putIfAbsent(key, () => false.obs);
//
//     return __listeners[key]!;
//   }
//
//   static setState({required String key, required bool state}) {
//     __listeners.putIfAbsent(key, () => state.obs);
//   }
//
//   static updateState({required String key, required bool state}) {
//     __listeners.putIfAbsent(key, () => state.obs);
//     __listeners[key]!(state);
//   }
// }
//
// class BoolStateManager {
//   final RxBool __listener = false.obs;
//
//   RxBool get state {
//     return __listener;
//   }
//
//   init({required bool state}) {
//     __listener(state);
//   }
//
//   update({required bool state}) {
//     __listener(state);
//   }
// }
