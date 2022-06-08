

import 'amen.content.actions.dart';

class AmenContentResponse<T> {
  final AmenContentActions type;
  final T data;
  final String key;



  AmenContentResponse( {required this.key, required this.type, required this.data});

  T getData(){
    return data;
  }
}


