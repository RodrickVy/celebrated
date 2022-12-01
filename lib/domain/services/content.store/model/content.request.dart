import 'package:celebrated/domain/model/imodel.factory.dart';
import 'package:celebrated/domain/services/content.store/model/content.model.dart';
import 'package:celebrated/domain/services/content.store/model/store.actions.dart';



class  ContentStoreRequest<T extends IContent,F extends IModelFactory> {

  final ContentStoreActions action;
  final String key;
  final F factory;
  final T empty;
  final String db;
  final Map<String,dynamic> parameters;

  ContentStoreRequest( {
    required this.parameters ,
    required this.key,
    required this.db,
    required this.factory,
    required this.empty,
    required this.action
  });

}