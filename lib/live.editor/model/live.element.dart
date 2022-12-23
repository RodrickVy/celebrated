import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/cards/model/text.style.dart';
import 'package:flutter/material.dart';

class LiveEditorElement {
  final String type;
  final String id;
  final String value;
  final Map<String, dynamic> metadata;
  final double posY;
  final double posX;
  final double width;
  final double height;

  const LiveEditorElement({this.posY = 0,
    this.posX = 0,
    required this.type,
    this.width = 60,
    this.height = 90,
    required this.id,
    required this.value,
    required this.metadata});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'id': id,
      'value': value,
      'metadata': metadata,
      'posY': posY,
      'posX': posX,
      'width': width,
      'height': height
    };
  }

  XYPair get position => XYPair(posX, posY);

  factory LiveEditorElement.text({
    required String id,
    required String value,
    required Map<String, dynamic> metadata,
  }) {
    return LiveEditorElement(
      type:'text',
      id: id,
      value: value,
      metadata: metadata,
      posX: 0,
      posY: 0,
      width: getTextAutoWidth(value, metadata.asTextStyle),
      height: getTextAutoHeight(value, metadata.asTextStyle),
    );
  }

  factory LiveEditorElement.image({
    required String id,
    required String value,
    required Map<String, dynamic> metadata,
  }) {
    final Size imageSize = fitRectOnScreen(
        const Size(300, 600), Size(metadata.toImage.width.toDouble(), metadata.toImage.height.toDouble(),));
    return LiveEditorElement(
      type: 'image',
      id: id,
      value: value,
      metadata: metadata,
      posX: 37,
      posY: 28,
      width: imageSize.width,
      height: imageSize.height,
    );
  }

  factory LiveEditorElement.fromMap(Map<String, dynamic> map) {
    return LiveEditorElement(
        type: map['type'],
        id: map['id'] as String,
        value: map['value'] as String,
        metadata: Map.from(map['metadata']),
        posX: map['posX'] ?? 0,
        posY: map['posY'] ?? 0,
        width: map['width'] ?? 0,
        height: map['height'] ?? 0);
  }

  LiveEditorElement copyWith({
    String? type,
    String? id,
    String? value,
    Map<String, dynamic>? metadata,
    double? posY,
    double? posX,
    double? width,
    double? height,
  }) {
    return LiveEditorElement(
      type: type ?? this.type,
      id: id ?? this.id,
      value: value ?? this.value,
      metadata: metadata ?? this.metadata,
      posY: posY ?? this.posY,
      posX: posX ?? this.posX,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}