import 'package:celebrated/domain/model/imodel.factory.dart';
import 'package:celebrated/domain/repository/amen.content/model/amen.content.actions.dart';
import 'package:celebrated/domain/repository/amen.content/model/content.model.dart';


class  AmenContentRequest<T extends AfroContent,F extends IModelFactory> {

  final AmenContentActions action;
  final String key;
  final F factory;
  final T empty;
  final String db;
  final Map<String,dynamic> parameters;

  AmenContentRequest( {
    required this.parameters ,
    required this.key,
    required this.db,
    required this.factory,
    required this.empty,
    required this.action
  });

}