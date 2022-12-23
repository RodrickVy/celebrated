import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/cards/model/text.style.dart';
import 'package:celebrated/cards/view/components/card.sign.page.dart';
import 'package:celebrated/live.editor/model/live.canvas.dart';
import 'package:celebrated/live.editor/model/live.element.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class CardSign {
  final String id;
  final Map<String, LiveEditorElement> _elements;

  Map<String, LiveEditorElement> get elements => _elements;

  CardSign({required this.id, required final List<LiveEditorElement> elements})
      : _elements = Map.fromIterable(elements, key: (value) => value.id, value: (value) => value);

  XYPair get unUsedPosition {
    if(elements.isEmpty){
      return const XYPair(0, 0);
    }
    final List<XYPair> usedPoints = elements.values.map((e) => XYPair(e.posY, e.posX)).toList();
    usedPoints.sort((XYPair a, XYPair b) {
      double aValue = a.yValue / a.yValue;
      double bValue = b.yValue / b.xValue;
      return aValue.compareTo(bValue);
    });

    return usedPoints.last;
  }

  Map<String, dynamic> toMap() {
    return {
      'elements': _elements.values.map((e) => e.toMap()).toList(),
      'id': id,
    };
  }

  factory CardSign.fromMap(Map<String, dynamic> map) {
    return CardSign(
        elements: List.from(map['elements']).map((e) => LiveEditorElement.fromMap(e)).toList(), id: map['id']);
  }

  CardSign copyWith({
    String? id,
    List<LiveEditorElement>? elements,
  }) {
    return CardSign(
      id: id ?? this.id,
      elements: elements ?? _elements.values.toList(),
    );
  }

  CardSign withElement(LiveEditorElement element) {
    _elements[element.id] = element;
    return this;
  }

  CardSign removeElement(LiveEditorElement element) {
    _elements.remove(element.id);
    return this;
  }

  
  factory CardSign.fromLiveCanvas(LiveEditorCanvas canvas){
    return  CardSign(id: canvas.id, elements: canvas.elements);
  }

  withLiveCanvas(LiveEditorCanvas canvas){
    return  CardSign(id: id, elements: canvas.elements);
  }

  LiveEditorCanvas toCanvas(Size dimensions){
    return LiveEditorCanvas(width: dimensions.width,height: dimensions.height,elements: elements.values.toList(), id: id);
  }
}

enum SigElementType { text, image }



double getTextAutoWidth(String text, TextStyle style) {
  final List<int> lineCharLengths = text.split("\n").map((e) => e.length).toList();
  lineCharLengths.sort();

  return lineCharLengths.first * (style.letterSpacing ?? 1);
}

double getTextAutoHeight(String text, TextStyle style) {
  final int lines = text
      .split("\n")
      .length;
  final double lineHeight = (style.height ?? 1.0) * (style.fontSize ?? 16.0);
  return lines * lineHeight;
}
