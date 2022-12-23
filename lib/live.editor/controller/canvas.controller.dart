import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/live.editor/model/live.canvas.dart';
import 'package:celebrated/live.editor/model/live.element.dart';
import 'package:celebrated/live.editor/model/live.element.type.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

/// Controls the edit,save,delete, focus+ functionalities for a canvas.
class LiveEditorCanvasController {
  /// An ephemeral way to track the elements currently being edited, each element can be listened to individually
   late RxMap<String, Rx<LiveEditorElement>> trackableElements;

  /// The current element that's in focus -> the one currently being edited/dragged
  static RxString focusedElementId = ''.obs;

  /// The element types this canvasEditor is going to be supporting,
  /// If [canvas]  has any elements whose types are not specified ,
  /// they will not be seen in the editor.
  final List<LiveEditorElementType> elementTypes;

  /// The canvas that's going to be edited,
  /// the data comes through here and out through the [saveCanvas] method.
  final LiveEditorCanvas canvas;

  LiveEditorCanvasController({
    required this.canvas,
    required this.elementTypes,
    required this.onSaveCanvas,
    required this.onDeleteCanvas,
    this.onFocusChanged,
    this.onElementAdded,
    this.onElementRemoved,
    this.onElementUpdated,
  }) {
    trackableElements = _elementsToTrackable(canvas.elements).obs;
  }

  /// The current canvas converted to json
  Map<String, dynamic> get serializedCanvas {
    return currentCanvas.toJson(currentCanvas.serializeElements(types: elementTypes));
  }

  /// a pure list of the current elements from [trackableElements]
  List<LiveEditorElement> get currentElements => trackableElements.values.map((e) => e.value).toList();

  /// Gives you the current canvas with the updated list of elements
  LiveEditorCanvas get currentCanvas {
    return canvas.copyWith(elements: currentElements);
  }

  LiveEditorElement? get elementInFocus =>
      focusedElementId.value.isEmpty ? null : trackElement(focusedElementId.value).value;

  /// Allows you to track an element individually by its id.
  /// If id doesnt exist a no element found error is thrown.
  Rx<LiveEditorElement> trackElement(String id) {
    return trackableElements[id]!;
  }

  /// Returns the [LiveEditorElementType] instance associated with this element if it exists.
  LiveEditorElementType? elementType(LiveEditorElement element) {
    try {
      final LiveEditorElementType type = elementTypes.firstWhere((type) => type.name == element.type);
      return type;
    } catch (_) {
      return null;
    }
  }

  ///Transforms elements into a Map indexable by the element's id and also individually listenable.
  Map<String, Rx<LiveEditorElement>> _elementsToTrackable(List<LiveEditorElement> elements) {
    return elements.map((element) {
      return MapEntry(element.id, element.obs);
    }).fold({}, (previousValue, el) => {...previousValue, el.key: el.value});
  }

  XYPair computeUnUsedPosition() {
    if (trackableElements.isEmpty) {
      return const XYPair(0, 0);
    }
    final List<XYPair> usedPoints = trackableElements.values.map((e) => XYPair(e.value.posY, e.value.posX)).toList();
    usedPoints.sort((XYPair a, XYPair b) {
      double aValue = a.yValue / a.yValue;
      double bValue = b.yValue / b.xValue;
      return aValue.compareTo(bValue);
    });

    return usedPoints.last;
  }

  Future<void> saveCanvas() async {
    await onSaveCanvas(currentCanvas, serializedCanvas);
  }

  /// Called when one wants to delete this canvas
  Future<void> deleteCanvas() async {
    await onDeleteCanvas(currentCanvas, serializedCanvas);
  }

  /// Updates the focus of the current element
  /// [id] must correspond to an element's id failure to do this will results in error
  void focusElement(String id) {
    focusedElementId(id);
    if (onFocusChanged != null) {
      onFocusChanged!(trackableElements[id]!.value);
    }
  }

  /// drops the focus of elements, meaning none is selected
  void dropFocus() {
    focusedElementId('');
    if (onFocusChanged != null) {
      onFocusChanged!(null);
    }
  }

  /// Generates an Id unique to the [element]
  /// [type] is the type of element this is.
  String _generateId(String type) {
    return IDGenerator.generateId(13, type + DateTime.now().microsecondsSinceEpoch.toString());
  }

  void addElement(LiveEditorElementType type) {
    final LiveEditorElement newElement =
        type.defaultElementBuilder(id: _generateId(type.name), initialPosition: computeUnUsedPosition());
    trackableElements[newElement.id] = newElement.obs;
    if (onElementAdded != null) {
      onElementAdded!(newElement);
    }
  }

  void removeElement(String id) {
    // final LiveEditorElement element = trackableElements[id]!.value;
    trackableElements.remove(id);
    if (onElementRemoved != null) {
      onElementRemoved!(id);
    }
    dropFocus();
  }

  void updateElement(LiveEditorElement element) {
    trackableElements[element.id]!(element);
    if (onElementUpdated != null) {
      onElementUpdated!(element);
    }
  }

  // Overridable -s : These are methods one must override to customize LiveEditor

  /// Called every time this canvas is saved, weather auto-triggered after changes or manually by the user.
  /// You can then save [currentCanvas] data where you want ,
  /// and can use the [serializedCanvas] to quickly save the serialized version of this canvas to a db.
  final Future<bool> Function(LiveEditorCanvas canvas, Map<String, dynamic> jsonCanvas) onSaveCanvas;

  /// Called when this canvas is deleted
  final Future<bool> Function(LiveEditorCanvas canvas, Map<String, dynamic> jsonCanvas) onDeleteCanvas;

  /// Called when focus changes (the current element being edited)
  /// [element] is null if no element is in focus.
  final void Function(LiveEditorElement? element)? onFocusChanged;

  /// Called when a new element is added
  final void Function(LiveEditorElement element)? onElementAdded;

  /// Called when an element is removed
  /// giving you the element that has just been removed
  final void Function(String elementId)? onElementRemoved;

  /// Called when an element has just been updated, gives you the new version of the element.
  final void Function(LiveEditorElement element)? onElementUpdated;

  LiveEditorCanvasController copyWith({
    List<LiveEditorElementType>? elementTypes,
    LiveEditorCanvas? canvas,
    Future<bool> Function(LiveEditorCanvas canvas, Map<String, dynamic> jsonCanvas)? onSaveCanvas,
    Future<bool> Function(LiveEditorCanvas canvas, Map<String, dynamic> jsonCanvas)? onDeleteCanvas,
    void Function(LiveEditorElement? element)? onFocusChanged,
    void Function(LiveEditorElement element)? onElementAdded,
    void Function(String elementId)? onElementRemoved,
    void Function(LiveEditorElement element)? onElementUpdated,
  }) {
    return LiveEditorCanvasController(
      elementTypes: elementTypes ?? this.elementTypes,
      canvas: canvas ?? this.canvas,
      onSaveCanvas: onSaveCanvas ?? this.onSaveCanvas,
      onDeleteCanvas: onDeleteCanvas ?? this.onDeleteCanvas,
      onFocusChanged: onFocusChanged ?? this.onFocusChanged,
      onElementAdded: onElementAdded ?? this.onElementAdded,
      onElementRemoved: onElementRemoved ?? this.onElementRemoved,
      onElementUpdated: onElementUpdated ?? this.onElementUpdated,
    );
  }

  /// calculates the size of the  canvas on this screen based on its ratio
  Size canvasSizeOnScreen (Size screenSize){
    return fitRectOnScreen(screenSize, Size(canvas.width,canvas.height));
  }
}
