

import 'package:celebrated/domain/model/imodel.dart';

abstract class IModelFactory<M extends IModel> {
  M fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(M model);
}
