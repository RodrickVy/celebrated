import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/domain/model/imodel.factory.dart';

/// factory for birthday card theme
class CelebrationCardThemeFactory extends IModelFactory<CelebrationCardTheme> {
  @override
  CelebrationCardTheme fromJson(Map<String, dynamic> json) {
    return CelebrationCardTheme.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(CelebrationCardTheme model) {
    return model.toMap();
  }
}
