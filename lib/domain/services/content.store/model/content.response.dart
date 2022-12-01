

import 'store.actions.dart';

class ContentStoreResponse<T> {
  final ContentStoreActions type;
  final T data;
  final String key;



  ContentStoreResponse( {required this.key, required this.type, required this.data});

  T getData(){
    return data;
  }
}


