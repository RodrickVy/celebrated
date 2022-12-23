import 'package:celebrated/domain/model/imodel.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class XYPair {
  final double yValue;
  final double xValue;

  const XYPair(this.xValue, this.yValue);

  Size get toSize => Size(xValue,yValue);

  Map<String, dynamic> toMap() {
    return {
      'x': xValue,
      'y': yValue,
    };
  }

  static XYPair empty() {
    return const XYPair(0, 0);
  }

  factory XYPair.fromMap(Map<String, dynamic> map) {
    return XYPair(
      map['x'] as double,
      map['y'] as double,
    );
  }
}

class CardTextStyle {
  final int color;
  final int background;
  final String fontFamily;
  final int fontWeight;
  final String alignment;

  const CardTextStyle(
      {required this.color,
      required this.background,
      required this.fontFamily,
      this.fontWeight = 1,
      this.alignment = "center"});

  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'background': background,
      'fontFamily': fontFamily,
      'fontWeight': fontWeight,
      'alignment': alignment,
    };
  }

  factory CardTextStyle.fromMap(Map<String, dynamic> map) {
    return CardTextStyle(
      color: map['color'] as int,
      background: map['background'] as int,
      fontFamily: map['fontFamily'] as String,
      fontWeight: map['fontWeight'] as int,
      alignment: map['alignment'] as String,
    );
  }

  Color get textColor => Color(color);

  Color get backgroundColor => Color(background);

  TextAlign get textAlignment {
    return TextAlign.values.byName(alignment);
  }

  FontWeight get matFontWeight {
    return FontWeight.values[fontWeight];
  }

  static CardTextStyle empty() {
    return const CardTextStyle(color: 1, background: 1, fontFamily: '');
  }

  factory CardTextStyle.fromTextStyle(TextStyle style, TextAlign align) {
    return CardTextStyle(
        color: style.color!.value,
        background: style.backgroundColor!.value,
        fontFamily: style.fontFamily!,
        fontWeight: style.fontWeight!.index,
        alignment: align.name);
  }

  TextStyle get toMaterial {
    return TextStyle(
      color: textColor,
      backgroundColor: backgroundColor,
      fontFamily: fontFamily,
      fontWeight: matFontWeight,
    );
  }
}

class CelebrationCardTheme implements IModel {
  @override
  final String id;
  final String cardFront;
  final String cardBack;
  final XYPair texPosition;
  final CardTextStyle textStyle;
  final XYPair cardRatio;
  final bool supportsText;

  CelebrationCardTheme({
    required this.cardFront,
    required this.cardBack,
    required this.cardRatio,
    this.supportsText = true,
    required this.id,
    this.textStyle = const CardTextStyle(color: 1, background: 1, fontFamily: ''),
    this.texPosition = const XYPair(10, 20),
  });

  static CelebrationCardTheme empty() {
    return CelebrationCardTheme(
      id: '',
      textStyle: CardTextStyle.empty(),
      cardFront: '',
      cardBack: '',
      cardRatio: XYPair.empty(),
    );
  }

  Color get backgroundColor => textStyle.backgroundColor;

  Color get foregroundColor => textStyle.textColor;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardFront': cardFront,
      'cardBack': cardBack,
      'texPosition': texPosition.toMap(),
      'textStyle': textStyle.toMap(),
      'cardRatio': cardRatio.toMap(),
      'supportsText': supportsText
    };
  }

  factory CelebrationCardTheme.fromMap(Map<String, dynamic> map) {
    return CelebrationCardTheme(
        id: map['id'] as String,
        cardFront: map['cardFront'] as String,
        cardBack: map['cardBack'] as String,
        texPosition: XYPair.fromMap(map['texPosition']),
        supportsText: map['supportsText'] ?? true,
        textStyle: CardTextStyle.fromMap(map['textStyle']),
        cardRatio: XYPair.fromMap(map['cardRatio']));
  }

  /// computes what the height and width of the card should be on the current [screenSize] based on the ratio
  Size computeSizeFromRatio(Size screenSize) {
    return getMaxFitSize(screenSize, cardRatio);
  }

  XYPair computeTextXYPosition(Size cardSize) {
    return XYPair(cardSize.height * (texPosition.xValue / 100), cardSize.height * (texPosition.yValue / 100));
  }
}

Size getMaxFitSize(Size screenSize, XYPair imageRatio) {
  // the difference in % between the x and y length of the card as a decimal
  double ratioPercentDifference = (imageRatio.yValue / imageRatio.xValue);

  double width = screenSize.width;
  double height = width * ratioPercentDifference;

  if (width <= screenSize.width && height <= screenSize.height) {
    return Size(width, height);
  } else {
    /// the only other case is when  height > screenSize.height
    final double difference = height - screenSize.height;
    height = height - difference;
    // the percentage of the decrease in height  as a decimal
    final double differencePercent = (difference / height);

    width = width - (width * differencePercent);

    return Size(width, height);
  }
}

Size fitRectOnScreen(Size screenSize, Size rectSize) {
  final Fraction fractionRation = Fraction(rectSize.width.toInt(), rectSize.height.toInt()).reduce();
  // the difference in % between the x and y length of the card as a decimal
  double ratioPercentDifference = (fractionRation.numerator/ fractionRation.denominator);

  double width = screenSize.width;
  double height = width * ratioPercentDifference;

  if (width <= screenSize.width && height <= screenSize.height) {
    return Size(width, height);
  } else {
    /// the only other case is when  height > screenSize.height
    final double difference = height - screenSize.height;
    height = height - difference;
    // the percentage of the decrease in height  as a decimal
    final double differencePercent = (difference / height);

    width = width - (width * differencePercent);

    return Size(width, height);
  }
}
