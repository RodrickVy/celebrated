
import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/cards/view/components/card.sign.page.dart';
import 'package:celebrated/live.editor/controller/canvas.controller.dart';
import 'package:celebrated/live.editor/model/live.element.dart';
import 'package:flutter/material.dart';

/// A representation of a type of element that can be edited in LiveEditor

abstract class LiveEditorElementType {
  ///[name] and [icon] are used to build the button to add this element.

  /// The name of this type of element
  String get name;

  /// The icon for this element
  String get icon;

  /// A function that builds a view for editing a [LiveEditorElement].
  /// Its given controller and the element its editing allowing you to perform edit actions.
  /// Its used in [LiveEditorElementType] as each type of element has its own type of edit controls.
  /// [T] is the [LiveEditorElement] this widget is for.
  /// Called when any element of this type is in focus , its given a controller,
  /// to perform edit actions like delete, save and etc.
  Widget editControlsBuilder<T extends LiveEditorElement>(
      {required LiveEditorCanvasController controller, required T element});

  /// Builds a default start version of this element.
  /// Called  everytime a new blank element is added to the editor.
  /// The [id] and  [initialPosition] for the element are given when this method is called,
  /// and must be used in the creation of this new element.
  /// makes sure the type of this element, matches the name of its  corresponding [LiveEditorElementType]
  /// Called when a new element of this type is needed, like when the user adds a new element.
  LiveEditorElement defaultElementBuilder({required String id, required XYPair initialPosition});

  /// Builds the actual widget for the [LiveEditorElement]
  /// note: this widget will be wrapped by the [LiveEditable] widget giving the drag, resize+ functionalities.
  /// [T] is the [LiveEditorElement] this widget is for.
  /// Builds the actual view of the element that's going to be wrapped in the [LiveEditable] widget.
  Widget elementWidgetBuilder<T extends LiveEditorElement>(
      {required LiveEditorCanvasController controller, required T element});

  /// Transforms an element to a json
  /// A transformer to serialize this  types element to json
  Map<String, dynamic> toJson<T extends LiveEditorElement>(T element);

  /// Transforms an element from json to a [LiveEditorElement] of type [T]
  T fromJson<T extends LiveEditorElement>(Map<String, dynamic> element);

  const LiveEditorElementType();
}
