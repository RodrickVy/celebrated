import 'package:get/get.dart';

/// a simple interface for storing bool states, allows you to keep widget
/// specific state that survives rebuilds with an associated key
/// anyone can update this state and the widget reacts accordingly.
/// Eg. this is used by birthdayCard widget to store whether the widget is in display or edit mode.
class IBoolStatesController {

  static final RxMap<String, RxBool> __listeners = <String, RxBool>{}.obs;


  static RxBool listenToState({required String key}) {
    __listeners.putIfAbsent(key, () => false.obs);
    return __listeners[key]!;
  }

  static RxBool setState({required String key, required bool isOn}) {
    __listeners.putIfAbsent(key, () => isOn.obs);
    return __listeners[key]!;
  }

  static RxBool updateState({required String key, required bool isOn}) {
    __listeners.putIfAbsent(key, () => isOn.obs);
    __listeners[key]!(isOn);
    return __listeners[key]!;
  }


}
