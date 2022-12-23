import 'package:celebrated/cards/view/components/card.sign.page.dart';
import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';

extension TextStyleToMap on TextStyle {
  Map<String, dynamic> toMap() {
    return {
      'fontFamily': fontFamily,
      'color': color?.value,
      'fontWeight': fontWeight?.index,
      'fontSize': fontSize,
      'backgroundColor': (backgroundColor ?? decorationColor ?? background?.color)?.value
    };
  }
}

extension TextStyleFromMap on Map<String, dynamic> {
  TextStyle get asTextStyle {
    return TextStyle(
      fontFamily: this['fontFamily'],
      color: this['color'] != null ? Color(this['color']) : null,
      backgroundColor: this['backgroundColor'] != null ? Color(this['backgroundColor']) : null,
      fontSize: this['fontSize'],
      fontWeight: FontWeight.values[this['fontWeight'] ?? 2],
    );
  }

  TextAlign get asAlignment {
    return TextAlign.values.byName(this["align"]??'center');
  }

  SignElementImage get toImage{
    print(this);
    return SignElementImage.fromJson(this);
  }
}
