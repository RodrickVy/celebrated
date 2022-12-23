import 'package:celebrated/live.editor/model/live.element.dart';
import 'package:celebrated/live.editor/model/live.element.type.dart';
import 'package:celebrated/util/id.generator.dart';

/// A representation of a LiveEditor canvas, where elements of all sorts can live
/// The width and height of the are given once on creation and from there the
/// canvas simply scales itself and all its elements to fit as much as possible
/// any screenshot while still maintaining its width/height ratio.
class LiveEditorCanvas {
  /// an Id  for this canvas
  final String id;

  /// The width  given at creation of this canvas,
  final double width;

  /// The height given at creation of this canvas, from here is the canvas simply scales itself and all its elements
  /// to any screen size but maintains this original width.
  final double height;

  /// All the elements in this canvas
  final List<LiveEditorElement> elements;

  static LiveEditorCanvas get generateNew =>
  LiveEditorCanvas(width: 0, height: 0, id: IDGenerator.generateId(13, 'Canvas'), elements: []);

  LiveEditorCanvas({required this.width, required this.id, required this.height, required this.elements});

  /// Serializes all the elements in this canvas, using their respective types transformers.
  List<Map<String, dynamic>> serializeElements({required List<LiveEditorElementType> types}) {
    return types.map((LiveEditorElementType type) {
      return elements.where((element) => element.type == type.name).map((e) => type.toJson(e));
    }).fold([], (previousValue, element) => [...previousValue, ...element]);
  }

  Map<String, dynamic> toJson(List<Map<String, dynamic>> elements) {
    return {'width': width, 'height': height, 'elements': elements, "id": id};
  }

  LiveEditorCanvas copyWith({
    String? id,
    double? width,
    double? height,
    List<LiveEditorElement>? elements,
  }) {
    return LiveEditorCanvas(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      elements: elements ?? this.elements,
    );
  }
}