import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/cards/model/text.style.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/live.editor/controller/canvas.controller.dart';
import 'package:celebrated/live.editor/model/live.element.dart';
import 'package:celebrated/live.editor/model/live.element.type.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_editor/super_editor.dart';

class TextElementType implements LiveEditorElementType {
  @override
  String get icon => 'text';

  @override
  String get name => "Text";

  @override
  LiveEditorElement defaultElementBuilder({required String id, required XYPair initialPosition}) {
    return LiveEditorElement(type: name, id: id, value: "type something", metadata: GoogleFonts.aclonica().toMap());
  }

  @override
  Widget editControlsBuilder<T extends LiveEditorElement>(
      {required LiveEditorCanvasController controller, required T element}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIconButton(
          onPressed: () {
            controller.removeElement(element.id);
          },
          icon: const Icon(Icons.delete),
        ),
        AppIconButton(
          onPressed: () {
            controller.dropFocus();
          },
          icon: const Icon(Icons.done),
        ),
      ],
    );
  }

  @override
  Widget elementWidgetBuilder<T extends LiveEditorElement>(
      {required LiveEditorCanvasController controller, required T element}) {
    return SuperEditor(
      focusNode: null,
        gestureMode: DocumentGestureMode.mouse,
        stylesheet:
            Stylesheet(rules: [
              StyleRule(BlockSelector.all, (p0, p1) =>  element.metadata)
            ], inlineTextStyler: (Set<Attribution> attributions, TextStyle existingStyle) {
              return element.metadata.asTextStyle;
            }),
        editor: DocumentEditor(
            document: MutableDocument(nodes: [
          ParagraphNode(
              id: element.id,
              text: AttributedText(text: element.value,),
              metadata: element.metadata)
        ])));
  }

  @override
  T fromJson<T extends LiveEditorElement>(Map<String, dynamic> map) {
    return LiveEditorElement.fromMap(map) as T;
  }

  @override
  Map<String, dynamic> toJson<T extends LiveEditorElement>(T element) {
    return element.toMap();
  }
}
