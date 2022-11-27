import 'package:get/get.dart';

/// App's service for keeping track of which components have been initialized , useful to delay showing UI before critical info is load. 
/// This avoid , huge layout shifts and shocking the user. 
class InitStateController {
  static final RxMap<String, RxBool> __listeners = <String, RxBool>{}.obs;

  
  
  
  
  static RxBool listenToLoadState({required String key}) {
    __listeners.putIfAbsent(key, () => false.obs);

    return __listeners[key]!;
  }

  static setState({required String key, required bool loaded}) {
    __listeners.putIfAbsent(key, () => loaded.obs);
  }

  static updateState({required String key, required bool state}) {
    __listeners.putIfAbsent(key, () => state.obs);
    __listeners[key]!(state);
  }
}



 const String listsLoadState = "Getting birthday lists";
const String authLoadState = "authState";