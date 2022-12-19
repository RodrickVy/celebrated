import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/domain/model/imodel.factory.dart';

class CelebrationCardFactory extends IModelFactory<CelebrationCard> {
  @override
  CelebrationCard fromJson(Map<String, dynamic> json) {
    return CelebrationCard.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(CelebrationCard model) {
    return model.toMap(model);
  }
}
